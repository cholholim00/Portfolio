"""
FastAPI 라우터
"""
from fastapi import FastAPI, HTTPException
from src.api.schemas import QARequest, QAResponse, IngestRequest, IngestResponse, StatusResponse
from src.generation.rag_chain import MedicalRAGChain
from src.embedding.embedder import MedicalEmbedder
from src.retrieval.vector_store import get_chroma_client, get_or_create_collection
from src.ingestion.pubmed_fetcher import search_pubmed, fetch_paper_details
from src.ingestion.preprocessor import preprocess_papers
from src.ingestion.text_chunker import chunk_papers
from src.retrieval.vector_store import add_chunks_to_db

app = FastAPI(title="Medical RAG Q&A API", version="1.0.0")

# 앱 시작 시 체인 초기화
client = get_chroma_client()
collection = get_or_create_collection(client)
embedder = MedicalEmbedder()
chain = MedicalRAGChain(collection, embedder)


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.get("/status", response_model=StatusResponse)
def get_status():
    return StatusResponse(
        status="ok",
        total_chunks=collection.count(),
        embedding_model="sentence-transformers/all-MiniLM-L6-v2",
        llm_model="gpt-4o-mini",
    )


@app.post("/qa", response_model=QAResponse)
def qa(request: QARequest):
    try:
        result = chain.run(request.question, top_k=request.top_k)
        return QAResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/ingest", response_model=IngestResponse)
def ingest(request: IngestRequest):
    try:
        before = collection.count()
        pmids = search_pubmed(request.query, max_results=request.max_papers)
        papers = fetch_paper_details(pmids)
        papers = preprocess_papers(papers)
        chunks = chunk_papers(papers)
        embeddings = embedder.embed([c["text"] for c in chunks]).tolist()
        add_chunks_to_db(collection, chunks, embeddings)
        after = collection.count()
        return IngestResponse(
            status="success",
            papers_collected=len(papers),
            chunks_added=after - before,
            total_chunks=after,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))