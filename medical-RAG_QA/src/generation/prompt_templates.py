"""
프롬프트 템플릿
- 한국어/영어 질문 모두 지원
- 질문 언어에 맞춰 답변
- 출처 포함 답변 유도
"""

RAG_PROMPT = """
You are a helpful medical research assistant. Use the provided context from PubMed papers to answer the question.

IMPORTANT LANGUAGE RULE:
- Detect the language of the question.
- If the question is in Korean, answer in Korean.
- If the question is in English, answer in English.
- Always translate and summarize the context in the same language as the question.

Guidelines:
- Use the context to answer as thoroughly as possible.
- If the context is partially relevant, use what is available and note any limitations.
- Always end your answer with a "참고 논문" (if Korean) or "References" (if English) section listing the paper titles and PMIDs you used.

Context:
{context}

Question: {question}

Answer:
"""

def build_context(retrieved_chunks: list) -> str:
    context_parts = []
    for i, chunk in enumerate(retrieved_chunks, 1):
        meta = chunk["metadata"]
        context_parts.append(
            f"[{i}] {meta['title']} (PMID: {meta['pmid']}, {meta['year']})\n{chunk['text']}"
        )
    return "\n\n".join(context_parts)