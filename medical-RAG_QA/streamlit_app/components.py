"""
Streamlit 재사용 컴포넌트
app.py에서 import해서 사용
"""
import streamlit as st
from typing import List, Dict


def render_source_card(sources: List[Dict]):
    """참고 논문 카드 렌더링"""
    with st.expander("📚 참고 논문 보기"):
        for i, src in enumerate(sources, 1):
            meta = src["metadata"]
            st.markdown(f"**[{i}] {meta['title']}**")
            col1, col2 = st.columns([1, 3])
            with col1:
                st.caption(f"유사도: {src['score']}")
                st.caption(f"출판: {meta['year']}")
            with col2:
                st.markdown(f"🔗 [PubMed 원문]({meta['url']})")
            if i < len(sources):
                st.divider()


def render_translation_badge(original: str, translated: str):
    """한국어 번역 쿼리 표시"""
    if original != translated:
        st.caption(f"🔄 검색 쿼리: *{translated}*")


def render_sidebar(doc_count: int) -> int:
    """사이드바 렌더링 → top_k 반환"""
    with st.sidebar:
        st.title("🏥 Medical RAG Q&A")
        st.caption("PubMed 논문 기반 의료 질의응답 시스템")
        st.divider()

        top_k = st.slider("참고 논문 수", min_value=1, max_value=10, value=5)
        st.divider()

        st.markdown("**사용 방법**")
        st.markdown(
            "- 한국어 또는 영어로 질문 입력\n"
            "- 질문은 의료/논문 관련 내용\n"
            "- 답변은 항상 한국어로 제공"
        )
        st.divider()

        st.metric("수집된 청크 수", f"{doc_count:,}개")

        st.divider()
        if st.button("대화 초기화", use_container_width=True):
            st.session_state.messages = []
            st.rerun()

    return top_k


def render_chat_history(messages: List[Dict]):
    """채팅 히스토리 렌더링"""
    for msg in messages:
        with st.chat_message(msg["role"]):
            st.markdown(msg["content"])
            if msg["role"] == "assistant" and "sources" in msg:
                render_source_card(msg["sources"])


def render_empty_state():
    """첫 방문 시 안내 메시지"""
    st.info(
        "👋 안녕하세요! PubMed 논문 기반 의료 Q&A 시스템입니다.\n\n"
        "아래 예시 질문으로 시작해보세요:\n"
        "- 제2형 당뇨병 치료 방법은?\n"
        "- 메트포르민의 부작용은 무엇인가요?\n"
        "- What are the risk factors for cardiovascular disease?"
    )