"""
Streamlit UI - 의료 논문 Q&A 챗봇
"""
import streamlit as st
import os, sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from dotenv import load_dotenv
load_dotenv()

from src.generation.rag_chain import MedicalRAGChain
from src.embedding.embedder import MedicalEmbedder
from src.retrieval.vector_store import get_chroma_client, get_or_create_collection
from streamlit_app.components import (
    render_sidebar,
    render_chat_history,
    render_source_card,
    render_translation_badge,
    render_empty_state,
)

st.set_page_config(page_title="Medical RAG Q&A", page_icon="🏥", layout="wide")


@st.cache_resource
def load_chain():
    client = get_chroma_client()
    collection = get_or_create_collection(client)
    embedder = MedicalEmbedder()
    return MedicalRAGChain(collection, embedder), collection.count()


chain, doc_count = load_chain()

# 사이드바
top_k = render_sidebar(doc_count)

# 메인
st.title("🔬 의료 논문 Q&A")
st.caption("PubMed 논문을 기반으로 의료 질문에 답변합니다. 한국어/영어 모두 가능합니다.")

# 채팅 히스토리 초기화
if "messages" not in st.session_state:
    st.session_state.messages = []

# 첫 방문 안내
if not st.session_state.messages:
    render_empty_state()

# 히스토리 렌더링
render_chat_history(st.session_state.messages)

# 입력창
if question := st.chat_input("질문을 입력하세요 (예: 제2형 당뇨병 치료 방법은?)"):
    st.session_state.messages.append({"role": "user", "content": question})
    with st.chat_message("user"):
        st.markdown(question)

    with st.chat_message("assistant"):
        with st.spinner("논문 검색 & 답변 생성 중..."):
            result = chain.run(question, top_k=top_k)

        render_translation_badge(question, result["english_query"])
        st.markdown(result["answer"])
        render_source_card(result["sources"])

    st.session_state.messages.append({
        "role": "assistant",
        "content": result["answer"],
        "sources": result["sources"],
    })