import streamlit as st
import torch
import torch.nn.functional as F
from torchvision import transforms
from PIL import Image
from alexnet import CustomAlexNet # 우리가 만든 뼈대

# ==========================================
# 1. 페이지 기본 설정
# ==========================================
st.set_page_config(page_title="HANA AI 판별기", page_icon="🐶", layout="centered")

st.title("🐶🐱 HANA 스터디: 개/고양이 AI 판별기")
st.write("강아지나 고양이 사진을 업로드하면, AI가 누구인지 맞혀줍니다!")

# ==========================================
# 2. 모델 및 전처리 세팅 (캐싱으로 속도 향상)
# ==========================================
@st.cache_resource # 웹페이지가 새로고침 될 때마다 모델을 다시 부르지 않게 고정
def load_model():
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = CustomAlexNet(num_classes=2).to(device)
    # 🎯 방금 열심히 20번 돌려서 만든 바로 그 뇌!
    model.load_state_dict(torch.load('alexnet_cats_dogs_scratch.pth', map_location=device))
    model.eval()
    return model, device

model, device = load_model()

# 🎯 학습할 때 썼던 도수(0.5) 그대로 색안경 준비
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
])

classes = ['고양이 🐱', '강아지 🐶']

# ==========================================
# 3. 이미지 업로드 및 AI 예측 기능
# ==========================================
# 파일 업로드 창 만들기
uploaded_file = st.file_uploader("사진을 올려주세요! (jpg, png, jpeg)", type=["jpg", "png", "jpeg"])

if uploaded_file is not None:
    # 1. 업로드된 이미지 화면에 보여주기
    image = Image.open(uploaded_file).convert('RGB')
    st.image(image, caption='업로드된 사진', use_column_width=True)
    
    st.write("🧠 AI가 사진을 분석하고 있습니다...")
    
    # 2. AI가 먹을 수 있게 사진 다듬기
    img_tensor = transform(image).unsqueeze(0).to(device)
    
    # 3. AI의 예측!
    with torch.no_grad():
        outputs = model(img_tensor)
        
        # Softmax를 써서 AI의 확신 정도(%)를 계산합니다.
        probabilities = F.softmax(outputs, dim=1)[0] * 100
        
        # 가장 높은 확률을 가진 정답 고르기
        _, predicted = torch.max(outputs, 1)
        
        final_answer = classes[predicted.item()]
        confidence = probabilities[predicted.item()].item()

    # 4. 결과 출력
    st.success(f"🎉 AI 분석 결과: 이 사진은 **{confidence:.2f}%**의 확률로 **{final_answer}** 입니다!")
    
    # 막대 그래프로 두 확률 모두 보여주기
    st.write("📊 **상세 분석 수치**")
    st.progress(int(probabilities[0].item()), text=f"고양이일 확률: {probabilities[0].item():.2f}%")
    st.progress(int(probabilities[1].item()), text=f"강아지일 확률: {probabilities[1].item():.2f}%")