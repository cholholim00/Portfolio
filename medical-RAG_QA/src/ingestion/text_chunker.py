"""
텍스트 청킹 모듈
LangChain RecursiveCharacterTextSplitter 활용
"""
from langchain_text_splitters import RecursiveCharacterTextSplitter
from typing import List, Dict
import os

CHUNK_SIZE = int(os.getenv("CHUNK_SIZE", 512))
CHUNK_OVERLAP = int(os.getenv("CHUNK_OVERLAP", 50))


def chunk_papers(papers: List[Dict]) -> List[Dict]:
    """논문 리스트 → 청크 리스트 변환 (메타데이터 보존)"""
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE,
        chunk_overlap=CHUNK_OVERLAP,
        separators=["\n\n", "\n", ". ", " "],
    )
    chunks = []
    for paper in papers:
        splits = splitter.split_text(paper["full_text"])
        for i, split in enumerate(splits):
            chunks.append({
                "text": split,
                "metadata": {
                    "pmid": paper["pmid"],
                    "title": paper["title"],
                    "year": paper["year"],
                    "url": paper["url"],
                    "chunk_index": i,
                }
            })
    return chunks