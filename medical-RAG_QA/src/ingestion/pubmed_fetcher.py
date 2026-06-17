"""
PubMed 논문 수집 모듈
Entrez API를 통해 논문 abstract + 메타데이터 수집
"""
from Bio import Entrez
import time
import json
import os
from typing import List, Dict
from tqdm import tqdm
from dotenv import load_dotenv

load_dotenv()
Entrez.email = os.getenv("ENTREZ_EMAIL", "your_email@example.com")


def search_pubmed(query: str, max_results: int = 100) -> List[str]:
    """키워드로 PubMed 검색 → PMID 리스트 반환"""
    handle = Entrez.esearch(db="pubmed", term=query, retmax=max_results)
    record = Entrez.read(handle)
    handle.close()
    return record["IdList"]


def fetch_paper_details(pmid_list: List[str]) -> List[Dict]:
    """PMID 리스트 → 논문 상세 정보(제목, 초록, 저자, 연도) 반환"""
    papers = []
    for pmid in tqdm(pmid_list, desc="논문 수집 중"):
        try:
            handle = Entrez.efetch(db="pubmed", id=pmid, rettype="abstract", retmode="xml")
            record = Entrez.read(handle)
            handle.close()

            article = record["PubmedArticle"][0]["MedlineCitation"]["Article"]
            paper = {
                "pmid": pmid,
                "title": str(article.get("ArticleTitle", "")),
                "abstract": str(article.get("Abstract", {}).get("AbstractText", [""])[0]),
                "year": str(article.get("Journal", {}).get("JournalIssue", {}).get("PubDate", {}).get("Year", "N/A")),
                "url": f"https://pubmed.ncbi.nlm.nih.gov/{pmid}/",
            }
            papers.append(paper)
            time.sleep(0.34)  # NCBI API rate limit: 3 req/sec
        except Exception as e:
            print(f"[ERROR] PMID {pmid} 수집 실패: {e}")
    return papers


def save_papers(papers: List[Dict], query: str):
    """수집한 논문을 data/raw/ 에 JSON으로 저장"""
    os.makedirs("data/raw", exist_ok=True)
    safe_query = query.replace(" ", "_")[:30]
    path = f"data/raw/{safe_query}.json"
    with open(path, "w", encoding="utf-8") as f:
        json.dump(papers, f, ensure_ascii=False, indent=2)
    print(f"💾 논문 저장: {path} ({len(papers)}개)")


def load_papers(query: str) -> List[Dict]:
    """저장된 논문 JSON 로드 (재수집 없이 재사용)"""
    safe_query = query.replace(" ", "_")[:30]
    path = f"data/raw/{safe_query}.json"
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            papers = json.load(f)
        print(f"📂 캐시 로드: {path} ({len(papers)}개)")
        return papers
    return []