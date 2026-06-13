import torch
import torch.nn as nn

class CustomAlexNet(nn.Module):
    def __init__(self, num_classes=2): 
        # num_classes: 맞출 정답의 개수 (개/고양이면 2, 정상/폐렴이면 2)
        super(CustomAlexNet, self).__init__()
        
        # ==========================================
        # 1. 특징 추출 부분 (Features) - 이미지에서 패턴을 찾음
        # ==========================================
        self.features = nn.Sequential(
            # [1번째 층] 큰 특징(선, 색상 등)을 찾습니다.
            nn.Conv2d(in_channels=3, out_channels=64, kernel_size=11, stride=4, padding=2),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),
            
            # [2번째 층] 더 복잡한 형태를 찾습니다.
            nn.Conv2d(64, 192, kernel_size=5, padding=2),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),
            
            # [3, 4, 5번째 층] 촘촘하게 세부 특징을 뽑아냅니다. (여긴 MaxPool이 없습니다)
            nn.Conv2d(192, 384, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(384, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(256, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=3, stride=2),
        )
        
        # ==========================================
        # 2. 분류 부분 (Classifier) - 찾은 특징을 바탕으로 정답을 결정함
        # ==========================================
        self.classifier = nn.Sequential(
            # 노이즈를 줄이고 과적합을 막는 Dropout
            nn.Dropout(p=0.5),
            nn.Linear(256 * 6 * 6, 4096),
            nn.ReLU(inplace=True),
            
            nn.Dropout(p=0.5),
            nn.Linear(4096, 4096),
            nn.ReLU(inplace=True),
            
            # 최종 출력: 정답의 개수(num_classes)만큼 확률을 계산
            nn.Linear(4096, num_classes),
        )

    def forward(self, x):
        # 1. 이미지 통과시켜서 특징 뽑기
        x = self.features(x)
        
        # 2. 이미지를 1차원(한 줄)으로 쫙 펴주기 (분류기에 넣기 위함)
        x = torch.flatten(x, 1)
        
        # 3. 분류기 통과시켜서 최종 정답 내기
        x = self.classifier(x)
        return x

# 모델이 잘 만들어졌는지 테스트
if __name__ == '__main__':
    model = CustomAlexNet(num_classes=2)
    # 가상의 이미지 데이터 (배치사이즈 1, RGB 3채널, 크기 224x224)
    dummy_input = torch.randn(1, 3, 224, 224)
    output = model(dummy_input)
    
    print("✅ AlexNet 모델 생성 완료!")
    print(f"👉 입력 이미지 크기: {dummy_input.shape}")
    print(f"👉 출력 결과 크기: {output.shape} (정답 개수 2개를 의미)")