"""
텍스트 전처리 모듈
Reddit 프로젝트 경험 기반 - 의료 텍스트 특화 클리닝
"""
import re
from typing import Dict, List


def clean_abstract(text: str) -> str:
    """초록 텍스트 정제"""
    text = re.sub(r'\s+', ' ', text).strip()
    text = re.sub(r'\[.*?\]', '', text)  # 참조 태그 제거
    return text


def filter_empty_abstracts(papers: List[Dict]) -> List[Dict]:
    """초록 없는 논문 제거"""
    return [p for p in papers if len(p.get("abstract", "")) > 50]


def preprocess_papers(papers: List[Dict]) -> List[Dict]:
    """전체 전처리 파이프라인"""
    papers = filter_empty_abstracts(papers)
    for paper in papers:
        paper["abstract"] = clean_abstract(paper["abstract"])
        paper["full_text"] = f"Title: {paper['title']}\n\nAbstract: {paper['abstract']}"
    return papers
