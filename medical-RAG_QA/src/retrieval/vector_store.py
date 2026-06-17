"""
ChromaDB 벡터 저장소 관리
"""
import chromadb
from chromadb.config import Settings
from typing import List, Dict
import os

PERSIST_DIR = os.getenv("CHROMA_PERSIST_DIR", "./vectordb")


def get_chroma_client():
    return chromadb.PersistentClient(path=PERSIST_DIR)


def get_or_create_collection(client, name: str = "medical_papers"):
    return client.get_or_create_collection(
        name=name,
        metadata={"hnsw:space": "cosine"}
    )


def add_chunks_to_db(collection, chunks: List[Dict], embeddings: List[List[float]]):
    """청크 + 임베딩 → ChromaDB 저장"""
    collection.add(
        documents=[c["text"] for c in chunks],
        embeddings=embeddings,
        metadatas=[c["metadata"] for c in chunks],
        ids=[f"{c['metadata']['pmid']}_chunk{c['metadata']['chunk_index']}" for c in chunks],
    )
    print(f"총 {len(chunks)}개 청크 저장 완료")
