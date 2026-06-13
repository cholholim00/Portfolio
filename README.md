# 👋 안녕하세요, cholholim00입니다!

> AI/ML 개발자를 목표로 독학하며 성장하고 있습니다.
> 이 저장소는 제가 진행한 프로젝트들을 모아놓은 포트폴리오 저장소입니다.

---

## 🙋 About Me

- 🤖 비전공자로 AI/ML을 독학하며 실전 프로젝트 중심으로 공부하고 있습니다
- 🛠️ 데이터 수집부터 모델 학습, 배포까지 End-to-End 파이프라인 구축 경험
- 💡 로컬 LLM, NLP, 감성 분석, 토픽 모델링, CNN 등 다양한 AI 기술 적용
- 📚 꾸준히 새로운 기술을 학습하고 프로젝트에 적용합니다

---

## 🔧 기술 스택

**AI/ML**

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![PyTorch](https://img.shields.io/badge/PyTorch-EE4C2C?style=flat&logo=pytorch&logoColor=white)
![HuggingFace](https://img.shields.io/badge/HuggingFace-FFD21E?style=flat&logo=huggingface&logoColor=black)
![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat&logo=ollama&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=flat&logo=scikit-learn&logoColor=white)
![BERTopic](https://img.shields.io/badge/BERTopic-007ACC?style=flat&logoColor=white)

**백엔드 / 배포**

![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat&logo=fastapi&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=flat&logo=streamlit&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)
![ngrok](https://img.shields.io/badge/ngrok-1F1E37?style=flat&logo=ngrok&logoColor=white)

**웹 / 데이터베이스**

![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![Java](https://img.shields.io/badge/Java-007396?style=flat&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=flat&logo=java&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=mysql&logoColor=white)

**도구**

![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)
![Anaconda](https://img.shields.io/badge/Anaconda-44A833?style=flat&logo=anaconda&logoColor=white)
![VSCode](https://img.shields.io/badge/VSCode-007ACC?style=flat&logo=visualstudiocode&logoColor=white)

---

## 📂 프로젝트 목록

### 🤖 [Local LLM Chatbot](./LLM_chatbot)
> Ollama + FastAPI + Streamlit 기반 로컬 LLM 챗봇

- 외부 API 없이 로컬 환경에서 완전히 동작하는 챗봇
- 모델 선택, 시스템 프롬프트 설정, 스트리밍 응답, 세션 관리 기능
- SQLite로 대화 히스토리 영구 저장
- 사용 기술: `Python` `FastAPI` `Streamlit` `Ollama` `SQLite`

---

### 📊 [Reddit SNS 트렌드 분석](./Reddit_SNS_trend_project)
> Reddit 데이터 기반 감성 분석 및 토픽 모델링 파이프라인

- 10개 서브레딧 약 1,006개 포스트 수집 및 분석
- 감성 분석(RoBERTa), 토픽 모델링(BERTopic), 키워드 트렌드 분석
- FastAPI + ngrok 배포
- 사용 기술: `Python` `BERTopic` `HuggingFace` `FastAPI` `ngrok`

---

### 🐾 [개 고양이 판별기](./개_고양이%20판별기)
> CNN 기반 강아지 / 고양이 이미지 분류 프로그램

- 합성곱 신경망(CNN)을 활용한 이미지 분류 모델
- 강아지와 고양이 이미지를 학습하여 실시간 판별
- 사용 기술: `Python` `PyTorch` `CNN`

---

### 🎰 [로또 분석 머신](./로또%20분석%20머신)
> 로또 당첨 번호 CSV 데이터 기반 번호 추천 프로그램

- 역대 로또 당첨 번호 데이터 분석
- 통계 및 머신러닝 기반 번호 추천
- 사용 기술: `Python` `pandas` `scikit-learn`

---

### 💬 BridgeBoard
>실시간 AI 감정 분류 협업 플랫폼

- 화상회의 중 발화자의 감정을 실시간으로 분석하는 AI 기반 협업 서비스
- 한국어 텍스트/음성 2단계 감정 분류 (대분류 6개 → 소분류 22개)
- Test Accuracy 70.58% (klue/roberta-large 파인튜닝)
- 사용 기술: `Python` `PyTorch` `FastAPI` `React` `HuggingFace`

---

### 🐾 [MyPetApp](./MyPetApp)
> AI 힐링 저널 앱

- AI를 활용한 감성 힐링 저널 서비스
- 사용 기술: `Python` `AI`

---

### 🎮 [SNL Minecraft FinalApp](./SNL_Minecraft_FinalApp)
> AI 기반 상황형 밸런스 게임을 통한 성격 분석 프로그램

- 상황별 선택지를 통해 사용자 성격을 분석
- AI 기반 성격 유형 도출
- 사용 기술: `Python` `AI`

---

### ☕ [JSP Blue Bottle](./JSP-blue_bottle)
> 블루보틀 카페 웹사이트 클론 코딩

- JSP 기반 블루보틀 웹사이트 클론
- 사용 기술: `Java` `JSP` `JavaScript` `CSS` `SQL`

---

## 📈 앞으로 추가할 프로젝트

- [ ] RAG 기반 문서 검색 시스템
- [ ] AI 에이전트 (LangGraph / CrewAI)
- [ ] 멀티모달 분석 시스템

---

## 📊 GitHub Stats

![cholholim00's GitHub stats](https://github-readme-stats.vercel.app/api?username=cholholim00&show_icons=true&theme=tokyonight)

![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=cholholim00&layout=compact&theme=tokyonight)

---

## 📫 Contact

- GitHub: [@cholholim00](https://github.com/cholholim00)
