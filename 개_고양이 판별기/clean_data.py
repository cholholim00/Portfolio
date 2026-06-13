import os

# 데이터가 있는 최상위 폴더 경로
dataset_path = './dataset'

print("🧹 맥북 찌꺼기 파일 청소를 시작합니다...")
deleted_count = 0

# 폴더를 샅샅이 뒤지기
for root, dirs, files in os.walk(dataset_path):
    for file in files:
        # 파일 이름이 '._' 로 시작하는 가짜 파일 찾기
        if file.startswith('._'):
            file_path = os.path.join(root, file)
            os.remove(file_path) # 가차 없이 삭제!
            deleted_count += 1

print(f"✨ 청소 완료! 총 {deleted_count}개의 불량 파일을 삭제했습니다.")