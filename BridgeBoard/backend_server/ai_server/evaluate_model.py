import torch
import pandas as pd
import numpy as np
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from torch.utils.data import Dataset, DataLoader
from sklearn.metrics import accuracy_score, f1_score
from tqdm import tqdm
from torch.cuda.amp import autocast

# --- 설정 값 (학습할 때와 동일하게 맞춰주세요) ---
MODEL_NAME = 'klue/roberta-large'
MAX_LEN = 128
BATCH_SIZE = 16  # 평가는 학습보다 메모리를 적게 먹어서 늘려도 됩니다.
NUM_LABELS = 6
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# --- 데이터셋 클래스 ---
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

def evaluate():
    print(f"🚀 장치 확인: {DEVICE}")
    print("불러오는 중... 잠시만 기다려주세요.")

    # 토크나이저 및 검증 데이터 로드
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    val_data = EmotionDataset('data/processed/val.csv', tokenizer, MAX_LEN)
    val_loader = DataLoader(val_data, batch_size=BATCH_SIZE, num_workers=0)

    # 빈 모델 껍데기 생성
    model = AutoModelForSequenceClassification.from_pretrained(MODEL_NAME, num_labels=NUM_LABELS)
    
    # 🌟 밤새 학습한 가중치(뇌) 덮어씌우기
    model_path = 'model_stage1/best_model.bin'
    model.load_state_dict(torch.load(model_path, map_location=DEVICE))
    model.to(DEVICE)
    model.eval()

    print("\n✅ 모델 로딩 완료! 평가를 시작합니다...")
    val_preds, val_labels = [], []
    
    with torch.no_grad():
        for batch in tqdm(val_loader, desc="Evaluating"):
            input_ids = batch['input_ids'].to(DEVICE)
            attention_mask = batch['attention_mask'].to(DEVICE)
            labels = batch['labels'].to(DEVICE)

            # Mixed Precision 적용하여 평가 속도 상승
            with autocast():
                outputs = model(input_ids, attention_mask=attention_mask)
                
            preds = torch.argmax(outputs.logits, dim=1).flatten().cpu().numpy()
            val_preds.extend(preds)
            val_labels.extend(labels.cpu().numpy())

    # 정확도 계산
    acc = accuracy_score(val_labels, val_preds)
    f1 = f1_score(val_labels, val_preds, average='macro')
    
    print("\n" + "="*50)
    print(f"🎉 최종 복구된 평가 결과 🎉")
    print(f"정확도 (Accuracy) : {acc * 100:.2f}%")
    print(f"F1-Score (Macro)  : {f1:.4f}")
    print("="*50)

if __name__ == "__main__":
    evaluate()