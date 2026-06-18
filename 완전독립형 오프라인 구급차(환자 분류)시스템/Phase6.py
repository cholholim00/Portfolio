# 메인 단계 6: 환자 모니터/기록지 OCR 자동화 파이프라인 (Vision 통합) 업데이트
import ctypes
import os
import cv2
import numpy as np
import easyocr
import re
import warnings

# PyTorch 관련 불필요한 경고 메시지 숨김
warnings.filterwarnings("ignore")

# =========================================================
# 1. C++ 코어 엔진 (DLL) 로드
# =========================================================
dll_path = os.path.abspath('triage_engine.dll')
engine = ctypes.CDLL(dll_path)

engine.addPatient.argtypes = [ctypes.c_int, ctypes.c_float, ctypes.c_float, ctypes.c_float]
engine.addPatient.restype = ctypes.c_int
engine.popNextPatient.argtypes = []
engine.popNextPatient.restype = ctypes.c_int

# =========================================================
# 2. Vision 모듈: 가상의 구급 모니터 이미지 생성
# =========================================================
def create_dummy_monitor_image(filename="monitor.png"):
    # 검은색 배경의 모니터 화면 생성
    img = np.zeros((300, 500, 3), dtype=np.uint8)
    
    # 위급한 환자의 생체 데이터를 화면에 그리기 (OpenCV)
    cv2.putText(img, "PATIENT ID: 1004", (30, 50), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (255,255,255), 2)
    cv2.putText(img, "HR: 135 bpm", (30, 110), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0,0,255), 2)   # 빈맥
    cv2.putText(img, "SBP: 80 mmHg", (30, 170), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0,255,255), 2) # 저혈압
    cv2.putText(img, "SpO2: 85 %", (30, 230), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (255,0,0), 2)     # 저산소증
    
    cv2.imwrite(filename, img)
    return filename

# =========================================================
# 3. Vision 모듈: OCR 텍스트 추출 및 정규식 파싱
# =========================================================
def extract_vitals_ocr(image_path, reader):
    print(f"\n[Vision] '{image_path}' 카메라 렌즈 스캔 중...")
    
    # 이미지에서 텍스트 추출
    results = reader.readtext(image_path, detail=0)
    text = " ".join(results).upper()
    print(f"[Vision] 추출된 원시 텍스트: {text}")
    
    # 정규식(Regex)을 이용해 특정 키워드 주변의 숫자만 정밀 타겟팅
    try:
        patient_id = int(re.search(r'ID.*?(\d+)', text).group(1))
        hr = float(re.search(r'HR.*?(\d+)', text).group(1))
        bp = float(re.search(r'SBP.*?(\d+)', text).group(1))
        spo2 = float(re.search(r'SPO2.*?(\d+)', text).group(1))
        
        print(f" -> [데이터 파싱 성공] HR:{hr}, SBP:{bp}, SpO2:{spo2}")
        return patient_id, hr, bp, spo2
    except AttributeError:
        print(" -> [Error] OCR 인식 실패 또는 데이터 누락. 수동 입력이 필요합니다.")
        return -1, 0, 0, 0

# =========================================================
# 4. 메인 시스템 가동
# =========================================================
if __name__ == "__main__":
    print("=== [Hybrid System] Vision-OCR 구급차 Triage 시스템 가동 ===")
    
    # EasyOCR 리더 초기화 (최초 실행 시 모델 다운로드로 수 분 소요될 수 있음)
    print("\n[System] Vision 모델 로딩 중 (GPU 가속 대기)...")
    reader = easyocr.Reader(['en'], gpu=True) 

    # 1. 수동 입력 환자 2명 엔진 적재 (기존 방식)
    print("\n[System] 수동 데이터 엔진 전송 중...")
    engine.addPatient(1001, 65.0, 105.0, 92.0)
    engine.addPatient(1002, 75.0, 115.0, 97.0)
    print(" -> 환자 1001, 1002 적재 완료")

    # 2. OCR 자동화 환자 적재 (Vision 방식)
    image_file = create_dummy_monitor_image() # 이미지 캡처 찰칵!
    p_id, hr, bp, spo2 = extract_vitals_ocr(image_file, reader)
    
    if p_id != -1:
        score = engine.addPatient(p_id, hr, bp, spo2)
        print(f" -> 환자 {p_id} 엔진 적재 완료 (K-NN 판정: {score}등급)")

    # 3. 최종 C++ 대기열 정렬 결과 도출
    print("\n[출력] C++ 코어 연산 완료 - 치료 우선순위 결과")
    for i in range(3):
        target_id = engine.popNextPatient()
        print(f" {i+1}순위 치료 대상자: 환자 ID {target_id}")

    print("\n=== 시스템 정상 종료 ===")