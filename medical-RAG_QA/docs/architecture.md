# 시스템 아키텍처

## 전체 구조

```
사용자 질문 (한국어/영어)
        │
        ▼
┌─────────────────┐
│  Streamlit UI   │  streamlit_app/app.py
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   RAG Chain     │  src/generation/rag_chain.py
│                 │
│ 1. 번역 (KO→EN) │  GPT-4o-mini
│ 2. 임베딩       │  all-MiniLM-L6-v2
│ 3. 벡터 검색    │  ChromaDB
│ 4. 답변 생성    │  GPT-4o-mini
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   ChromaDB      │  vectordb/
│  (벡터 저장소)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  PubMed 논문    │  data/processed/
│  (187개 청크)   │
└─────────────────┘
```

## 데이터 파이프라인

```
PubMed API (Entrez)
        │
        ▼
논문 수집 (pubmed_fetcher.py)
- PMID 검색
- Abstract + 메타데이터 수집
- Rate limit: 3 req/sec
        │
        ▼
전처리 (preprocessor.py)
- 빈 초록 제거
- 특수문자 정제
- title + abstract 결합
        │
        ▼
청킹 (text_chunker.py)
- RecursiveCharacterTextSplitter
- chunk_size: 512
- chunk_overlap: 50
        │
        ▼
임베딩 (embedder.py)
- 모델: all-MiniLM-L6-v2
- 벡터 차원: 384
        │
        ▼
벡터 저장 (vector_store.py)
- ChromaDB PersistentClient
- cosine similarity
```

## RAG 질의응답 흐름

```
1. 사용자 질문 입력
2. 한국어 감지 → GPT로 영어 번역
3. 번역된 쿼리 임베딩 (384차원)
4. ChromaDB cosine similarity 검색 (top-k)
5. 검색된 청크 + 원래 질문 → 프롬프트 구성
6. GPT-4o-mini → 한국어 답변 생성
7. 답변 + 참고 논문 출처 반환
```

## 기술 스택

| 구성 요소 | 기술 | 버전 |
|---|---|---|
| 데이터 수집 | BioPython (Entrez) | 1.83+ |
| 텍스트 분할 | LangChain TextSplitter | 0.2+ |
| 임베딩 모델 | sentence-transformers | 3.0+ |
| 벡터 DB | ChromaDB | 0.5+ |
| LLM | OpenAI GPT-4o-mini | - |
| API 서버 | FastAPI | 0.111+ |
| UI | Streamlit | 1.35+ |
| 평가 | RAGAS | 0.1+ |

## 디렉토리 구조

```
medical-rag-qa/
├── main.py                  # 파이프라인 실행 진입점
├── run_qa.py                # 터미널 테스트용
├── requirements.txt
├── .env                     # API 키 (git 제외)
├── src/
│   ├── ingestion/           # 수집 → 전처리 → 청킹
│   ├── embedding/           # 임베딩
│   ├── retrieval/           # 벡터 검색
│   ├── generation/          # LLM + RAG 체인
│   └── api/                 # FastAPI
├── streamlit_app/           # UI
├── notebooks/               # 실험/평가
├── data/                    # 수집 데이터 저장
├── vectordb/                # ChromaDB 저장소
└── docs/                    # 문서
```