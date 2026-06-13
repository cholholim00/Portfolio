import streamlit as st
import requests
import uuid

st.title("🤖 AI 챗봇")

# 세션 ID 초기화
if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())
if "messages" not in st.session_state:
    st.session_state.messages = []

with st.sidebar:
    st.header("⚙️ 설정")

    # 모델 선택
    st.subheader("🧠 모델 선택")
    try:
        res = requests.get("http://localhost:8000/models")
        model_list = res.json()["models"]
    except:
        model_list = ["qwen2.5:7b", "mistral:7b", "gemma3:4b", "llama3.2:3b"]

    selected_model = st.selectbox("모델", model_list)
    if st.button("모델 적용"):
        requests.post(
            "http://localhost:8000/model",
            json={"model": selected_model}
        )
        st.success(f"{selected_model} 로 변경됐어요!")

    st.divider()

    # 시스템 프롬프트
    st.subheader("💬 시스템 프롬프트")
    system_input = st.text_area(
        "시스템 프롬프트",
        value="You are a helpful AI assistant powered by Qwen2.5. You MUST always respond in Korean only. Never use any other language including Chinese, English, or Japanese. Even if the user writes in another language, always reply in Korean. If asked about your identity, say you are an AI assistant based on Qwen2.5 model.",
        height=150
    )
    if st.button("적용"):
        requests.post(
            "http://localhost:8000/system",
            json={"prompt": system_input}
        )
        st.success("적용 완료!")

    st.divider()

    # 대화 세션 목록
    st.subheader("📋 대화 목록")
    if st.button("새 대화 시작"):
        st.session_state.session_id = str(uuid.uuid4())
        st.session_state.messages = []
        st.rerun()

    try:
        res = requests.get("http://localhost:8000/sessions")
        sessions = res.json()["sessions"]
        for s in sessions:
            col1, col2 = st.columns([3, 1])
            with col1:
                if st.button(f"💬 {s[:8]}...", key=f"load_{s}"):
                    st.session_state.session_id = s
                    res = requests.get(f"http://localhost:8000/sessions")
                    from database import load_messages
                    st.session_state.messages = load_messages(s)
                    st.rerun()
            with col2:
                if st.button("🗑️", key=f"del_{s}"):
                    requests.delete(
                        "http://localhost:8000/session",
                        json={"session_id": s}
                    )
                    if st.session_state.session_id == s:
                        st.session_state.session_id = str(uuid.uuid4())
                        st.session_state.messages = []
                    st.rerun()
    except:
        pass

# 현재 세션 ID 표시
st.caption(f"현재 세션: {st.session_state.session_id[:8]}...")

# 대화 히스토리 출력
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

# 입력창
if prompt := st.chat_input("메시지를 입력하세요"):
    with st.chat_message("user"):
        st.write(prompt)
    st.session_state.messages.append({"role": "user", "content": prompt})

    with st.chat_message("assistant"):
        response = requests.post(
            "http://localhost:8000/chat",
            json={
                "content": prompt,
                "session_id": st.session_state.session_id
            },
            stream=True
        )
        reply = st.write_stream(response.iter_content(chunk_size=None, decode_unicode=True))

    st.session_state.messages.append({"role": "assistant", "content": reply})

# 초기화 버튼
if st.button("대화 초기화"):
    requests.delete(
        "http://localhost:8000/session",
        json={"session_id": st.session_state.session_id}
    )
    st.session_state.session_id = str(uuid.uuid4())
    st.session_state.messages = []
    st.rerun()