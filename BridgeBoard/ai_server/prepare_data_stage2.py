# 2단계 소분류 모델용 데이터 준비 스크립트
# - 사람문장 분리로 데이터 3배 증가
# - 비슷한 소분류 통합 (9개→5~6개)

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
import json
import os
import re

# ========== 통합된 소분류 정의 ==========
# 비슷한 감정끼리 묶어서 클래스 수 줄임
LABELS_SUB = {
    "불안": {
        "걱정/초조":  ["걱정스러운", "초조한", "안달하는", "조심스러운"],
        "두려움":     ["두려운", "마비된"],
        "고립감":     ["고립된", "취약한"],
        "혼란":       ["혼란스러운"],
        "불안":       ["불안"],
    },
    "분노": {
        "짜증/스트레스": ["짜증내는", "스트레스 받는", "성가신", "툴툴대는"],
        "분노/격분":     ["노여워하는", "분노", "악의적인"],
        "방어/혐오":     ["방어적인", "혐오스러운", "구역질 나는"],
    },
    "상처": {
        "억울/배신":  ["억울한", "배신당한", "희생된"],
        "상처/충격":  ["상처", "충격 받은"],
        "고립/외로움": ["버려진", "외로운", "한심한"],
    },
    "슬픔": {
        "우울/절망":  ["우울한", "낙담한", "좌절한", "염세적인"],
        "슬픔/눈물":  ["눈물이 나는", "비통한", "슬픔"],
        "후회/실망":  ["후회되는", "실망한"],
        "고통":       ["괴로워하는", "가난한, 불우한"],
    },
    "당황": {
        "부끄러움":   ["부끄러운", "당황", "당혹스러운"],
        "죄책감/환멸": ["죄책감의", "환멸을 느끼는", "회의적인"],
        "열등/질투":  ["열등감", "질투하는", "남의 시선을 의식하는"],
    },
    "기쁨": {
        "감사/신뢰":  ["감사하는", "신뢰하는"],
        "만족/편안":  ["만족스러운", "편안한", "안도", "느긋"],
        "신남/흥분":  ["신이 난", "흥분", "기쁨"],
        "자신감":     ["자신하는"],
    },
}

def clean_text(text):
    if not isinstance(text, str):
        return ""
    text = ' '.join(text.split())
    text = re.sub(r'[^가-힣a-zA-Z0-9\s\.\?\!,]', '', text)
    return text.strip()

def main():
    print("=" * 60)
    print("🔄 2단계 소분류 데이터 준비 (통합 버전)")
    print("=" * 60)

    print("\n📂 원본 데이터 로딩...")
    df = pd.read_excel('dataset/감성대화/Training_221115_add/원천데이터/감성대화말뭉치(최종데이터)_Training.xlsx')
    print(f"✅ {len(df)}개 샘플 로드 완료")

    for main_label, sub_map in LABELS_SUB.items():
        print(f"\n── {main_label} 처리 중 " + "─" * 30)

        # 해당 대분류만 필터링
        sub_df = df[df['감정_대분류'] == main_label].copy()

        # 통합 레이블 목록 및 매핑
        merged_labels = list(sub_map.keys())
        label_to_id = {label: idx for idx, label in enumerate(merged_labels)}

        # 소분류 → 통합 레이블 역매핑
        sub_to_merged = {}
        for merged, originals in sub_map.items():
            for orig in originals:
                sub_to_merged[orig] = merged

        rows = []
        for _, row in sub_df.iterrows():
            sub_label = row['감정_소분류']
            merged_label = sub_to_merged.get(sub_label)
            if merged_label is None:
                continue

            # 사람문장 분리 (3배 데이터)
            for col in ['사람문장1', '사람문장2', '사람문장3']:
                t = clean_text(row.get(col, ''))
                if len(t) > 1:
                    rows.append({
                        'cleaned_text': t,
                        'label':        merged_label,
                        'label_id':     label_to_id[merged_label]
                    })

        result_df = pd.DataFrame(rows)
        print(f"✅ {len(result_df)}개 샘플  (클래스 수: {len(merged_labels)}개)")
        print(result_df['label'].value_counts().to_string())

        # Train/Val/Test 분할
        train_val, test = train_test_split(result_df, test_size=0.1, stratify=result_df['label_id'], random_state=42)
        train, val      = train_test_split(train_val,  test_size=0.1, stratify=train_val['label_id'],  random_state=42)

        # 저장
        output_dir = f'./data/stage2/{main_label}'
        os.makedirs(output_dir, exist_ok=True)
        train.to_csv(f'{output_dir}/train.csv', index=False, encoding='utf-8-sig')
        val.to_csv(f'{output_dir}/val.csv',     index=False, encoding='utf-8-sig')
        test.to_csv(f'{output_dir}/test.csv',   index=False, encoding='utf-8-sig')

        label_info = {
            'main_label':  main_label,
            'labels':      merged_labels,
            'label_to_id': label_to_id,
            'id_to_label': {str(v): k for k, v in label_to_id.items()}
        }
        with open(f'{output_dir}/label_info.json', 'w', encoding='utf-8') as f:
            json.dump(label_info, f, ensure_ascii=False, indent=2)

        print(f"💾 저장: train {len(train)} / val {len(val)} / test {len(test)}")

    print("\n" + "=" * 60)
    print("✅ 전체 소분류 데이터 준비 완료!")
    print("이제 train_model_stage2.py 를 실행하세요!")
    print("=" * 60)

if __name__ == "__main__":
    main()