"""
LLM 인터페이스
OpenAI / HuggingFace 전환 가능하도록 추상화
"""
import os
from dotenv import load_dotenv

load_dotenv()

LLM_PROVIDER = os.getenv("LLM_PROVIDER", "openai")  # "openai" or "huggingface"


def get_llm_response(prompt: str) -> str:
    if LLM_PROVIDER == "openai":
        return _openai_response(prompt)
    elif LLM_PROVIDER == "huggingface":
        return _huggingface_response(prompt)
    else:
        raise ValueError(f"지원하지 않는 LLM_PROVIDER: {LLM_PROVIDER}")


def _openai_response(prompt: str) -> str:
    from openai import OpenAI
    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.2,
    )
    return response.choices[0].message.content


def _huggingface_response(prompt: str) -> str:
    # TODO: HuggingFace 모델 연동 시 구현
    raise NotImplementedError("HuggingFace LLM은 추후 구현 예정")
