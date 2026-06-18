# 🚑 완전 독립형 오프라인 구급차 Triage 시스템 (Hybrid Edge Pipeline)

![C++](https://img.shields.io/badge/C++-11-blue.svg) ![Python](https://img.shields.io/badge/Python-3.x-yellow.svg) ![OpenCV](https://img.shields.io/badge/OpenCV-Vision-green.svg)

통신이 단절된 재난 현장이나 구급차 내부의 **제한된 엣지(Edge) 컴퓨팅 환경**에서 작동하는 경량화 환자 분류(Triage) 시스템입니다. 환자의 생체 데이터와 EKG(심전도) 이미지를 분석하여 딥러닝 서버 의존 없이 **골든타임 내 최우선 치료 대상자를 실시간으로 정렬**합니다.

## 📺 시연 화면 (Demo)
![EKG 파형 분석 화면](./구급차%20KNN환자%20분류기.png)
## ⚙️ 아키텍처 및 핵심 기술 (C++ & Python Hybrid)
무거운 연산과 UI 처리를 철저히 분리한 하이브리드 파이프라인을 구축했습니다.

1. **Back-end 코어 엔진 (C++)**
   - **Zero-Dependency K-NN 알고리즘:** `<cmath>` 수학 연산만으로 유클리디안 거리를 계산하여 초고속 위급도(1~5등급) 판별.
   - **Low-level 메모리 제어:** 동적 할당(`new`/`delete`)과 포인터 스와핑(Pointer Swapping)을 활용한 **우선순위 큐(Priority Queue)** 구현으로 병목 현상 및 메모리 누수 원천 차단.
2. **Front-end & Vision (Python / OpenCV)**
   - **아날로그 EKG 신호 분석:** `OpenCV`와 `SciPy`를 활용하여 심전도 이미지의 배경 격자를 제거하고 **R-Peak 픽셀 간격을 수학적으로 계산해 심박수(BPM)를 도출**.
   - `ctypes` 동적 라이브러리(DLL) 연동을 통해 파이썬에서 추출한 비전 데이터를 C++ 메모리로 즉시 전송.

## 📂 프로젝트 구조 (Directory Tree)
```text
📦 Offline-Triage-System
 ┣ 📜 triage_engine.cpp    # C++ K-NN & Priority Queue 코어 엔진
 ┣ 📜 gui_app.py           # Tkinter 기반 구급대원용 UI 및 Vision 연동
 ┣ 📜 app.py               # 터미널 전용 CLI 실행 스크립트
 ┣ 🖼️ EKG.png              # 테스트용 EKG 아날로그 파형 데이터
 ┗ 📜 README.md
```

## 🛠️ 사전 요구 사항 (Prerequisites)
```text
OS: Windows 환경 권장 (DLL 빌드 및 ctypes 연동)
Compiler: g++ (MinGW 등 C++11 지원 컴파일러)
Python: Python 3.8 이상
```

## 🚀 실행 방법 (How to Run)
1. C++ 코어 엔진(DLL) 컴파일
```Bash
g++ -std=c++11 -shared -o triage_engine.dll triage_engine.cpp
```

2. Python 의존성 설치 및 GUI 앱 실행
```Bash
pip install opencv-python numpy scipy
python gui_app.py
```