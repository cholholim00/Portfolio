import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader

# 우리가 아까 만든 AlexNet 뼈대를 불러옵니다!
from alexnet import CustomAlexNet

# ==========================================
# 1. 환경 설정 (장치 및 하이퍼파라미터)
# ==========================================
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"✅ [의료분석 스터디] 현재 사용 중인 장치: {device}")

BATCH_SIZE = 32
LEARNING_RATE = 0.001
EPOCHS = 35

# ==========================================
# 2. 데이터 전처리 (AI가 외우지 못하게 응용문제 만들기!)
# ==========================================
transform = transforms.Compose([
    transforms.RandomResizedCrop(224, scale=(0.8, 1.0)),  # 사진을 랜덤하게 자르고 크기 조절 (AI가 사진의 위치에 너무 의존하지 않도록!)
    # 이 세 줄의 마법이 AI를 똑똑하게 만듭니다!
    transforms.RandomHorizontalFlip(),  # 50% 확률로 좌우 반전
    transforms.RandomRotation(degrees=15),   # 최대 15도 랜덤 회전
    transforms.ColorJitter(brightness=0.2, contrast=0.2),  # 밝기 살짝 조절 (낮/밤 효과)
    # ==========================================
    transforms.ToTensor(),
])

# ==========================================
# 3. 데이터 로더
# ==========================================
train_dir = './dataset/training_set'

if not os.path.exists(train_dir):
    print("❌ 앗! 'dataset/training_set' 폴더가 없습니다. 폴더 구조를 다시 확인해 주세요!")
    exit()

train_dataset = datasets.ImageFolder(root=train_dir, transform=transform)
train_loader = DataLoader(dataset=train_dataset, batch_size=BATCH_SIZE, shuffle=True, num_workers=0)

print(f"✅ 총 {len(train_dataset)}장의 사진을 찾았습니다!")
print(f"✅ 정답 클래스: {train_dataset.classes} (0번, 1번)")

# ==========================================
# 4. 모델, 손실 함수, 최적화 도구 세팅
# ==========================================
model = CustomAlexNet(num_classes=2).to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001, weight_decay=1e-4)

# ==========================================
# 5. 본격적인 학습 시작 (Train Loop)
# ==========================================
if __name__ == '__main__':
    print("🚀 의료분석 스터디: 강아지/고양이 분류기 학습을 시작합니다!\n")
    
    for epoch in range(EPOCHS):
        model.train() 
        running_loss = 0.0
        
        # 🎯 정확도 계산을 위한 변수 추가
        correct = 0
        total = 0
        
        for i, (images, labels) in enumerate(train_loader):
            images = images.to(device)
            labels = labels.to(device)
            
            # AI에게 사진을 보여주고 정답 예측
            outputs = model(images)
            loss = criterion(outputs, labels)
            
            # 오답 노트 정리 및 뇌세포 업데이트
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            
            running_loss += loss.item()
            
            # 🎯 AI가 예측한 정답과 실제 정답을 비교하여 맞춘 개수 세기
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0) # 이번 배치에서 푼 전체 문제 수
            correct += (predicted == labels).sum().item() # 그 중 맞춘 개수
            
            if (i + 1) % 100 == 0:
                print(f"   > [Epoch {epoch+1}/{EPOCHS}, Step {i+1}/{len(train_loader)}] 진행 중...")
        
        # 한 학기(Epoch)가 끝날 때마다 평균 오차와 정확도 계산 및 출력
        epoch_loss = running_loss / len(train_loader)
        epoch_acc = 100 * correct / total # 🎯 (맞춘 개수 / 전체 문제 수) * 100
        
        print(f"🎉 [Epoch {epoch+1} 완료] 평균 오차(Loss): {epoch_loss:.4f} | 🎯 훈련 정확도: {epoch_acc:.2f}%\n")

    # ==========================================
    # 6. 똑똑해진 AI의 뇌 저장하기
    # ==========================================
    torch.save(model.state_dict(), 'alexnet_cats_dogs.pth')
    print("✅ 학습 종료! 똑똑해진 AI의 뇌가 'alexnet_cats_dogs.pth' 파일로 저장되었습니다.")