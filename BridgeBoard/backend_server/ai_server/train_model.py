import torch
import torch.nn.functional as F
from torch.utils.data import Dataset, DataLoader
from transformers import (
    AutoTokenizer,
    AutoModelForSequenceClassification,
    get_cosine_schedule_with_warmup  # cosine 스케줄러로 변경
)
from torch.optim import AdamW
from sklearn.metrics import classification_report, confusion_matrix
import pandas as pd
import numpy as np
from tqdm import tqdm
import json
import os

# ========== 설정 (Phase 1 최적화) ==========
class TrainingConfig:
    MODEL_NAME         = "klue/roberta-large"
    NUM_LABELS         = 6
    MAX_LENGTH         = 256    # 문장 합치기 후 충분한 길이 확보
    BATCH_SIZE         = 8      # 256토큰 기준 VRAM 최적값
    GRAD_ACCUM_STEPS   = 4      # 유효 배치사이즈 = 8×4 = 32 (안정적 학습)
    EPOCHS             = 10
    LEARNING_RATE      = 3e-6   # large 모델 안정적 학습
    WARMUP_RATIO       = 0.1
    FOCAL_GAMMA        = 2.0
    LABEL_SMOOTHING    = 0.1    # 과적합 방지 (0.0~0.2)
    DATA_DIR           = "./data/processed"
    OUTPUT_DIR         = "./model_stage1"
    DEVICE             = torch.device("cuda" if torch.cuda.is_available() else "cpu")

config = TrainingConfig()

