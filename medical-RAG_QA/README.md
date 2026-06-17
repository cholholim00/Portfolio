# 🏥 Medical RAG Q&A System

PubMed 논문 기반 의료 질의응답 RAG 시스템  
한국어/영어 질문을 모두 지원하며, 답변은 항상 한국어로 제공됩니다.

## 📐 아키텍처

```
사용자 질문 (한국어/영어)
        ↓
한국어 → 영어 번역 (GPT-4o-mini)
        ↓
임베딩 (all-MiniLM-L6-v2)
        ↓
벡터 검색 (ChromaDB)
        ↓
한국어 답변 생성 (GPT-4o-mini)
        ↓
Streamlit UI (답변 + 논문 출처)
```

## 🚀 빠른 시작

```bash
# 1. 환경 설정
pip install -r requirements.txt
cp .env.example .env
# .env 파일에서 OPENAI_API_KEY, ENTREZ_EMAIL 입력

# 2. 논문 수집 & 벡터 DB 구축
python main.py --query "diabetes treatment" --max_papers 100

# 3. UI 실행
streamlit run streamlit_app/app.py
```

## 📁 구조

```
medical-rag-qa/
├── main.py                  # 파이프라인 실행 진입점
├── run_qa.py                # 터미널 테스트용
├── requirements.txt
├── .env.example             # API 키 설정 템플릿
├── src/
│   ├── ingestion/
│   │   ├── pubmed_fetcher.py   # PubMed API 수집 + 캐시
│   │   ├── preprocessor.py     # 텍스트 정제
│   │   └── text_chunker.py     # 청킹 (512토큰)
│   ├── embedding/
│   │   └── embedder.py         # all-MiniLM-L6-v2 임베딩
│   ├── retrieval/
│   │   ├── vector_store.py     # ChromaDB 관리
│   │   └── retriever.py        # 유사도 검색
│   ├── generation/
│   │   ├── llm.py              # OpenAI/HuggingFace 전환 가능
│   │   ├── prompt_templates.py # 한국어 답변 프롬프트
│   │   └── rag_chain.py        # 번역 + 검색 + 생성 통합
│   └── api/
│       ├── router.py           # FastAPI 엔드포인트
│       └── schemas.py          # Pydantic 스키마
├── streamlit_app/
│   ├── app.py                  # 메인 UI
│   └── components.py           # 재사용 컴포넌트
├── notebooks/
│   ├── 01_data_exploration.ipynb   # 데이터 탐색
│   ├── 02_embedding_test.ipynb     # 임베딩 품질 검증
│   └── 03_rag_evaluation.ipynb     # RAGAS 성능 평가
├── tests/
│   ├── test_ingestion.py       # 패키지 + PubMed + ChromaDB
│   ├── test_retrieval.py       # 임베딩 + 벡터 검색
│   └── test_generation.py      # OpenAI + 프롬프트
├── data/
│   ├── raw/                    # 수집 논문 JSON 캐시
│   └── processed/              # 전처리 결과
├── vectordb/                   # ChromaDB 저장소
└── docs/
    ├── architecture.md         # 시스템 구조 상세
    └── api_docs.md             # API 명세
```

## 🛠 기술 스택

| 구성 요소 | 기술 |
|---|---|
| 데이터 수집 | BioPython (Entrez API) |
| 텍스트 분할 | LangChain RecursiveCharacterTextSplitter |
| 임베딩 | sentence-transformers/all-MiniLM-L6-v2 |
| 벡터 DB | ChromaDB |
| LLM | GPT-4o-mini (OpenAI) |
| 번역 | GPT-4o-mini (KO→EN 자동 감지) |
| API 서버 | FastAPI |
| UI | Streamlit |
| 성능 평가 | RAGAS |

## ⚙️ 환경 변수 (.env)

```
OPENAI_API_KEY=sk-...           # OpenAI API 키
ENTREZ_EMAIL=your@email.com     # PubMed API용 이메일
CHROMA_PERSIST_DIR=./vectordb   # 벡터 DB 저장 경로
LLM_PROVIDER=openai             # openai 또는 huggingface
CHUNK_SIZE=512                  # 청킹 토큰 크기
CHUNK_OVERLAP=50                # 청킹 오버랩
```

## 🧪 테스트

```bash
# 1주차: 패키지 설치 + PubMed + ChromaDB 확인
python tests/test_ingestion.py

# 2주차: 임베딩 + 벡터 검색 확인
python tests/test_retrieval.py

# 3주차: OpenAI API + 프롬프트 확인
python tests/test_generation.py
```

## 📊 성능 평가 (RAGAS)

`notebooks/03_rag_evaluation.ipynb` 실행 시 아래 4가지 지표를 측정합니다:

| 지표 | 설명 |
|---|---|
| Faithfulness | 답변이 검색된 논문에 근거하는 정도 |
| Answer Relevancy | 답변이 질문과 관련된 정도 |
| Context Precision | 검색된 문서의 정밀도 |
| Context Recall | 관련 문서를 빠짐없이 검색한 정도 |

## 💡 추가 논문 수집

```bash
# 새로운 키워드로 논문 추가 수집
python main.py --query "metformin side effects" --max_papers 50

# 캐시 무시하고 재수집
python main.py --query "diabetes treatment" --no_cache
```