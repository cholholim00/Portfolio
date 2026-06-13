# 2단계 소분류 모델 학습 스크립트
# 대분류별로 6개 모델을 순차적으로 학습
# model_stage2/ 저장

import torch
import torch.nn.functional as F
from torch.utils.data import Dataset, DataLoader
from torch.optim import AdamW
from transformers import (
    AutoTokenizer,
    AutoModelForSequenceClassification,
    get_linear_schedule_with_warmup
)
from sklearn.metrics import classification_report
import pandas as pd
import numpy as np
from tqdm import tqdm
import json
import os

# ========== 설정 ==========
class Config:
    MODEL_NAME    = "klue/roberta-large"
    MAX_LENGTH    = 128
    BATCH_SIZE    = 16
    EPOCHS        = 7
    LEARNING_RATE = 5e-6
    WARMUP_RATIO  = 0.1
    DATA_DIR      = "./data/stage2"
    OUTPUT_DIR    = "./model_stage2"
    DEVICE        = torch.device("cuda" if torch.cuda.is_available() else "cpu")

config = Config()

MAIN_LABELS = ["불안", "분노", "상처", "슬픔", "당황", "기쁨"]

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

# ========== Focal Loss ==========
class FocalLoss(torch.nn.Module):
    def __init__(self, gamma=2.0, weight=None):
        super().__init__()
        self.gamma  = gamma
        self.weight = weight

    def forward(self, logits, labels):
        ce_loss = F.cross_entropy(logits, labels, weight=self.weight, reduction='none')
        pt      = torch.exp(-ce_loss)
        return (((1 - pt) ** self.gamma) * ce_loss).mean()

# ========== 클래스 가중치 ==========
def compute_class_weights(labels, num_classes):
    counts  = np.bincount(labels, minlength=num_classes)
    weights = 1.0 / np.where(counts == 0, 1, counts)
    weights = weights / weights.sum() * num_classes
    return torch.tensor(weights, dtype=torch.float)

# ========== 학습 ==========
def train_epoch(model, dataloader, optimizer, scheduler, device, loss_fn):
    model.train()
    total_loss, correct, total = 0, 0, 0

    for batch in tqdm(dataloader, desc='  Training', leave=False):
        optimizer.zero_grad()
        input_ids      = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        labels         = batch['labels'].to(device)

        outputs = model(input_ids=input_ids, attention_mask=attention_mask)
        loss    = loss_fn(outputs.logits, labels)

        loss.backward()
        torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
        optimizer.step()
        scheduler.step()

        total_loss += loss.item()
        correct    += (torch.argmax(outputs.logits, dim=1) == labels).sum().item()
        total      += labels.size(0)

    return total_loss / len(dataloader), correct / total

