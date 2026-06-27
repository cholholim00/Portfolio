import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from collections import Counter
import warnings

# 1. 웹페이지 기본 설정
st.set_page_config(page_title="로또 AI 분석기", page_icon="🎰", layout="centered")

# 맥(Mac) 한글 폰트 깨짐 방지
plt.rc('font', family='AppleGothic')
plt.rcParams['axes.unicode_minus'] = False

st.title("로또 번호 분석 및 가중치 추첨기 🎰")

# 2. 고정할 엑셀 파일 경로 지정 (본인의 파일명에 맞게 수정해주세요)
file_path = "dataset/로또 회차별 당첨번호_통계.xlsx"

# 3. 데이터 로드 함수 (캐싱 적용)
# @st.cache_data를 붙이면 엑셀 파일을 딱 한 번만 읽어서 메모리에 저장하므로 앱이 매우 빨라집니다.
@st.cache_data
def load_and_preprocess_data(path):
    warnings.filterwarnings('ignore', category=UserWarning, module='openpyxl')
    
    # 엑셀 파일 읽기
    df = pd.read_excel(path)
    
    # 전처리 (위치 기반으로 열 자르기 및 컬럼명 변경)
    df = df.iloc[:, [1, 2, 3, 4, 5, 6, 7, 8]]
    df.columns = ['round', 'num1', 'num2', 'num3', 'num4', 'num5', 'num6', 'bonus']
    df = df.sort_values(by='round').reset_index(drop=True)
    
    return df

# 4. 메인 로직 실행
try:
    # 캐싱된 함수로 데이터 불러오기
    df = load_and_preprocess_data(file_path)
    
    with st.expander("전처리된 데이터 미리보기 (클릭하여 펼치기)"):
        st.dataframe(df.tail())

    # 데이터 분석
    all_numbers = df[['num1', 'num2', 'num3', 'num4', 'num5', 'num6']].values.flatten()
    number_counts = Counter(all_numbers)
    sorted_counts = number_counts.most_common()

    st.divider() 
    st.subheader("📊 역대 번호별 출현 빈도수")
    
    # 그래프 그리기
    fig, ax = plt.subplots(figsize=(10, 4))
    x_numbers = [str(x[0]) for x in sorted_counts]
    y_counts = [x[1] for x in sorted_counts]
    
    ax.bar(x_numbers, y_counts, color='#4DA6FF')
    ax.set_xlabel('로또 번호', fontsize=10)
    ax.set_ylabel('출현 횟수', fontsize=10)
    plt.xticks(rotation=45, fontsize=8)
    
    st.pyplot(fig)

    # 5. AI 추첨기 파트
    st.divider()
    st.subheader("🤖 AI 확률 기반 이번 주 번호 추천")
    st.write("과거에 많이 나온 번호일수록 뽑힐 확률이 미세하게 높아지도록 설계되었습니다.")

    # 추첨 버튼
    if st.button("🚀 번호 5게임 추첨하기!", type="primary"):
        total_draws = sum(number_counts.values())
        lotto_numbers = np.arange(1, 46)
        probabilities = [number_counts.get(i, 0) / total_draws for i in range(1, 46)]

        st.write("### 🎁 이번 주 추천 번호 결과")
        
        for game in range(1, 6):
            predicted_numbers = np.random.choice(lotto_numbers, size=6, replace=False, p=probabilities)
            predicted_numbers.sort()
            
            nums_str = " ".join([f"` {n:02d} `" for n in predicted_numbers])
            st.info(f"**{game}게임** : {nums_str}")
            
except FileNotFoundError:
    st.error(f"오류: '{file_path}' 파일을 찾을 수 없습니다. 파이썬 파일이 있는 곳에 엑셀 파일이 있는지 확인해주세요.")
except Exception as e:
    st.error(f"데이터 처리 중 오류가 발생했습니다: {e}")