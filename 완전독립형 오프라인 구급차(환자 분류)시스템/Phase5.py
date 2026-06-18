# 메인 단계 5: 파이프라인 통합 및 하이브리드 확장 - Python에서 C++ 엔진 제어하기
import ctypes
import os

# 1. C++ 코어 엔진(DLL) 로드
dll_path = os.path.abspath('triage_engine.dll')
engine = ctypes.CDLL(dll_path)

# 2. C++ API 함수들의 입력/출력 데이터 타입 명시 (매우 중요)
# C++의 float, int 타입을 파이썬이 정확히 이해하도록 설정합니다.
engine.addPatient.argtypes = [ctypes.c_int, ctypes.c_float, ctypes.c_float, ctypes.c_float]
engine.addPatient.restype = ctypes.c_int

engine.popNextPatient.argtypes = []
engine.popNextPatient.restype = ctypes.c_int

print("=== [Python Front-end] 하이브리드 구급차 시스템 가동 ===")

# 3. 파이썬에서 환자 데이터 입력 -> C++ 엔진이 즉시 계산 및 정렬
print("\n[입력] 환자 3명 데이터 엔진 전송 중...")

# 환자 A (가벼운 증상)
score_A = engine.addPatient(1001, 65.0, 105.0, 92.0)
print(f" -> 환자 1001 엔진 적재 완료 (K-NN 판정: {score_A}등급)")

# 환자 B (정상)
score_B = engine.addPatient(1002, 75.0, 115.0, 97.0)
print(f" -> 환자 1002 엔진 적재 완료 (K-NN 판정: {score_B}등급)")

# 환자 C (초응급 - 새치기 발생해야 함)
score_C = engine.addPatient(1003, 130.0, 80.0, 85.0)
print(f" -> 환자 1003 엔진 적재 완료 (K-NN 판정: {score_C}등급)")

# 4. 정렬된 큐에서 1순위 환자부터 순서대로 추출 (치료 시작)
print("\n[출력] C++ 우선순위 큐 정렬 결과 (치료 순서 도출)")
for i in range(3):
    target_id = engine.popNextPatient()
    print(f"{i+1}순위 치료 대상자: 환자 ID {target_id}")

print("\n=== 시스템 정상 종료 ===")