"""
LLM + RAG 체인 테스트
OpenAI API 키 필요
"""
import os, sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dotenv import load_dotenv
load_dotenv()


def test_openai_connection():
    """OpenAI API 연결 테스트"""
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("⚠️  OPENAI_API_KEY 없음 → .env 파일 확인")
        return False
    try:
        from openai import OpenAI
        client = OpenAI(api_key=api_key)
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": "Say 'RAG test OK' only."}],
            max_tokens=10,
        )
        answer = response.choices[0].message.content
        print(f"🤖 OpenAI 연결: ✅ (응답: {answer})")
        return True
    except Exception as e:
        print(f"🤖 OpenAI 연결: ❌ ({e})")
        return False


def test_prompt_template():
    """프롬프트 템플릿 빌드 테스트"""
    try:
        from src.generation.prompt_templates import RAG_PROMPT, build_context

        dummy_chunks = [{
            "text": "Metformin reduces blood glucose.",
            "metadata": {"pmid": "12345", "title": "Diabetes Study", "year": "2023", "url": "https://pubmed.ncbi.nlm.nih.gov/12345/"},
            "score": 0.92,
        }]
        context = build_context(dummy_chunks)
        prompt = RAG_PROMPT.format(context=context, question="What is metformin?")
        assert "Metformin" in prompt
        print("📝 프롬프트 템플릿: ✅")
        return True
    except Exception as e:
        print(f"📝 프롬프트 템플릿: ❌ ({e})")
        return False


if __name__ == "__main__":
    print("🤖 LLM & RAG 테스트\n" + "-" * 35)
    ok1 = test_openai_connection()
    ok2 = test_prompt_template()
    print("\n" + "=" * 35)
    if ok1 and ok2:
        print("✅ 3주차 진행 가능!")
    else:
        print("❌ 위 오류 해결 후 다시 실행하세요")