# ========== 데이터셋 ==========
class EmotionDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_length):
        self.texts      = texts
        self.labels     = labels
        self.tokenizer  = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.texts)

    def __getitem__(self, idx):
        encoding = self.tokenizer(
            str(self.texts[idx]),
            add_special_tokens=True,
            max_length=self.max_length,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        return {
            'input_ids':      encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten(),
            'labels':         torch.tensor(self.labels[idx], dtype=torch.long)
        }

# ========== Focal Loss + Label Smoothing ==========
class FocalLossWithSmoothing(torch.nn.Module):
    """
    Focal Loss + Label Smoothing 결합
    - Focal Loss: 어려운 샘플에 집중
    - Label Smoothing: 과적합 방지, 일반화 향상
    """
    def __init__(self, gamma=2.0, smoothing=0.1, weight=None):
        super().__init__()
        self.gamma     = gamma
        self.smoothing = smoothing
        self.weight    = weight

    def forward(self, logits, labels):
        num_classes = logits.size(-1)
        # Label Smoothing 적용
        with torch.no_grad():
            smooth_labels = torch.full_like(logits, self.smoothing / (num_classes - 1))
            smooth_labels.scatter_(1, labels.unsqueeze(1), 1.0 - self.smoothing)

        log_probs = F.log_softmax(logits, dim=-1)
        # 클래스 가중치 적용
        if self.weight is not None:
            log_probs = log_probs * self.weight.unsqueeze(0)

        # Label Smoothing Loss
        ls_loss = -(smooth_labels * log_probs).sum(dim=-1)

        # Focal 가중치
        probs  = torch.softmax(logits, dim=-1)
        pt     = probs.gather(1, labels.unsqueeze(1)).squeeze(1)
        focal  = ((1 - pt) ** self.gamma) * ls_loss

        return focal.mean()

# ========== 클래스 가중치 ==========
def compute_class_weights(labels, num_classes):
    counts  = np.bincount(labels, minlength=num_classes)
    weights = 1.0 / counts
    weights = weights / weights.sum() * num_classes
    return torch.tensor(weights, dtype=torch.float)

# ========== 학습 1 에포크 (Gradient Accumulation 적용) ==========
def train_epoch(model, dataloader, optimizer, scheduler, device, loss_fn):
    model.train()
    total_loss, correct, total = 0, 0, 0
    optimizer.zero_grad()

    for step, batch in enumerate(tqdm(dataloader, desc='Training')):
        input_ids      = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        labels         = batch['labels'].to(device)

        outputs = model(input_ids=input_ids, attention_mask=attention_mask)
        loss    = loss_fn(outputs.logits, labels)

        # Gradient Accumulation: 유효 배치사이즈 32로 학습
        loss = loss / config.GRAD_ACCUM_STEPS
        loss.backward()

        if (step + 1) % config.GRAD_ACCUM_STEPS == 0:
            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            scheduler.step()
            optimizer.zero_grad()

        total_loss += loss.item() * config.GRAD_ACCUM_STEPS
        preds       = torch.argmax(outputs.logits, dim=1)
        correct    += (preds == labels).sum().item()
        total      += labels.size(0)

    return total_loss / len(dataloader), correct / total

# ========== 평가 ==========
def evaluate(model, dataloader, device):
    model.eval()
    total_loss, all_preds, all_labels = 0, [], []
    loss_fn = torch.nn.CrossEntropyLoss()

    with torch.no_grad():
        for batch in tqdm(dataloader, desc='Evaluating'):
            input_ids      = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)
            labels         = batch['labels'].to(device)

            outputs     = model(input_ids=input_ids, attention_mask=attention_mask)
            loss        = loss_fn(outputs.logits, labels)
            total_loss += loss.item()

            preds = torch.argmax(outputs.logits, dim=1)
            all_preds.extend(preds.cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    return total_loss / len(dataloader), np.mean(np.array(all_preds) == np.array(all_labels)), all_preds, all_labels

# ========== 메인 ==========
def main():
    print("=" * 60)
    print("🚀 Phase 1 - 감정 분류 모델 최적화 학습")
    print("=" * 60)
    print(f"📍 디바이스:           {config.DEVICE}")
    print(f"📍 모델:               {config.MODEL_NAME}")
    print(f"📍 MAX_LENGTH:         {config.MAX_LENGTH}")
    print(f"📍 배치사이즈:          {config.BATCH_SIZE} (유효: {config.BATCH_SIZE * config.GRAD_ACCUM_STEPS})")
    print(f"📍 에포크:             {config.EPOCHS}")
    print(f"📍 Learning Rate:      {config.LEARNING_RATE}")
    print(f"📍 Label Smoothing:    {config.LABEL_SMOOTHING}")
    print(f"📍 Focal Loss gamma:   {config.FOCAL_GAMMA}")
    print(f"📍 스케줄러:           Cosine with Warmup")

    # 데이터 로드
    train_df = pd.read_csv(f'{config.DATA_DIR}/train.csv')
    val_df   = pd.read_csv(f'{config.DATA_DIR}/val.csv')
    test_df  = pd.read_csv(f'{config.DATA_DIR}/test.csv')
    with open(f'{config.DATA_DIR}/label_info.json', encoding='utf-8') as f:
        label_info = json.load(f)
    print(f"\n✅ Train {len(train_df)} / Val {len(val_df)} / Test {len(test_df)}")

    # 클래스 가중치 + Loss
    class_weights = compute_class_weights(train_df['label_id'].values, config.NUM_LABELS)
    print(f"⚖️  클래스 가중치: {class_weights.numpy().round(3)}")
    loss_fn = FocalLossWithSmoothing(
        gamma=config.FOCAL_GAMMA,
        smoothing=config.LABEL_SMOOTHING,
        weight=class_weights.to(config.DEVICE)
    )

    # 모델 초기화
    print("\n🤖 모델 초기화...")
    tokenizer = AutoTokenizer.from_pretrained(config.MODEL_NAME)
    model     = AutoModelForSequenceClassification.from_pretrained(
        config.MODEL_NAME, num_labels=config.NUM_LABELS
    )
    model.to(config.DEVICE)

    # 데이터로더
    train_loader = DataLoader(
        EmotionDataset(train_df['cleaned_text'].values, train_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, shuffle=True, num_workers=2, pin_memory=True
    )
    val_loader = DataLoader(
        EmotionDataset(val_df['cleaned_text'].values, val_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, num_workers=2, pin_memory=True
    )

    # ========== 레이어별 차등 학습률 (Layer-wise LR Decay) ==========
    # 하위 레이어: 사전학습 지식 보존 (lr 낮게)
    # 상위 레이어: 감정 분류 집중   (lr 높게)
    # Classifier: 가장 많이 학습   (lr 제일 높게)
    decay_factor = 0.9   # 레이어 내려갈수록 lr을 0.9배씩 감소
    num_layers   = model.config.num_hidden_layers  # roberta-large = 24

    optimizer_params = []

    # Classifier Head (가장 높은 lr)
    optimizer_params.append({
        'params':       model.classifier.parameters(),
        'lr':           config.LEARNING_RATE * 10,
        'weight_decay': 0.01
    })

    # Transformer 레이어 (상위일수록 lr 높게)
    for layer_idx in range(num_layers - 1, -1, -1):
        layer_lr = config.LEARNING_RATE * (decay_factor ** (num_layers - 1 - layer_idx))
        optimizer_params.append({
            'params':       model.roberta.encoder.layer[layer_idx].parameters(),
            'lr':           layer_lr,
            'weight_decay': 0.01
        })

    # Embedding Layer (가장 낮은 lr - 거의 안 건드림)
    optimizer_params.append({
        'params':       model.roberta.embeddings.parameters(),
        'lr':           config.LEARNING_RATE * (decay_factor ** num_layers),
        'weight_decay': 0.01
    })

    optimizer = AdamW(optimizer_params)

    print(f"\n⚙️  레이어별 차등 lr 적용:")
    print(f"   Embedding :  {config.LEARNING_RATE * (decay_factor ** num_layers):.2e}")
    print(f"   Layer 1   :  {config.LEARNING_RATE * (decay_factor ** (num_layers-1)):.2e}")
    print(f"   Layer 24  :  {config.LEARNING_RATE:.2e}")
    print(f"   Classifier:  {config.LEARNING_RATE * 10:.2e}")
    total_steps  = (len(train_loader) // config.GRAD_ACCUM_STEPS) * config.EPOCHS
    warmup_steps = int(total_steps * config.WARMUP_RATIO)
    # Cosine 스케줄러: linear보다 학습 후반 안정적
    scheduler    = get_cosine_schedule_with_warmup(optimizer, warmup_steps, total_steps)

    # 학습 루프
    print("\n🎯 학습 시작")
    best_val_acc = 0
    history = {'train_loss': [], 'train_acc': [], 'val_loss': [], 'val_acc': []}
    no_improve = 0  # Early Stopping 카운터 (patience=5)

    for epoch in range(config.EPOCHS):
        print(f"\n── Epoch {epoch+1}/{config.EPOCHS} " + "─" * 40)
        train_loss, train_acc = train_epoch(model, train_loader, optimizer, scheduler, config.DEVICE, loss_fn)
        val_loss, val_acc, _, _ = evaluate(model, val_loader, config.DEVICE)

        history['train_loss'].append(train_loss)
        history['train_acc'].append(train_acc)
        history['val_loss'].append(val_loss)
        history['val_acc'].append(val_acc)

        print(f"Train  →  loss: {train_loss:.4f}  acc: {train_acc*100:.2f}%")
        print(f"Val    →  loss: {val_loss:.4f}  acc: {val_acc*100:.2f}%")

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            no_improve   = 0
            print(f"💾 베스트 모델 저장 (val_acc: {val_acc*100:.2f}%)")
            os.makedirs(config.OUTPUT_DIR, exist_ok=True)
            model.save_pretrained(config.OUTPUT_DIR)
            tokenizer.save_pretrained(config.OUTPUT_DIR)
            with open(f'{config.OUTPUT_DIR}/training_history.json', 'w') as f:
                json.dump(history, f, indent=2)
        else:
            no_improve += 1
            print(f"⚠️  개선 없음 ({no_improve}/3)")
            if no_improve >= 5:
                print("🛑 Early Stopping!")
                break

    # 테스트 평가
    print("\n" + "=" * 60)
    print("🧪 테스트 세트 최종 평가")
    print("=" * 60)
    best_model = AutoModelForSequenceClassification.from_pretrained(os.path.abspath(config.OUTPUT_DIR))
    best_model.to(config.DEVICE)

    test_loader = DataLoader(
        EmotionDataset(test_df['cleaned_text'].values, test_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, num_workers=2
    )
    test_loss, test_acc, test_preds, test_labels = evaluate(best_model, test_loader, config.DEVICE)

    print(f"\nTest Loss:     {test_loss:.4f}")
    print(f"Test Accuracy: {test_acc*100:.2f}%")
    print("\n📋 분류 리포트:")
    print(classification_report(test_labels, test_preds, target_names=label_info['labels']))
    cm_path = os.path.join(os.path.abspath(config.OUTPUT_DIR), 'confusion_matrix.npy')
    np.save(cm_path, confusion_matrix(test_labels, test_preds))

    print("\n" + "=" * 60)
    print(f"✅ Phase 1 완료!  Best Val Acc: {best_val_acc*100:.2f}%")
    print(f"✅ 모델 저장: {config.OUTPUT_DIR}")
    print("=" * 60)

if __name__ == "__main__":
    import sys
    # 모든 출력을 파일에도 동시에 저장
    class Logger:
        def __init__(self, filename):
            self.terminal = sys.stdout
            self.log      = open(filename, 'w', encoding='utf-8')
        def write(self, message):
            self.terminal.write(message)
            self.log.write(message)
            self.log.flush()
        def flush(self):
            self.terminal.flush()
            self.log.flush()
        def isatty(self):       
            return False    

    os.makedirs(config.OUTPUT_DIR, exist_ok=True)
    sys.stdout = Logger(os.path.join(os.path.abspath(config.OUTPUT_DIR), 'train_log.txt'))
    main()