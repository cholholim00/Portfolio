# 메인 단계 7: EKG 이미지를 직접 분석, C++ 코어 엔진과 통신하는 하이브리드 파이프라인
import ctypes
import os
import cv2
import numpy as np
from scipy.signal import find_peaks

# =========================================================
# 1. C++ 코어 엔진 (DLL) 로드 및 인터페이스 설정
# =========================================================
dll_path = os.path.abspath('triage_engine.dll')
engine = ctypes.CDLL(dll_path)

engine.addPatient.argtypes = [ctypes.c_int, ctypes.c_float, ctypes.c_float, ctypes.c_float]
engine.addPatient.restype = ctypes.c_int
engine.popNextPatient.argtypes = []
engine.popNextPatient.restype = ctypes.c_int

# =========================================================
# 2. Vision 모듈: EKG 파형 분석 및 심박수 추출 엔진
# =========================================================
def extract_hr_from_ekg(image_path):
    print(f"\n[Vision] EKG 아날로그 파형 분석 시작: '{image_path}'")
    
    # 1. 이미지 로드
    img = cv2.imread(image_path)
    if img is None:
        print(" -> [Error] 이미지를 찾을 수 없습니다. 파일명을 확인해주세요.")
        return -1
        
    h, w, _ = img.shape

    # 2. 하단 리듬 스트립(Rhythm Strip) 영역 추출
    # 12유도 심전도의 가장 아래쪽(Lead II)이 가장 길고 노이즈가 적습니다. 하단 25%만 잘라냅니다.
    strip = img[int(h*0.75):h, :]

    # 3. 붉은색 모눈 격자 제거 및 검은색 파형만 추출 (Thresholding)
    gray = cv2.cvtColor(strip, cv2.COLOR_BGR2GRAY)
    # 픽셀 값이 120 이하인 어두운 색(검은 선)만 흰색(255)으로 반전시킵니다.
    _, binary = cv2.threshold(gray, 120, 255, cv2.THRESH_BINARY_INV)

    # 4. 각 세로열(Column)별 픽셀 밀도 합산
    # R-Peak는 위아래로 길게 뻗은 선이므로, 해당 지점의 세로 픽셀 합이 가장 높습니다.
    col_sums = np.sum(binary == 255, axis=0)

    # 5. SciPy를 이용해 R-Peak(최고점) 좌표 탐지
    # distance: 피크 간 최소 거리 (사람의 한계 심박수 고려)
    # height: 자잘한 노이즈(P파, T파)를 걸러내기 위한 임계값
    peaks, _ = find_peaks(col_sums, distance=w//30, height=np.max(col_sums)*0.4)

    if len(peaks) < 2:
        print(" -> [Error] 분석 가능한 R-Peak가 부족합니다.")
        return -1

    # 6. 수학적 BPM 환산
    # 표준 12유도 심전도 용지의 가로 전체 길이는 통상적으로 10초 분량입니다.
    pixels_per_second = w / 10.0
    
    # R-Peak 간의 평균 픽셀 거리를 구합니다.
    avg_rr_pixels = np.mean(np.diff(peaks))
    
    # 픽셀 거리를 시간(초)으로 변환하고, 60을 나누어 1분당 심박수(BPM)를 도출합니다.
    avg_rr_seconds = avg_rr_pixels / pixels_per_second
    bpm = int(60 / avg_rr_seconds)
    
    print(f" -> [분석 완료] 총 {len(peaks)}개의 R-Peak 신호 탐지")
    print(f" -> [계산 결과] 평균 R-R 간격: {avg_rr_seconds:.2f}초 -> 심박수 추정: {bpm} BPM")
    
    return bpm

# =========================================================
# 3. 메인 시스템 가동 (Hybrid Pipeline)
# =========================================================
if __name__ == "__main__":
    print("=== [Hybrid System] EKG Vision-to-C++ Triage 시스템 가동 ===")
    
    # 1. 기존 대기 환자 데이터 적재 (수동 입력)
    print("\n[System] 기존 대기열 환자 데이터 엔진 전송 중...")
    engine.addPatient(1001, 65.0, 105.0, 92.0)
    engine.addPatient(1002, 75.0, 115.0, 97.0)
    print(" -> 환자 1001, 1002 적재 완료 (K-NN 대기열 정렬 완료)")

    # 2. 신규 응급 환자의 EKG 이미지 실시간 분석
    # (혈압과 산소포화도는 임의의 위급 수치로 가정)
    ekg_bpm = extract_hr_from_ekg("EKG.png")
    
    if ekg_bpm != -1:
        print("\n[System] 분석된 EKG 데이터를 C++ 엔진으로 전송합니다...")
        score = engine.addPatient(1003, float(ekg_bpm), 80.0, 85.0)
        print(f" -> 환자 1003 엔진 적재 완료 (K-NN 판정: {score}등급)")

    # 3. 최종 C++ 대기열 정렬 결과 도출
    print("\n[출력] C++ 코어 엔진 우선순위 큐 최종 결과 (치료 순서)")
    for i in range(3):
        target_id = engine.popNextPatient()
        # 큐가 비어있으면 -1을 반환하므로 예외 처리
        if target_id != -1:
            print(f" {i+1}순위 즉각 치료 대상자: 환자 ID {target_id}")

    print("\n=== 시스템 메모리 반환 및 안전 종료 ===")