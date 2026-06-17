"""
패키지 설치 확인 + 데이터 수집 테스트
"""
import sys

def test_imports():
    """필수 패키지 임포트 테스트"""
    results = {}

    packages = {
        "biopython": "Bio",
        "langchain": "langchain",
        "sentence-transformers": "sentence_transformers",
        "chromadb": "chromadb",
        "openai": "openai",
        "fastapi": "fastapi",
        "streamlit": "streamlit",
        "python-dotenv": "dotenv",
        "pandas": "pandas",
        "tqdm": "tqdm",
    }

    for name, import_name in packages.items():
        try:
            __import__(import_name)
            results[name] = "✅ OK"
        except ImportError:
            results[name] = "❌ 설치 안 됨"

    print("\n📦 패키지 설치 확인")
    print("-" * 35)
    for pkg, status in results.items():
        print(f"{status}  {pkg}")

    failed = [k for k, v in results.items() if "❌" in v]
    if failed:
        print(f"\n⚠️  미설치 패키지: {', '.join(failed)}")
        print(f"→ pip install {' '.join(failed)}")
    else:
        print("\n🎉 모든 패키지 설치 완료!")

    return len(failed) == 0


def test_pubmed_search():
    """PubMed API 연결 테스트 (이메일 없어도 1회는 됨)"""
    try:
        from Bio import Entrez
        Entrez.email = "test@test.com"
        handle = Entrez.esearch(db="pubmed", term="diabetes", retmax=3)
        record = Entrez.read(handle)
        handle.close()
        count = len(record["IdList"])
        print(f"\n🌐 PubMed API 연결: ✅ (결과 {count}개 확인)")
        return True
    except Exception as e:
        print(f"\n🌐 PubMed API 연결: ❌ ({e})")
        return False


def test_chromadb():
    """ChromaDB 로컬 생성 테스트"""
    try:
        import chromadb, os
        # Windows 임시 폴더 대신 현재 디렉토리에 테스트 DB 생성
        test_dir = os.path.join(os.getcwd(), "vectordb_test")
        os.makedirs(test_dir, exist_ok=True)
        client = chromadb.PersistentClient(path=test_dir)
        col = client.get_or_create_collection("test")
        col.add(documents=["hello world"], ids=["id1"])
        result = col.query(query_texts=["hello"], n_results=1)
        assert len(result["documents"][0]) == 1
        # 테스트 후 컬렉션 삭제
        client.delete_collection("test")
        print("💾 ChromaDB: ✅")
        return True
    except Exception as e:
        print(f"💾 ChromaDB: ❌ ({e})")
        return False


if __name__ == "__main__":
    ok1 = test_imports()
    ok2 = test_pubmed_search()
    ok3 = test_chromadb()

    print("\n" + "=" * 35)
    if ok1 and ok2 and ok3:
        print("✅ 전체 테스트 통과! 1주차 시작 가능")
    else:
        print("❌ 위 오류 해결 후 다시 실행하세요")
