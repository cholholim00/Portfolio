# API 문서

## 기본 정보

- **Base URL**: `http://localhost:8000`
- **Framework**: FastAPI
- **응답 형식**: JSON

---

## 엔드포인트

### `POST /qa`
질문을 입력받아 RAG 기반 답변 반환

**Request Body**
```json
{
  "question": "제2형 당뇨병 치료 방법은?",
  "top_k": 5
}
```

**Response**
```json
{
  "question": "제2형 당뇨병 치료 방법은?",
  "english_query": "What are the treatment methods for type 2 diabetes?",
  "answer": "제2형 당뇨병 치료에는...",
  "sources": [
    {
      "text": "Noninsulin medications for type 2 diabetes include...",
      "metadata": {
        "pmid": "42036156",
        "title": "Noninsulin Medications for Type 2 Diabetes.",
        "year": "2026",
        "url": "https://pubmed.ncbi.nlm.nih.gov/42036156/"
      },
      "score": 0.6895
    }
  ]
}
```

---

### `POST /ingest`
새로운 키워드로 PubMed 논문 수집 및 DB 저장

**Request Body**
```json
{
  "query": "metformin side effects",
  "max_papers": 50
}
```

**Response**
```json
{
  "status": "success",
  "papers_collected": 49,
  "chunks_added": 183,
  "total_chunks": 370
}
```

---

### `GET /status`
시스템 상태 확인

**Response**
```json
{
  "status": "ok",
  "total_chunks": 187,
  "embedding_model": "sentence-transformers/all-MiniLM-L6-v2",
  "llm_model": "gpt-4o-mini"
}
```

---

### `GET /health`
서버 헬스체크

**Response**
```json
{
  "status": "healthy"
}
```

---

## 에러 코드

| 코드 | 설명 |
|---|---|
| 400 | 잘못된 요청 (질문 누락 등) |
| 422 | 유효성 검사 실패 |
| 500 | 서버 내부 오류 (LLM API 오류 등) |

---

## 사용 예시 (Python)

```python
import requests

response = requests.post(
    "http://localhost:8000/qa",
    json={"question": "메트포르민 부작용은?", "top_k": 5}
)
print(response.json()["answer"])
```

## 사용 예시 (curl)

```bash
curl -X POST "http://localhost:8000/qa" \
  -H "Content-Type: application/json" \
  -d '{"question": "메트포르민 부작용은?", "top_k": 5}'
```