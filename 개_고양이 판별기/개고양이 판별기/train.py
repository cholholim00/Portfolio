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
LEARNING_RATE = 0.0001
EPOCHS = 20

# ==========================================
# 2. 데이터 전처리 (심폐소생술 적용)
# ==========================================
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    # 🎯 처방 2: 너무 가혹한 훈련은 빼고, 좌우 반전만 남깁니다.
    transforms.RandomHorizontalFlip(p=0.5), 
    transforms.ToTensor(),
    # 🎯 처방 3: 뇌세포 보호막! 사진의 숫자 크기를 일정하게 눌러서 뇌세포가 타버리는 걸 막습니다.
    transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]) 
])

# ==========================================
# 3. 데이터 로더
# ==========================================
train_dir = './dataset/training_set'

if not os.path.exists(train_dir):
    print("❌ 'dataset/training_set' 폴더가 없습니다.")
    exit()

train_dataset = datasets.ImageFolder(root=train_dir, transform=transform)
train_loader = DataLoader(dataset=train_dataset, batch_size=BATCH_SIZE, shuffle=True, num_workers=0)

# ==========================================
# 4. 모델, 손실 함수, 최적화 도구 세팅
# ==========================================
model = CustomAlexNet(num_classes=2).to(device)
criterion = nn.CrossEntropyLoss()

# 🎯 처방 4: weight_decay(암기 방지약)를 아주 살짝만 타서 넣어줍니다.
optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE, weight_decay=1e-4)

# ==========================================
# 5. 본격적인 학습 시작 (Train Loop)
# ==========================================
if __name__ == '__main__':
    print("🚀 의료분석 딥러닝 스터디: 내 AI 키우기를 시작합니다!\n")
    
    for epoch in range(EPOCHS):
        model.train() 
        running_loss = 0.0
        correct = 0
        total = 0
        
        for i, (images, labels) in enumerate(train_loader):
            images = images.to(device)
            labels = labels.to(device)
            
            outputs = model(images)
            loss = criterion(outputs, labels)
            
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            
            running_loss += loss.item()
            
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            
            if (i + 1) % 100 == 0:
                print(f"   > [Epoch {epoch+1}/{EPOCHS}, Step {i+1}/{len(train_loader)}] 심폐소생 중...")
        
        epoch_loss = running_loss / len(train_loader)
        epoch_acc = 100 * correct / total 
        
        print(f"🎉 [Epoch {epoch+1} 완료] 오차: {epoch_loss:.4f} | 🎯 훈련 정확도: {epoch_acc:.2f}%\n")

    # 똑똑해진 AI 뇌 저장하기
    torch.save(model.state_dict(), 'alexnet_cats_dogs_scratch.pth')
    print("✅ 학습 종료! 'alexnet_cats_dogs_scratch.pth' 파일로 저장되었습니다.")