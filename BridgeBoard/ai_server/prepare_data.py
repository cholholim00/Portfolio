# 1단계 대분류 데이터 전처리

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
import json
import os
import re

# ========== 6개 감정 대분류 ==========
LABELS = ["불안", "분노", "상처", "슬픔", "당황", "기쁨"]

class EmotionDataPreprocessor:
    def __init__(self):
        self.label_to_id = {label: idx for idx, label in enumerate(LABELS)}
        self.id_to_label = {idx: label for idx, label in enumerate(LABELS)}

    def clean_text(self, text):
        if not isinstance(text, str):
            return ""
        text = ' '.join(text.split())
        text = re.sub(r'[^가-힣a-zA-Z0-9\s\.\?\!,]', '', text)
        return text.strip()

    def load_excel(self, file_path):
        print(f"📂 데이터 로딩: {file_path}")
        df = pd.read_excel(file_path)
        print(f"✅ {len(df)}개 샘플 로드 완료")
        return df

    def process_dataset(self, df):
        """사람문장1/2/3을 하나로 합쳐서 단일 샘플로 처리"""
        print("\n🔄 데이터 전처리 시작...")

        rows = []
        for _, row in df.iterrows():
            label = row['감정_대분류']
            if label not in self.label_to_id:
                continue

            # 사람문장1/2/3 합치기 (빈 문장 제외)
            parts = []
            for col in ['사람문장1', '사람문장2', '사람문장3']:
                t = self.clean_text(row.get(col, ''))
                if t:
                    parts.append(t)

            combined = ' / '.join(parts)  # 문장 구분자로 합침
            if len(combined) > 1:
                rows.append({
                    'cleaned_text': combined,
                    'label':        label,
                    'label_id':     self.label_to_id[label]
                })

        result_df = pd.DataFrame(rows)

        print(f"✅ 전처리 완료: {len(result_df)}개 샘플")
        print("\n📊 클래스 분포:")
        print(result_df['label'].value_counts())

        return result_df

    def split_dataset(self, df, train_ratio=0.8, val_ratio=0.1):
        train_val, test = train_test_split(
            df,
            test_size=round(1 - train_ratio - val_ratio, 2),
            stratify=df['label_id'],
            random_state=42
        )
        train, val = train_test_split(
            train_val,
            test_size=round(val_ratio / (train_ratio + val_ratio), 2),
            stratify=train_val['label_id'],
            random_state=42
        )
        print(f"\n✅ 데이터셋 분할 완료:")
        print(f"   - Train: {len(train)}개")
        print(f"   - Val:   {len(val)}개")
        print(f"   - Test:  {len(test)}개")
        return train, val, test

    def save_processed_data(self, train, val, test, output_dir='./data/processed'):
        os.makedirs(output_dir, exist_ok=True)
        train.to_csv(f'{output_dir}/train.csv', index=False, encoding='utf-8-sig')
        val.to_csv(f'{output_dir}/val.csv',     index=False, encoding='utf-8-sig')
        test.to_csv(f'{output_dir}/test.csv',   index=False, encoding='utf-8-sig')

        label_info = {
            'labels':       LABELS,
            'label_to_id':  self.label_to_id,
            'id_to_label':  {str(k): v for k, v in self.id_to_label.items()}
        }
        with open(f'{output_dir}/label_info.json', 'w', encoding='utf-8') as f:
            json.dump(label_info, f, ensure_ascii=False, indent=2)

        print(f"\n✅ 데이터 저장 완료: {output_dir}")
        print("\n📝 샘플 예시:")
        print(train['cleaned_text'].iloc[0])

# ========== 실행 ==========
if __name__ == "__main__":
    preprocessor = EmotionDataPreprocessor()
    df = preprocessor.load_excel('dataset/감성대화/Training_221115_add/원천데이터/감성대화말뭉치(최종데이터)_Training.xlsx')
    df_processed = preprocessor.process_dataset(df)
    train, val, test = preprocessor.split_dataset(df_processed)
    preprocessor.save_processed_data(train, val, test)