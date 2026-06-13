import os
import torch
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np
from torchvision import datasets, transforms, models
from torch.utils.data import DataLoader

# ==========================================
# 1. 환경 설정 및 데이터 준비
# ==========================================
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"✅ [의료분석 스터디] 현재 사용 중인 장치: {device}")

# 🎯 수정 1: 학습할 때 썼던 '색안경(Normalize)'을 똑같이 씌워줍니다.
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]) 
])

test_dir = './dataset/test_set'

if not os.path.exists(test_dir):
    print("❌ 앗! 'dataset/test_set' 폴더가 없습니다. 경로를 확인해 주세요!")
    exit()

test_dataset = datasets.ImageFolder(root=test_dir, transform=transform)
test_loader = DataLoader(dataset=test_dataset, batch_size=16, shuffle=True, num_workers=0)

classes = test_dataset.classes

# ==========================================
# 2. 똑똑해진 AI 뇌(모델) 불러오기
# ==========================================
# 🎯 수정 2: CustomAlexNet이 아니라, 학습할 때 썼던 진짜 천재 AI 뼈대를 가져옵니다.
model = models.alexnet(weights=None) # 가중치는 우리가 저장한 걸 쓸 거니까 None!
model.classifier[6] = nn.Linear(4096, 2) # 정답 구멍 2개로 맞추기
model = model.to(device)

try:
    # 스터디장님이 방금 저장하신 96점짜리 뇌를 이식합니다.
    model.load_state_dict(torch.load('models/alexnet_cats_dogs.pth', map_location=device))
    print("✅ 성공적으로 96점짜리 AI의 뇌를 불러왔습니다!")
except FileNotFoundError:
    print("❌ 파일이 없습니다. 이름을 다시 확인해 주세요!")
    exit()

model.eval() 

# ==========================================
# 3. 전체 기말고사 채점 (정확도 계산)
# ==========================================
print("📝 채점을 시작합니다. 잠시만 기다려주세요...")
correct = 0
total = 0

with torch.no_grad():
    for images, labels in test_loader:
        images = images.to(device)
        labels = labels.to(device)
        
        outputs = model(images)
        _, predicted = torch.max(outputs.data, 1)
        
        total += labels.size(0)
        correct += (predicted == labels).sum().item()

accuracy = 100 * correct / total
print(f"🎉 [최종 결과] AI의 기말고사 정답률(Accuracy)은: {accuracy:.2f}% 입니다!")

# ==========================================
# 4. 스터디 눈요기용 시각화 (랜덤 4장 뽑아서 보여주기)
# ==========================================
def imshow(img):
    img = img.cpu()
    npimg = img.numpy().transpose((1, 2, 0))
    
    # 🎯 수정 3: 화면에 그릴 때는 씌웠던 색안경을 다시 벗겨줘야(역정규화) 사진이 예쁘게 나옵니다.
    mean = np.array([0.485, 0.456, 0.406])
    std = np.array([0.229, 0.224, 0.225])
    npimg = std * npimg + mean
    npimg = np.clip(npimg, 0, 1) # 색상 범위 고정
    
    plt.imshow(npimg)

# 랜덤으로 4장 뽑기
dataiter = iter(test_loader)
images, labels = next(dataiter)

images_device = images.to(device)
outputs = model(images_device)
_, predicted = torch.max(outputs, 1)

fig = plt.figure(figsize=(12, 4))
for idx in range(4):
    ax = fig.add_subplot(1, 4, idx+1, xticks=[], yticks=[])
    imshow(images[idx])
    
    true_label = classes[labels[idx]]
    pred_label = classes[predicted[idx]]
    
    color = "green" if true_label == pred_label else "red"
    ax.set_title(f"Pred: {pred_label}\nTrue: {true_label}", color=color, fontweight='bold')

plt.tight_layout()
plt.show()