"""
임베딩 + 벡터 검색 테스트
"""

def test_embedding():
    """임베딩 모델 로드 & 실행 테스트"""
    try:
        from sentence_transformers import SentenceTransformer
        model = SentenceTransformer("all-MiniLM-L6-v2")
        vec = model.encode(["test medical text"])
        assert vec.shape[1] == 384
        print(f"🧠 임베딩: ✅ (벡터 차원: {vec.shape[1]})")
        return True
    except Exception as e:
        print(f"🧠 임베딩: ❌ ({e})")
        return False


def test_vector_search():
    """ChromaDB 저장 → 검색 end-to-end 테스트"""
    try:
        import chromadb, os
        from sentence_transformers import SentenceTransformer

        model = SentenceTransformer("all-MiniLM-L6-v2")

        docs = [
            "Metformin is used to treat type 2 diabetes.",
            "Aspirin reduces inflammation and fever.",
            "Insulin regulates blood glucose levels.",
        ]
        embeddings = model.encode(docs).tolist()

        test_dir = os.path.join(os.getcwd(), "vectordb_test")
        os.makedirs(test_dir, exist_ok=True)
        client = chromadb.PersistentClient(path=test_dir)
        try:
            client.delete_collection("test_retrieval")
        except:
            pass
        col = client.get_or_create_collection("test_retrieval", metadata={"hnsw:space": "cosine"})
        col.add(documents=docs, embeddings=embeddings, ids=["d1", "d2", "d3"])

        query_vec = model.encode(["diabetes medication"]).tolist()
        result = col.query(query_embeddings=query_vec, n_results=1)
        top_doc = result["documents"][0][0]
        client.delete_collection("test_retrieval")

        print(f"🔍 벡터 검색: ✅")
        print(f"   쿼리: 'diabetes medication'")
        print(f"   결과: '{top_doc[:60]}...'")
        return True
    except Exception as e:
        print(f"🔍 벡터 검색: ❌ ({e})")
        return False


if __name__ == "__main__":
    print("📐 임베딩 & 검색 테스트\n" + "-" * 35)
    ok1 = test_embedding()
    ok2 = test_vector_search()
    print("\n" + "=" * 35)
    if ok1 and ok2:
        print("✅ 2주차 진행 가능!")
    else:
        print("❌ 위 오류 해결 후 다시 실행하세요")