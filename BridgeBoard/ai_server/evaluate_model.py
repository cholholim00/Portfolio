import torch
from torch.utils.data import Dataset, DataLoader
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from sklearn.metrics import classification_report, confusion_matrix
import pandas as pd
import numpy as np
from tqdm import tqdm
import json
import os

# ========== 경로 설정 ==========
MODEL_DIR  = os.path.abspath("./model_stage1")   # 저장된 모델 경로
DATA_DIR   = "./data/processed"
BATCH_SIZE = 16
MAX_LENGTH = 128
DEVICE     = torch.device("cuda" if torch.cuda.is_available() else "cpu")

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
    print("🧪 테스트 세트 평가")
    print("=" * 60)
    print(f"📍 모델 경로: {MODEL_DIR}")
    print(f"📍 디바이스:  {DEVICE}")

    # 데이터 로드
    test_df = pd.read_csv(f'{DATA_DIR}/test.csv')
    with open(f'{DATA_DIR}/label_info.json', encoding='utf-8') as f:
        label_info = json.load(f)
    print(f"✅ Test {len(test_df)}개 로드 완료")

    # 모델 로드
    print("\n🤖 모델 로딩...")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_DIR)
    model     = AutoModelForSequenceClassification.from_pretrained(MODEL_DIR)
    model.to(DEVICE)

    # 데이터로더
    test_loader = DataLoader(
        EmotionDataset(test_df['cleaned_text'].values, test_df['label_id'].values, tokenizer, MAX_LENGTH),
        batch_size=BATCH_SIZE, num_workers=2
    )

    # 평가
    test_loss, test_acc, test_preds, test_labels = evaluate(model, test_loader, DEVICE)

    print(f"\nTest Loss:     {test_loss:.4f}")
    print(f"Test Accuracy: {test_acc*100:.2f}%")
    print("\n📋 분류 리포트:")
    print(classification_report(test_labels, test_preds, target_names=label_info['labels']))

    np.save(f'{MODEL_DIR}/confusion_matrix.npy', confusion_matrix(test_labels, test_preds))
    print(f"\n✅ 완료!")

if __name__ == "__main__":
    main()