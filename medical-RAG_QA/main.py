"""
전체 파이프라인 실행 진입점
1. PubMed 논문 수집 (캐시 지원)
2. 전처리 & 청킹
3. 임베딩 & 벡터 DB 저장
"""
import argparse
from src.ingestion.pubmed_fetcher import search_pubmed, fetch_paper_details, save_papers, load_papers
from src.ingestion.preprocessor import preprocess_papers
from src.ingestion.text_chunker import chunk_papers
from src.embedding.embedder import MedicalEmbedder
from src.retrieval.vector_store import get_chroma_client, get_or_create_collection, add_chunks_to_db

def run_pipeline(query: str, max_papers: int = 100, use_cache: bool = True):
    print(f"\n[1/4] PubMed 검색: '{query}'")

    # 캐시 확인
    papers = load_papers(query) if use_cache else []
    if not papers:
        pmids = search_pubmed(query, max_results=max_papers)
        print(f"→ {len(pmids)}개 논문 발견")
        papers = fetch_paper_details(pmids)
        save_papers(papers, query)
    else:
        print(f"→ 캐시에서 로드 완료")

    print("\n[2/4] 전처리")
    papers = preprocess_papers(papers)
    print(f"→ {len(papers)}개 논문 전처리 완료")

    print("\n[3/4] 청킹")
    chunks = chunk_papers(papers)
    print(f"→ {len(chunks)}개 청크 생성")

    print("\n[4/4] 임베딩 & 벡터 DB 저장")
    embedder = MedicalEmbedder()
    texts = [c["text"] for c in chunks]
    embeddings = embedder.embed(texts).tolist()
    client = get_chroma_client()
    collection = get_or_create_collection(client)
    add_chunks_to_db(collection, chunks, embeddings)
    print("\n✅ 파이프라인 완료!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", type=str, default="diabetes treatment")
    parser.add_argument("--max_papers", type=int, default=100)
    parser.add_argument("--no_cache", action="store_true", help="캐시 무시하고 재수집")
    args = parser.parse_args()
    run_pipeline(args.query, args.max_papers, use_cache=not args.no_cache)