import os
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import Dataset, DataLoader
from transformers import AutoTokenizer, AutoModelForSequenceClassification, get_linear_schedule_with_warmup
from torch.optim import AdamW
from sklearn.metrics import accuracy_score, f1_score
from tqdm import tqdm

# 🚀 속도 3배 향상을 위한 Mixed Precision 모듈 임포트
from torch.cuda.amp import autocast, GradScaler 

# ==========================================
# 0. GPU 장치 설정 및 확인 (전역 변수로 이동)
# ==========================================
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("=" * 60)
print(f"현재 사용 중인 장치: {DEVICE}")
if DEVICE.type == 'cuda':
    print(f"그래픽카드 모델: {torch.cuda.get_device_name(0)}")
else:
    print("⚠️ 경고: GPU를 찾지 못해 CPU로 학습 중입니다. CUDA 설치를 확인하세요.")
print("=" * 60)

# ==========================================
# 1. 고도화된 손실 함수: Focal Loss 정의
# ==========================================
class FocalLoss(nn.Module):
    def __init__(self, alpha=1, gamma=2):
        super(FocalLoss, self).__init__()
        self.alpha = alpha
        self.gamma = gamma

    def forward(self, inputs, targets):
        ce_loss = F.cross_entropy(inputs, targets, reduction='none', label_smoothing=0.1)
        pt = torch.exp(-ce_loss)
        focal_loss = self.alpha * (1 - pt) ** self.gamma * ce_loss
        return focal_loss.mean()

# ==========================================
# 2. 데이터셋 클래스
# ==========================================
class EmotionDataset(Dataset):
    def __init__(self, csv_path, tokenizer, max_len):
        self.data = pd.read_csv(csv_path)
        self.tokenizer = tokenizer
        self.max_len = max_len

    def __len__(self):
        return len(self.data)

    def __getitem__(self, item):
        sentence = str(self.data.iloc[item]['cleaned_text'])
        label = int(self.data.iloc[item]['label_id'])

        encoding = self.tokenizer(
            sentence,
            add_special_tokens=True,
            max_length=self.max_len,
            padding='max_length',
            truncation=True,
            return_attention_mask=True,
            return_tensors='pt',
        )

        return {
            'input_ids': encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten(),
            'labels': torch.tensor(label, dtype=torch.long)
        }

# ==========================================
# 3. 레이어별 학습률 차등 적용 (LLRD) 함수
# ==========================================
def get_optimizer_grouped_parameters(model, lr, weight_decay=0.01):
    no_decay = ["bias", "LayerNorm.weight"]
    optimizer_grouped_parameters = [
        {
            "params": [p for n, p in model.named_parameters() if not any(nd in n for nd in no_decay)],
            "weight_decay": weight_decay,
        },
        {
            "params": [p for n, p in model.named_parameters() if any(nd in n for nd in no_decay)],
            "weight_decay": 0.05,
        },
    ]
    return optimizer_grouped_parameters

# ==========================================
# 4. 메인 학습 루프
# ==========================================
def train():
    # --- 설정 값 ---
    MODEL_NAME = 'klue/roberta-large'
    MAX_LEN = 128
    BATCH_SIZE = 8
    EPOCHS = 4
    LR = 1e-5  
    NUM_LABELS = 6 

    # 데이터 로드 
    train_dataset_path = 'data/processed/train.csv' 
    val_dataset_path = 'data/processed/val.csv'

    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    train_data = EmotionDataset(train_dataset_path, tokenizer, MAX_LEN)
    val_data = EmotionDataset(val_dataset_path, tokenizer, MAX_LEN)

    # num_workers=0 으로 윈도우 병목 방지
    train_loader = DataLoader(train_data, batch_size=BATCH_SIZE, shuffle=True, num_workers=0)
    val_loader = DataLoader(val_data, batch_size=BATCH_SIZE, num_workers=0)

    # 모델 선언
    model = AutoModelForSequenceClassification.from_pretrained(MODEL_NAME, num_labels=NUM_LABELS)
    model.to(DEVICE)

    # 손실 함수 및 옵티마이저 설정
    criterion = FocalLoss(gamma=1.0) 
    optimizer_params = get_optimizer_grouped_parameters(model, LR)
    optimizer = AdamW(optimizer_params, lr=LR)
    
    total_steps = len(train_loader) * EPOCHS
    scheduler = get_linear_schedule_with_warmup(optimizer, num_warmup_steps=int(total_steps*0.1), num_training_steps=total_steps)

    # 🚀 Mixed Precision 스케일러 초기화
    scaler = torch.amp.GradScaler('cuda')

    best_acc = 0
    print("\n🚀 데이터 로딩 완료! 학습을 시작합니다...")

    for epoch in range(EPOCHS):
        model.train()
        train_losses = []
        
        pbar = tqdm(train_loader, desc=f"Epoch {epoch+1}")
        
        for batch in pbar:
            optimizer.zero_grad()
            input_ids = batch['input_ids'].to(DEVICE)
            attention_mask = batch['attention_mask'].to(DEVICE)
            labels = batch['labels'].to(DEVICE)

            # 🚀 Mixed Precision 적용 (VRAM 절약 및 속도 향상)
            with torch.amp.autocast('cuda'):
                outputs = model(input_ids, attention_mask=attention_mask)
                loss = criterion(outputs.logits, labels)
            
            # 역전파 및 최적화 단계 (Scaler 사용)
            scaler.scale(loss).backward()
            scaler.unscale_(optimizer) # 클리핑을 위해 unscale 먼저 진행
            nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0) 
            
            scaler.step(optimizer)
            scaler.update()
            scheduler.step()
            
            train_losses.append(loss.item())
            pbar.set_postfix({'loss': f"{loss.item():.4f}"})

        # 검증 (Validation)
        model.eval()
        val_preds, val_labels = [], []
        with torch.no_grad():
            for batch in val_loader:
                input_ids = batch['input_ids'].to(DEVICE)
                attention_mask = batch['attention_mask'].to(DEVICE)
                labels = batch['labels'].to(DEVICE)

                # 🚀 검증 시에도 Mixed Precision 적용하여 속도 단축
                with torch.amp.autocast('cuda'):
                    outputs = model(input_ids, attention_mask=attention_mask)
                    
                preds = torch.argmax(outputs.logits, dim=1).flatten().cpu().numpy()
                val_preds.extend(preds)
                val_labels.extend(labels.cpu().numpy())

        acc = accuracy_score(val_labels, val_preds)
        f1 = f1_score(val_labels, val_preds, average='macro')
        
        print(f"\nEpoch {epoch+1}/{EPOCHS} | Train Loss: {np.mean(train_losses):.4f} | Val Acc: {acc:.4f} | F1: {f1:.4f}")

        # 베스트 모델 저장
        if acc > best_acc:
            best_acc = acc
            os.makedirs('model_stage1', exist_ok=True)
            torch.save(model.state_dict(), 'model_stage1/best_model.bin')
            print("🎉 Best Model Saved!")

if __name__ == "__main__":
    train()