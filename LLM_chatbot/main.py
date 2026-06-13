from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import ollama
import uuid
from database import init_db, save_message, load_messages, get_sessions, delete_session

app = FastAPI()

init_db()

system_prompt = "You are a helpful AI assistant powered by Qwen2.5. You MUST always respond in Korean only. Never use any other language including Chinese, English, or Japanese. Even if the user writes in another language, always reply in Korean. If asked about your identity, say you are an AI assistant based on Qwen2.5 model."
current_model = "qwen2.5:7b"

class Message(BaseModel):
    content: str
    session_id: str

class SystemPrompt(BaseModel):
    prompt: str

class ModelSelect(BaseModel):
    model: str

class SessionDelete(BaseModel):
    session_id: str

@app.get("/models")
def get_models():
    models = ollama.list()
    return {"models": [m.model for m in models.models]}

@app.post("/model")
def set_model(data: ModelSelect):
    global current_model
    current_model = data.model
    return {"status": f"{current_model} 로 변경 완료"}

@app.post("/chat")
def chat(message: Message):
    save_message(message.session_id, "user", message.content)
    
    chat_history = load_messages(message.session_id)
    
    messages_with_system = [
        {"role": "system", "content": system_prompt}
    ] + chat_history

    def generate():
        full_reply = ""
        for chunk in ollama.chat(
            model=current_model,
            messages=messages_with_system,
            stream=True
        ):
            token = chunk["message"]["content"]
            full_reply += token
            yield token
        
        save_message(message.session_id, "assistant", full_reply)

    return StreamingResponse(generate(), media_type="text/plain")

@app.post("/system")
def set_system(data: SystemPrompt):
    global system_prompt
    system_prompt = data.prompt
    return {"status": "시스템 프롬프트 설정 완료"}

@app.get("/sessions")
def get_all_sessions():
    return {"sessions": get_sessions()}

@app.delete("/session")
def delete_session_api(data: SessionDelete):
    delete_session(data.session_id)
    return {"status": "세션 삭제 완료"}