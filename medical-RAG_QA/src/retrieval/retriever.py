"""
유사도 검색 모듈
"""
from typing import List, Dict


def retrieve(collection, query_embedding: List[float], top_k: int = 5) -> List[Dict]:
    """쿼리 임베딩 → 유사 청크 검색"""
    results = collection.query(
        query_embeddings=[query_embedding],
        n_results=top_k,
        include=["documents", "metadatas", "distances"],
    )
    retrieved = []
    for doc, meta, dist in zip(
        results["documents"][0],
        results["metadatas"][0],
        results["distances"][0],
    ):
        retrieved.append({
            "text": doc,
            "metadata": meta,
            "score": round(1 - dist, 4),  # cosine similarity
        })
    return retrieved
