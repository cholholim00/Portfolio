"""
RAG 파이프라인 통합 모듈
- 한국어 질문 → 영어 번역 → 벡터 검색 → 한국어 답변
"""
from src.embedding.embedder import MedicalEmbedder
from src.retrieval.retriever import retrieve
from src.generation.prompt_templates import RAG_PROMPT, build_context
from src.generation.llm import get_llm_response
from typing import Dict
import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()


def translate_to_english(text: str) -> str:
    """한국어 질문을 영어로 번역 (영어면 그대로 반환)"""
    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{
            "role": "user",
            "content": f"If the following text is in Korean, translate it to English for PubMed search. If it's already in English, return it as-is. Return only the translated text, nothing else.\n\n{text}"
        }],
        max_tokens=200,
        temperature=0,
    )
    return response.choices[0].message.content.strip()


class MedicalRAGChain:
    def __init__(self, collection, embedder: MedicalEmbedder):
        self.collection = collection
        self.embedder = embedder

    def run(self, question: str, top_k: int = 5) -> Dict:
        # 1. 한국어 질문이면 영어로 번역해서 검색
        english_query = translate_to_english(question)
        if english_query != question:
            print(f"   🔄 검색 쿼리 번역: {english_query}")

        # 2. 번역된 쿼리로 임베딩 & 검색
        query_embedding = self.embedder.embed_single(english_query)
        retrieved = retrieve(self.collection, query_embedding, top_k=top_k)

        # 3. 프롬프트 구성 (원래 질문 사용)
        context = build_context(retrieved)
        prompt = RAG_PROMPT.format(context=context, question=question)

        # 4. LLM 한국어 답변 생성
        answer = get_llm_response(prompt)

        return {
            "question": question,
            "english_query": english_query,
            "answer": answer,
            "sources": retrieved,
        }