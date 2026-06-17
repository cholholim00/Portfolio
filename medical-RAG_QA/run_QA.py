"""
RAG Q&A 터미널 테스트
Streamlit UI 전에 파이프라인 동작 확인용
"""
import os, sys
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))
from dotenv import load_dotenv
load_dotenv()

from src.embedding.embedder import MedicalEmbedder
from src.retrieval.vector_store import get_chroma_client, get_or_create_collection
from src.generation.rag_chain import MedicalRAGChain


def main():
    print("🏥 Medical RAG Q&A 시스템 로드 중...\n")

    client = get_chroma_client()
    collection = get_or_create_collection(client)

    count = collection.count()
    if count == 0:
        print("❌ 벡터 DB가 비어있어요. 먼저 실행하세요:")
        print("   python main.py --query 'diabetes treatment' --max_papers 50")
        return

    print(f"✅ {count}개 청크 로드됨")
    embedder = MedicalEmbedder()
    chain = MedicalRAGChain(collection, embedder)

    print("\n질문을 입력하세요 (종료: q)\n" + "-" * 50)
    while True:
        question = input("\n❓ 질문: ").strip()
        if question.lower() in ("q", "quit", "exit"):
            print("종료합니다.")
            break
        if not question:
            continue

        print("\n🔍 논문 검색 & 답변 생성 중...")
        result = chain.run(question, top_k=5)

        print("\n📋 답변:")
        print(result["answer"])

        print("\n📚 참고 논문:")
        for i, src in enumerate(result["sources"], 1):
            meta = src["metadata"]
            print(f"  [{i}] {meta['title'][:60]}...")
            print(f"      유사도: {src['score']} | {meta['url']}")


if __name__ == "__main__":
    main()