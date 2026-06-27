import pandas as pd
import matplotlib.pyplot as plt
from collections import Counter
import numpy as np

# 올려주신 파일이 csv 형태이므로 read_csv를 사용합니다. 
# (만약 xlsx 파일이라면 pd.read_excel('파일명.xlsx')로 변경해 주세요)
file_path = 'dataset/로또 회차별 당첨번호_통계.xlsx'

# 데이터 불러오기
df = pd.read_excel(file_path)

# 1. iloc를 사용하여 필요한 열만 딱 잘라냅니다.
# [회차, 1번, 2번, 3번, 4번, 5번, 6번, 보너스] -> 1번째 열부터 8번째 열까지
df = df.iloc[:, [1, 2, 3, 4, 5, 6, 7, 8]]

# 2. 직관적인 영문 컬럼명으로 변경 (모델링 시 에러 방지)
df.columns = ['round', 'num1', 'num2', 'num3', 'num4', 'num5', 'num6', 'bonus']

# 3. 시간의 흐름(시계열)에 맞게 1회차부터 오름차순으로 정렬
df = df.sort_values(by='round').reset_index(drop=True)

# 4. 결측치나 이상치가 없는지 기본 전처리 점검
print("🚨 결측치 확인:\n", df.isnull().sum())

# 5. 결과 확인
print("\n✨ 전처리 완료된 데이터 (최근 5회차):")
print(df.tail())

# ==========================================
# (이 위에는 방금 성공하신 전처리 코드가 있습니다)
# ==========================================

# 1. 1번부터 6번까지의 모든 당첨 번호를 하나의 리스트로 길게 합칩니다. (보너스 번호 제외)
# 1차원 데이터로 쫙 펴주는 작업입니다.
all_numbers = df[['num1', 'num2', 'num3', 'num4', 'num5', 'num6']].values.flatten()

# 2. 각 숫자가 몇 번씩 나왔는지 개수를 셉니다.
number_counts = Counter(all_numbers)

# 3. 가장 많이 나온 번호 순서대로 정렬합니다.
sorted_counts = number_counts.most_common()

print("\n🏆 역대 가장 많이 나온 번호 TOP 10:")
for num, count in sorted_counts[:10]:
    print(f"숫자 {num:2d} : {count}회 출현")

print("\n📉 역대 가장 적게 나온 번호 WORST 5:")
for num, count in sorted_counts[-5:]:
    print(f"숫자 {num:2d} : {count}회 출현")

# 4. 맥(Mac) 환경 그래프 한글 깨짐 방지 설정
plt.rc('font', family='AppleGothic')
plt.rcParams['axes.unicode_minus'] = False

# 5. 막대그래프(Bar chart)로 시각화하기
# 전체 45개 번호의 출현 빈도를 그래프로 그립니다.
x_numbers = [str(x[0]) for x in sorted_counts]  # 번호 (X축)
y_counts = [x[1] for x in sorted_counts]        # 출현 횟수 (Y축)

plt.figure(figsize=(15, 6))
plt.bar(x_numbers, y_counts, color='skyblue')
plt.title('역대 로또 번호 출현 빈도수 (1회 ~ 최근)', fontsize=16)
plt.xlabel('로또 번호', fontsize=12)
plt.ylabel('출현 횟수', fontsize=12)
plt.xticks(rotation=45) # X축 번호들이 겹치지 않게 45도 기울임
plt.tight_layout() # 그래프 여백 자동 조절

# 그래프를 화면에 띄웁니다.
plt.show()

# ==========================================
# (이 위에는 방금 실행하신 그래프 시각화 코드가 있습니다)
# ==========================================

print("\n" + "="*50)
print("🤖 AI 데이터 기반 이번 주 로또 번호 추천 🤖")
print("="*50)

# 1. 1부터 45까지의 번호와 각각의 '등장 확률(가중치)' 계산하기
total_draws = sum(number_counts.values()) # 전체 공이 뽑힌 총 횟수
lotto_numbers = np.arange(1, 46)          # 1 ~ 45번 리스트
probabilities = []                        # 각 번호가 뽑힐 확률을 담을 리스트

for i in range(1, 46):
    # (특정 번호가 나온 횟수 / 전체 횟수)를 계산하여 확률로 만듭니다.
    # 만약 한 번도 안 나온 번호가 있다면 0으로 처리 (get 함수의 기본값 0)
    prob = number_counts.get(i, 0) / total_draws
    probabilities.append(prob)

# 2. 추천 번호 5게임 생성하기
for game in range(1, 6):
    # np.random.choice를 사용해 1~45번 중에서 6개를 뽑습니다.
    # replace=False: 중복 번호 추출 금지
    # p=probabilities: 우리가 구한 과거 출현 빈도수 기반의 가중치 적용!
    predicted_numbers = np.random.choice(lotto_numbers, size=6, replace=False, p=probabilities)
    
    # 번호를 보기 좋게 오름차순으로 정렬
    predicted_numbers.sort()
    
    # 결과 출력
    print(f"[{game}게임] 추천 번호: {predicted_numbers}")

print("="*50)
print("💡 참고: 과거 데이터를 기반으로 가중치를 주었지만, 실제 당첨을 보장하지는 않습니다!")