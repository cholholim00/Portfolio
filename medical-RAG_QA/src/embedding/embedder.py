"""
임베딩 모듈
sentence-transformers 기반 (무료, 로컬 실행)
"""
from sentence_transformers import SentenceTransformer
from typing import List
import numpy as np

MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"  # 가볍고 안정적, safetensors 지원


class MedicalEmbedder:
    def __init__(self, model_name: str = MODEL_NAME):
        print(f"임베딩 모델 로드 중: {model_name}")
        self.model = SentenceTransformer(model_name)

    def embed(self, texts: List[str]) -> np.ndarray:
        return self.model.encode(texts, show_progress_bar=True)

    def embed_single(self, text: str) -> List[float]:
        return self.model.encode([text])[0].tolist()