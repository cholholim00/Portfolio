"""
FastAPI Pydantic 스키마
"""
from pydantic import BaseModel, Field
from typing import List, Optional


class QARequest(BaseModel):
    question: str = Field(..., min_length=1, description="질문 (한국어/영어)")
    top_k: int = Field(default=5, ge=1, le=10, description="참고 논문 수")


class SourceItem(BaseModel):
    text: str
    metadata: dict
    score: float


class QAResponse(BaseModel):
    question: str
    english_query: str
    answer: str
    sources: List[SourceItem]


class IngestRequest(BaseModel):
    query: str = Field(..., description="PubMed 검색 키워드")
    max_papers: int = Field(default=50, ge=1, le=500)


class IngestResponse(BaseModel):
    status: str
    papers_collected: int
    chunks_added: int
    total_chunks: int


class StatusResponse(BaseModel):
    status: str
    total_chunks: int
    embedding_model: str
    llm_model: str