# ========== 평가 ==========
def evaluate(model, dataloader, device):
    model.eval()
    total_loss, all_preds, all_labels = 0, [], []
    loss_fn = torch.nn.CrossEntropyLoss()

    with torch.no_grad():
        for batch in tqdm(dataloader, desc='  Evaluating', leave=False):
            input_ids      = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)
            labels         = batch['labels'].to(device)

            outputs     = model(input_ids=input_ids, attention_mask=attention_mask)
            total_loss += loss_fn(outputs.logits, labels).item()

            all_preds.extend(torch.argmax(outputs.logits, dim=1).cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    return total_loss / len(dataloader), np.mean(np.array(all_preds) == np.array(all_labels)), all_preds, all_labels

# ========== 단일 모델 학습 ==========
def train_one_model(main_label):
    print(f"\n{'=' * 60}")
    print(f"🎯 [{main_label}] 소분류 모델 학습")
    print(f"{'=' * 60}")

    data_dir   = f'{config.DATA_DIR}/{main_label}'
    output_dir = f'{config.OUTPUT_DIR}/{main_label}'

    # 데이터 로드
    train_df = pd.read_csv(f'{data_dir}/train.csv')
    val_df   = pd.read_csv(f'{data_dir}/val.csv')
    test_df  = pd.read_csv(f'{data_dir}/test.csv')
    with open(f'{data_dir}/label_info.json', encoding='utf-8') as f:
        label_info = json.load(f)

    num_labels = len(label_info['labels'])
    print(f"📊 소분류 개수: {num_labels}개")
    print(f"✅ Train {len(train_df)} / Val {len(val_df)} / Test {len(test_df)}")

    # 모델 초기화
    tokenizer = AutoTokenizer.from_pretrained(config.MODEL_NAME)
    model     = AutoModelForSequenceClassification.from_pretrained(
        config.MODEL_NAME, num_labels=num_labels
    )
    model.to(config.DEVICE)

    # 데이터로더
    train_loader = DataLoader(
        EmotionDataset(train_df['cleaned_text'].values, train_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, shuffle=True, num_workers=2
    )
    val_loader = DataLoader(
        EmotionDataset(val_df['cleaned_text'].values, val_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, num_workers=2
    )

    # Loss / 옵티마이저 / 스케줄러
    class_weights = compute_class_weights(train_df['label_id'].values, num_labels)
    loss_fn       = FocalLoss(gamma=2.0, weight=class_weights.to(config.DEVICE))
    optimizer     = AdamW(model.parameters(), lr=config.LEARNING_RATE, weight_decay=0.01)
    total_steps   = len(train_loader) * config.EPOCHS
    scheduler     = get_linear_schedule_with_warmup(optimizer, int(total_steps * config.WARMUP_RATIO), total_steps)

    # 학습 루프
    best_val_acc = 0
    for epoch in range(config.EPOCHS):
        print(f"\n  Epoch {epoch+1}/{config.EPOCHS}")
        train_loss, train_acc = train_epoch(model, train_loader, optimizer, scheduler, config.DEVICE, loss_fn)
        val_loss,   val_acc, _, _ = evaluate(model, val_loader, config.DEVICE)

        print(f"  Train → loss: {train_loss:.4f}  acc: {train_acc*100:.2f}%")
        print(f"  Val   → loss: {val_loss:.4f}  acc: {val_acc*100:.2f}%")

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            print(f"  💾 베스트 저장 (val_acc: {val_acc*100:.2f}%)")
            os.makedirs(output_dir, exist_ok=True)
            model.save_pretrained(output_dir)
            tokenizer.save_pretrained(output_dir)

    # 테스트 평가
    best_model = AutoModelForSequenceClassification.from_pretrained(os.path.abspath(output_dir))
    best_model.to(config.DEVICE)
    test_loader = DataLoader(
        EmotionDataset(test_df['cleaned_text'].values, test_df['label_id'].values, tokenizer, config.MAX_LENGTH),
        batch_size=config.BATCH_SIZE, num_workers=2
    )
    _, test_acc, test_preds, test_labels = evaluate(best_model, test_loader, config.DEVICE)

    print(f"\n  📊 [{main_label}] 최종 Test Accuracy: {test_acc*100:.2f}%")
    print(classification_report(test_labels, test_preds, labels=list(range(len(label_info['labels']))), target_names=label_info['labels'], zero_division=0))

    return test_acc

# ========== 메인 ==========
def main():
    print("=" * 60)
    print("🚀 2단계 소분류 모델 학습 시작")
    print("=" * 60)
    print(f"📍 디바이스: {config.DEVICE}")
    print(f"📍 모델:     {config.MODEL_NAME}")
    print(f"📍 에포크:   {config.EPOCHS}  배치: {config.BATCH_SIZE}")

    results = {}
    for main_label in MAIN_LABELS:
        acc = train_one_model(main_label)
        results[main_label] = acc

    # 전체 결과 요약
    print("\n" + "=" * 60)
    print("📊 전체 소분류 모델 성능 요약")
    print("=" * 60)
    for label, acc in results.items():
        print(f"  {label:6s}: {acc*100:.2f}%")
    print(f"\n  평균: {np.mean(list(results.values()))*100:.2f}%")
    print(f"\n✅ 모든 모델 저장 위치: {config.OUTPUT_DIR}/")

if __name__ == "__main__":
    main()