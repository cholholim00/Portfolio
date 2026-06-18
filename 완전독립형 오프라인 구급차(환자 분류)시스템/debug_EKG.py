# 메인 단계 9: EKG 파형 추출 진단 스크립트
import cv2
import numpy as np
from scipy.signal import find_peaks

def debug_ekg_vision(image_path):
    print(f"=== EKG 비전 전처리 디버깅 시작: '{image_path}' ===")
    
    # 1. 원본 이미지 로드
    img = cv2.imread(image_path)
    if img is None:
        print("❌ 에러: 이미지를 찾을 수 없습니다. 경로와 파일명을 다시 확인해주세요.")
        return

    h, w, _ = img.shape
    
    # 2. 크롭 (하단 25% 리듬 스트립)
    strip = img[int(h*0.75):h, :]
    cv2.imwrite("debug_1_crop.png", strip)
    print("✅ 1단계 완료: 하단 잘라내기 저장 (debug_1_crop.png 확인)")

    # 3. 그레이스케일 및 이진화 (핵심 문제 의심 구간)
    gray = cv2.cvtColor(strip, cv2.COLOR_BGR2GRAY)
    
    # 기존보다 조금 더 관대하게 기준값(120 -> 150)을 조정해 봅니다.
    _, binary = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY_INV)
    cv2.imwrite("debug_2_binary.png", binary)
    print("✅ 2단계 완료: 흑백 반전 마스크 저장 (debug_2_binary.png 확인)")

    # 4. R-Peak 픽셀 탐지
    col_sums = np.sum(binary == 255, axis=0)
    peaks, _ = find_peaks(col_sums, distance=w//30, height=np.max(col_sums)*0.4)
    
    print(f"🔍 탐지된 R-Peak 개수: {len(peaks)} 개")
    if len(peaks) < 2:
        print("❌ 실패: 피크가 너무 적습니다. debug_2_binary.png에서 선이 다 지워졌는지 확인하세요.")
    else:
        print("🟢 성공: 파형 탐지 완료! 기준값(Threshold) 조정이 해결책이었습니다.")

if __name__ == "__main__":
    debug_ekg_vision("EKG.png")