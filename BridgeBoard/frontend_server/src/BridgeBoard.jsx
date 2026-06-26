import { useState, useEffect, useRef } from "react";

const NAV_ITEMS = [
  { label: "대시보드", icon: "⊞" },
  { label: "회의", icon: "▶" },
  { label: "캘린더", icon: "◫" },
  { label: "파일", icon: "⊟" },
];

const EMOTION_EMOJI = {
  기쁨: "😊", 슬픔: "😢", 분노: "😠", 
  불안: "😰", 당황: "😳", 상처: "💔"
};

export default function BridgeBoard() {
  // 🔐 로그인 상태 관리
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [loginInput, setLoginInput] = useState("");
  const [userId, setUserId] = useState("");
  const userIdRef = useRef(""); 

  const [msgs, setMsgs]           = useState([]);       
  const [keywords, setKeywords]   = useState([]);       
  const [sentiment, setSentiment] = useState(null);     
  const [emotion, setEmotion]     = useState(null);     
  const [micOn, setMicOn]         = useState(true);
  const [camOn, setCamOn]         = useState(true);
  const [activeNav, setActiveNav] = useState(0); 
  const [connected, setConnected] = useState(false);    
  const [inputText, setInputText] = useState("");
  const [isSttOn, setIsSttOn]     = useState(false); 
  const [isTtsOn, setIsTtsOn]     = useState(false); 
  
  const [a11yMode, setA11yMode] = useState('none'); 

  const localVideoRef = useRef(null);
  const remoteVideoRef = useRef(null);
  const peerConnection = useRef(null);
  const localStream = useRef(null);
  const iceCandidatesQueue = useRef([]);
  const chatRef = useRef(null);
  const ws = useRef(null);
  
  const recognitionRef = useRef(null); 
  const isSttOnRef = useRef(false);    
  const isTtsOnRef = useRef(false);    
  const lastProcessedText = useRef("");

  // 🚨 ngrok 터널링 주소를 입력하는 곳입니다. (http:// 나 https:// 는 빼고 적어주세요!)
  const NGROK_URL = "hadlee-isocyano-photomechanically.ngrok-free.dev";

  const rtcConfig = {
    iceServers: [
      { urls: "stun:stun.l.google.com:19302" },
      { urls: "stun:stun1.l.google.com:19302" },
      { urls: "stun:stun2.l.google.com:19302" }
    ],
    iceTransportPolicy: "all"
  };

  useEffect(() => {
    if (chatRef.current) chatRef.current.scrollTop = chatRef.current.scrollHeight;
  }, [msgs]);

  const handleLogin = (e) => {
    e.preventDefault();
    if (!loginInput.trim()) return alert("사용자 ID를 입력해주세요.");
    setUserId(loginInput.trim());
    userIdRef.current = loginInput.trim();
    setIsLoggedIn(true);
  };

  // 🎙️ 0. STT 음성 인식 엔진
  useEffect(() => {
    if (!isLoggedIn) return;
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (SpeechRecognition) {
      const recognition = new SpeechRecognition();
      recognition.continuous = true;     
      recognition.interimResults = false;
      recognition.lang = "ko-KR";        

      recognition.onresult = (event) => {
        const transcript = event.results[event.results.length - 1][0].transcript;
        if (transcript.trim() && ws.current && ws.current.readyState === 1) {
          ws.current.send(JSON.stringify({ text: transcript.trim(), user: userIdRef.current }));
        }
      };

      recognition.onend = () => {
        if (isSttOnRef.current) {
          try { recognition.start(); } catch (e) {}
        }
      };
      recognitionRef.current = recognition;
    }
  }, [isLoggedIn]);

  // 🎥 1. 로컬 미디어 캡처
  useEffect(() => {
    if (!isLoggedIn) return;
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) return;
    navigator.mediaDevices.getUserMedia({ video: true, audio: true })
      .then((stream) => {
        localStream.current = stream;
        if (localVideoRef.current) localVideoRef.current.srcObject = stream;
        initWebRTC();
      })
      .catch((err) => {  
      console.error("🚨 카메라/마이크 접근 실패 원인:", err); 
      setCamOn(false);
      navigator.mediaDevices.getUserMedia({ video: false, audio: true })
        .then((audioStream) => {
          localStream.current = audioStream;
          initWebRTC();
        })
        .catch((err2) => { 
          console.error("🚨 오디오 전용 접근 실패 원인:", err2); 
          peerConnection.current = new RTCPeerConnection(rtcConfig); 
        });
    });

    return () => {
      localStream.current?.getTracks().forEach(track => track.stop());
      peerConnection.current?.close();
      ws.current?.close();
      if (recognitionRef.current) recognitionRef.current.stop();
      window.speechSynthesis.cancel();
    };
  }, [isLoggedIn]);

  // 📡 2. 실시간 웹소켓 세션
  useEffect(() => {
    if (!isLoggedIn) return;
    const connectWebSocket = () => {
      // 🚨 외부망 접속을 위해 보안 웹소켓(wss://)과 ngrok 주소를 사용합니다.
      ws.current = new WebSocket(`wss://${NGROK_URL}/ws/analyze`);
      ws.current.onopen = () => setConnected(true);

      ws.current.onmessage = async (event) => {
        try {
          const data = JSON.parse(event.data);

          if ((data.sdp || data.candidate) && data.sender === userIdRef.current) return;

          if (data.sdp) {
            if (data.sdp.type === 'offer') {
              await peerConnection.current.setRemoteDescription(new RTCSessionDescription(data.sdp));
              const answer = await peerConnection.current.createAnswer();
              await peerConnection.current.setLocalDescription(answer);
              sendMessage(JSON.stringify({ sdp: answer, sender: userIdRef.current }));
              processBufferedCandidates();
            } else if (data.sdp.type === 'answer') {
              await peerConnection.current.setRemoteDescription(new RTCSessionDescription(data.sdp));
              processBufferedCandidates();
            }
            return;
          } 
          
          if (data.candidate) {
            const candidateObj = new RTCIceCandidate(data.candidate);
            if (peerConnection.current && peerConnection.current.remoteDescription) {
              await peerConnection.current.addIceCandidate(candidateObj);
            } else {
              iceCandidatesQueue.current.push(candidateObj);
            }
            return;
          }

          if (data.text) {
            if (lastProcessedText.current === data.text) return;
            lastProcessedText.current = data.text;
            setTimeout(() => { lastProcessedText.current = ""; }, 1000);
            
            const now = new Date();
            const finalTime = data.timestamp || `${now.getHours()}:${String(now.getMinutes()).padStart(2, "0")}`;

           if (isTtsOnRef.current) {
              window.speechSynthesis.cancel();
              const utterance = new SpeechSynthesisUtterance(data.text);
              utterance.lang = 'ko-KR';
              utterance.rate = 1.0;
              window.speechSynthesis.speak(utterance);
            }

            setMsgs(prev => [...prev, {
              user: data.user, time: finalTime, text: data.text,
              label: data.label, emoji: data.emoji || EMOTION_EMOJI[data.label] || "😶",
              confidence: data.confidence, hi: data.highlight || data.confidence > 80,
            }]);

            setEmotion({ label: data.label, emoji: data.emoji || EMOTION_EMOJI[data.label] || "😶", score: Math.round(data.confidence) });
            setSentiment(data.sentiment_score);

            // 💡 [동적 키워드 추출] 2글자 이상의 의미 있는 단어만 실시간으로 추출
            const extractedWords = data.text
              .split(/\s+/)
              .filter(word => word.length >= 2)
              .map(word => word.replace(/[.,!?]/g, ''));

            if (extractedWords.length > 0) {
              setKeywords(prev => {
                const newKeywords = [...new Set([...extractedWords, ...prev])];
                return newKeywords.slice(0, 10); 
              });
            }
          }
        } catch (e) { }
      };
      ws.current.onerror = () => setConnected(false);
      ws.current.onclose = () => { setConnected(false); setTimeout(connectWebSocket, 3000); };
    };
    connectWebSocket();
  }, [isLoggedIn]);

  const processBufferedCandidates = async () => {
    while (iceCandidatesQueue.current.length > 0) {
      const candidate = iceCandidatesQueue.current.shift();
      try { await peerConnection.current.addIceCandidate(candidate); } catch (e) {}
    }
  };

  const initWebRTC = () => {
    peerConnection.current = new RTCPeerConnection(rtcConfig);
    if (localStream.current) localStream.current.getTracks().forEach(track => peerConnection.current.addTrack(track, localStream.current));
    peerConnection.current.ontrack = (event) => {
      if (remoteVideoRef.current && event.streams[0]) remoteVideoRef.current.srcObject = event.streams[0];
    };
    peerConnection.current.onicecandidate = (event) => {
      if (event.candidate && ws.current && ws.current.readyState === WebSocket.OPEN) {
        sendMessage(JSON.stringify({ candidate: event.candidate, sender: userIdRef.current }));
      }
    };
  };

  const handleCallConnect = async () => {
    if (peerConnection.current) {
      try {
        const offer = await peerConnection.current.createOffer();
        await peerConnection.current.setLocalDescription(offer);
        sendMessage(JSON.stringify({ sdp: offer, sender: userIdRef.current }));
      } catch (err) { }
    }
  };

  const sendMessage = (text, customUserId = userIdRef.current) => {
    if (!text.trim() || !ws.current || ws.current.readyState !== WebSocket.OPEN) return;
    if (typeof text === 'string' && (text.includes('"sdp"') || text.includes('"candidate"'))) {
      try { ws.current.send(text); return; } catch (e) {}
    }
    ws.current.send(JSON.stringify({ text: text.trim(), user: customUserId }));
  };

  const handleSend = () => {
    if (!inputText.trim()) return;
    sendMessage(inputText);
    setInputText("");
  };

  const toggleStt = () => {
    if (!recognitionRef.current) return;
    if (isSttOnRef.current) { isSttOnRef.current = false; setIsSttOn(false); recognitionRef.current.stop(); }
    else { isSttOnRef.current = true; setIsSttOn(true); try { recognitionRef.current.start(); } catch (e) {} }
  };

  // 🎤 [누르고 말하기 전용 STT 제어 함수]
  const startPttRecording = () => {
    if (!recognitionRef.current) return;
    isSttOnRef.current = true; 
    setIsSttOn(true); 
    try { recognitionRef.current.start(); } catch (e) {}
  };

  const stopPttRecording = () => {
    if (!recognitionRef.current) return;
    isSttOnRef.current = false; 
    setIsSttOn(false); 
    try { recognitionRef.current.stop(); } catch (e) {}
  };

  const toggleTts = () => {
    if (isTtsOnRef.current) { isTtsOnRef.current = false; setIsTtsOn(false); window.speechSynthesis.cancel(); }
    else {
      isTtsOnRef.current = true; setIsTtsOn(true);
      const u = new SpeechSynthesisUtterance("맞춤형 감정 음성 안내 기능이 활성화되었습니다.");
      u.lang = 'ko-KR'; window.speechSynthesis.speak(u);
    }
  };

  const toggleCamera = () => {
    if (localStream.current) {
      const videoTrack = localStream.current.getVideoTracks()[0];
      if (videoTrack) { videoTrack.enabled = !videoTrack.enabled; setCamOn(videoTrack.enabled); }
    }
  };

  const startCustomMeeting = (mode) => {
    setA11yMode(mode);
    setActiveNav(1); 
    if (mode === 'visual' && !isTtsOnRef.current) toggleTts();
    if (mode === 'hearing' && !isSttOnRef.current) toggleStt();
  };

  const handleResetSession = () => {
    if (window.confirm("현재까지 축적된 모든 AI 감정 분석 로그와 차트 데이터를 초기화하시겠습니까?")) {
      setMsgs([]); setKeywords([]); setEmotion(null); setSentiment(null); lastProcessedText.current = ""; 
    }
  };

  const downloadFile = (content, fileName, mimeType) => {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = fileName;
    a.click();
    URL.revokeObjectURL(url);
  };

  const exportLogCSV = () => {
    if (msgs.length === 0) return alert("추출할 대화 데이터가 없습니다.");
    let csv = "\uFEFF발생시간,화자,발화내용,감정,신뢰도(%)\n";
    msgs.forEach(m => { csv += `${m.time},${m.user},"${m.text}",${m.label},${m.confidence}\n`; });
    downloadFile(csv, `${userId}_감정_로그_보고서.csv`, "text/csv;charset=utf-8;");
  };

  const exportKeywordsCSV = () => {
    if (keywords.length === 0) return alert("추출할 키워드가 없습니다.");
    let csv = "\uFEFF순번,실시간_추출_키워드\n";
    keywords.forEach((kw, idx) => { csv += `${idx + 1},${kw}\n`; });
    downloadFile(csv, `${userId}_실시간_키워드_추출.csv`, "text/csv;charset=utf-8;");
  };

  const exportTranscriptMD = () => {
    if (msgs.length === 0) return alert("추출할 대화록이 없습니다.");
    let md = `# 🌉 BridgeBoard 배리어프리 시연 대화록\n\n**기록자 ID:** ${userId}\n**추출 일시:** ${new Date().toLocaleString()}\n\n---\n\n`;
    msgs.forEach(m => { md += `**[${m.time}] ${m.user}** ${m.emoji} \`${m.label}\`\n> ${m.text}\n\n`; });
    downloadFile(md, `${userId}_대화록_추출.md`, "text/markdown;charset=utf-8;");
  };

  const emotionColor = !emotion ? "#8B90A8" : emotion.label === "기쁨" ? "#3DD68C" : emotion.label === "당황" ? "#F7C948" : emotion.label === "분노" ? "#EF4444" : emotion.label === "슬픔" ? "#4F8EF7" : "#8B90A8";
  const isExtremeEmotion = emotion && (emotion.label === "분노" || emotion.label === "불안");

  if (!isLoggedIn) {
    return (
      <div style={{ background: "#0C0E14", color: "#FFF", height: "100vh", display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'Pretendard', sans-serif" }}>
        <div style={{ background: "#141822", padding: 40, borderRadius: 24, border: "1px solid rgba(255,255,255,0.1)", width: 400, boxShadow: "0 20px 40px rgba(0,0,0,0.5)" }}>
          <div style={{ width: 48, height: 48, background: "linear-gradient(135deg,#4F8EF7,#7B5EFB)", borderRadius: 12, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 24, marginBottom: 20 }}>🌉</div>
          <h1 style={{ margin: "0 0 8px 0", fontSize: 24 }}>BridgeBoard 접속</h1>
          <p style={{ color: "#8B90A8", margin: "0 0 32px 0", fontSize: 14 }}>시·청각 장애인을 위한 배리어프리 플랫폼</p>
          
          <form onSubmit={handleLogin} style={{ display: "flex", flexDirection: "column", gap: 16 }}>
            <div>
              <label style={{ display: "block", fontSize: 12, fontWeight: 700, color: "#6B7090", marginBottom: 8 }}>사용자 ID (식별자)</label>
              <input autoFocus value={loginInput} onChange={(e) => setLoginInput(e.target.value)} placeholder="예: Doctor_A, Patient_01" style={{ width: "100%", padding: "14px 16px", background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.1)", borderRadius: 12, color: "#FFF", fontSize: 15, boxSizing: "border-box", outline: "none" }} />
            </div>
            <button type="submit" style={{ width: "100%", padding: 16, background: "linear-gradient(135deg,#4F8EF7,#2F6ED7)", color: "#FFF", border: "none", borderRadius: 12, fontSize: 15, fontWeight: 700, cursor: "pointer", marginTop: 8 }}>세션 시작하기</button>
          </form>
        </div>
      </div>
    );
  }

  const renderTabContent = () => {
    switch (activeNav) {
      case 0:
        return (
          <div style={{ display: "flex", flexDirection: "column", gap: 24, height: "100%", overflowY: "auto", paddingRight: 4 }}>
            <div style={{ background: "rgba(79,142,247,0.05)", border: "1px solid rgba(79,142,247,0.2)", borderRadius: 20, padding: 24 }}>
              <h2 style={{ fontSize: 18, color: "#FFF", margin: "0 0 16px 0" }}>🤝 배리어프리 맞춤형 회의 시작</h2>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
                <button onClick={() => startCustomMeeting('visual')} style={{ background: "linear-gradient(135deg, #1A1D27, #242838)", border: "2px solid #F7C948", borderRadius: 16, padding: "24px 16px", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 12 }}>
                  <span style={{ fontSize: 32 }}>👁️</span>
                  <span style={{ fontSize: 16, fontWeight: 700, color: "#F7C948" }}>시각장애인 맞춤 모드</span>
                  <span style={{ fontSize: 12, color: "#A0A5B5", textAlign: "center" }}>음성 브리핑(TTS) 자동 켜기<br/>고대비 레이아웃 적용</span>
                </button>
                <button onClick={() => startCustomMeeting('hearing')} style={{ background: "linear-gradient(135deg, #1A1D27, #242838)", border: "2px solid #3DD68C", borderRadius: 16, padding: "24px 16px", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 12 }}>
                  <span style={{ fontSize: 32 }}>👂</span>
                  <span style={{ fontSize: 16, fontWeight: 700, color: "#3DD68C" }}>청각장애인 맞춤 모드</span>
                  <span style={{ fontSize: 12, color: "#A0A5B5", textAlign: "center" }}>실시간 자막(STT) 자동 켜기<br/>시각적 감정 햅틱 극대화</span>
                </button>
              </div>
            </div>

            <div style={{ gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", display: "grid", gap: 12 }}>
              <div style={{ background: "#141822", borderRadius: 16, padding: 16, border: "1px solid rgba(255,255,255,0.05)" }}>
                <span style={{ fontSize: 11, color: "#6B7090" }}>총 누적 발화수</span>
                <h3 style={{ fontSize: 24, margin: "4px 0 0 0", color: "#FFF", fontWeight: 800 }}>{msgs.length} <span style={{ fontSize: 13, fontWeight: 400, color: "#4A4F68" }}>문장</span></h3>
              </div>
              <div style={{ background: "#141822", borderRadius: 16, padding: 16, border: "1px solid rgba(255,255,255,0.05)" }}>
                <span style={{ fontSize: 11, color: "#6B7090" }}>AI 베이스라인 정확도</span>
                <h3 style={{ fontSize: 24, margin: "4px 0 0 0", color: "#3DD68C", fontWeight: 800 }}>70.58%</h3>
              </div>
            </div>
            
            <div style={{ background: "#141822", borderRadius: 16, padding: 20, flex: 1, border: "1px solid rgba(255,255,255,0.05)" }}>
              <span style={{ fontSize: 12, fontWeight: 700, color: "#8B90A8", display: "block", marginBottom: 16 }}>📊 EMOTION DENSITY RATIO (감정 밀도 비율)</span>
              {["기쁨", "슬픔", "분노", "불안", "당황", "상처"].map((emo) => {
                const count = msgs.filter(m => m.label === emo).length;
                const ratio = msgs.length ? Math.round((count / msgs.length) * 100) : 0;
                return (
                  <div key={emo} style={{ marginBottom: 12 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", fontSize: 12, marginBottom: 4 }}>
                      <span>{emo}</span><span style={{ fontWeight: 700 }}>{ratio}% ({count}회)</span>
                    </div>
                    <div style={{ height: 6, background: "rgba(255,255,255,0.04)", borderRadius: 3, overflow: "hidden" }}>
                      <div style={{ width: `${ratio}%`, height: "100%", background: emo === "기쁨" ? "#3DD68C" : emo === "슬픔" ? "#4F8EF7" : emo === "분노" ? "#EF4444" : "#7B5EFB", transition: "width 0.5s ease" }}/>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        );

      case 1:
        if (a11yMode === 'visual') {
          return (
            <div style={{ flex: 1, display: "flex", flexDirection: "column", height: "100%", gap: 16, background: "#000", padding: 20 }}>
              <div style={{ background: "#FFFF00", color: "#000", padding: 16, borderRadius: 12, fontWeight: 800, fontSize: 18, textAlign: "center" }}>시각장애인 맞춤형 회의 모드</div>
              <div style={{ flex: 1, display: "flex", gap: 16 }}>
                <button onClick={handleCallConnect} style={{ flex: 1, background: "#000", border: "4px solid #FFFF00", color: "#FFFF00", borderRadius: 20, fontSize: 32, fontWeight: 800, cursor: "pointer" }}>📞 영상 통화 시작</button>
                <button onClick={toggleTts} style={{ flex: 1, background: isTtsOn ? "#FFFF00" : "#333", color: isTtsOn ? "#000" : "#FFF", border: `4px solid ${isTtsOn ? "#FFFF00" : "#555"}`, borderRadius: 20, fontSize: 28, fontWeight: 800, cursor: "pointer" }}>{isTtsOn ? "🔊 음성 안내 (켜짐)" : "🔈 음성 안내 (꺼짐)"}</button>
              </div>
              <div style={{ display: "flex", gap: 10, justifyContent: "flex-end" }}>
                <video ref={remoteVideoRef} autoPlay playsInline style={{ width: 100, height: 75, background: "#222", border: "2px solid #555" }} />
                <video ref={localVideoRef} autoPlay playsInline muted style={{ width: 100, height: 75, background: "#222", border: "2px solid #555" }} />
              </div>
            </div>
          );
        }

        // 🚨 청각장애인 모드 레이아웃 픽스 적용 완료
        if (a11yMode === 'hearing') {
          return (
            <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 12, minHeight: 0 }}>
              <div className={isExtremeEmotion ? "pulse-animation" : ""} style={{ flex: 1, background: "#000", borderRadius: 20, border: `4px solid ${emotionColor}`, position: "relative", overflow: "hidden", boxShadow: `0 0 30px ${emotionColor}50`, minHeight: 0 }}>
                <video ref={remoteVideoRef} autoPlay playsInline style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                <video ref={localVideoRef} autoPlay playsInline muted style={{ position: "absolute", top: 20, right: 20, width: 160, height: 120, borderRadius: 12, border: "2px solid #FFF", objectFit: "cover", zIndex: 30 }} />
                {emotion && (
                  <div style={{ position: "absolute", top: 20, left: 20, background: "rgba(0,0,0,0.85)", borderRadius: 16, padding: "12px 24px", display: "flex", alignItems: "center", gap: 12, border: `2px solid ${emotionColor}`, zIndex: 20 }}>
                    <span style={{ fontSize: 32 }}>{emotion.emoji}</span><span style={{ fontSize: 28, color: emotionColor, fontWeight: 800 }}>{emotion.label} {emotion.score}%</span>
                  </div>
                )}
              </div>
              <div style={{ height: 120, flexShrink: 0, background: "#11141E", borderRadius: 16, border: "2px solid rgba(255,255,255,0.1)", padding: 20, display: "flex", alignItems: "center", justifyContent: "center", overflowY: "auto" }}>
                {msgs.length > 0 ? (
                  <p style={{ fontSize: (msgs[msgs.length-1].label === "분노" || msgs[msgs.length-1].label === "불안") ? 28 : 22, fontWeight: (msgs[msgs.length-1].label === "분노" || msgs[msgs.length-1].label === "불안") ? 800 : 500, color: (msgs[msgs.length-1].label === "분노" || msgs[msgs.length-1].label === "불안") ? "#FFF" : "#3DD68C", margin: 0, textAlign: "center", width: "100%", wordBreak: "keep-all" }}>{msgs[msgs.length-1].text}</p>
                ) : <span style={{ color: "#555", fontSize: 16 }}>상대방의 음성이 감지되면 이곳에 실시간 자막이 표시됩니다.</span>}
              </div>
              <div style={{ display: "flex", gap: 10, flexShrink: 0 }}>
                <button onClick={handleCallConnect} style={{ flex: 1, background: "linear-gradient(135deg,#4F8EF7,#2F6ED7)", color: "#fff", border: "none", borderRadius: 12, padding: "16px", fontWeight: 800, fontSize: 16, cursor: "pointer" }}>📞 영상 연결</button>
                <button onClick={toggleStt} style={{ flex: 1, background: isSttOn ? "#3DD68C" : "rgba(255,255,255,0.05)", color: isSttOn ? "#000" : "#fff", border: "1px solid rgba(255,255,255,0.1)", borderRadius: 12, padding: "16px", fontWeight: 800, fontSize: 16, cursor: "pointer" }}>{isSttOn ? "💬 실시간 자막 (켜짐)" : "📝 자동 자막 켜기"}</button>
              </div>
            </div>
          );
        }

        return (
          <div style={{ flex: 1, display: "flex", flexDirection: "column", height: "100%", gap: 12 }}>
            <div style={{ background: "#222", padding: 10, borderRadius: 8, color: "#A0A5B5", fontSize: 12, textAlign: "center" }}>일반 통합 뷰 모드입니다. 대시보드에서 장애인 맞춤 모드를 선택해보세요.</div>
            <div className={isExtremeEmotion ? "pulse-animation" : ""} style={{ flex: 1, background: "#11141E", borderRadius: 20, border: `3px solid ${emotionColor}`, position: "relative", overflow: "hidden" }}>
              <video ref={remoteVideoRef} autoPlay playsInline style={{ width: "100%", height: "100%", objectFit: "cover" }} />
              <div style={{ position: "absolute", bottom: 20, right: 20, width: 140, height: 105, borderRadius: 12, overflow: "hidden", background: "#000", zIndex: 30 }}><video ref={localVideoRef} autoPlay playsInline muted style={{ width: "100%", height: "100%", objectFit: "cover" }} /></div>
            </div>
            <div style={{ display: "flex", gap: 10 }}>
              <button onClick={handleCallConnect} style={{ background: "#4F8EF7", color: "#fff", border: "none", borderRadius: 12, padding: "12px 24px", cursor: "pointer" }}>📞 영상 연결</button>
              <button onClick={toggleStt} style={{ background: isSttOn ? "#3DD68C" : "#333", color: "#fff", border: "none", borderRadius: 12, padding: "12px 24px", cursor: "pointer" }}>{isSttOn ? "💬 자막 ON" : "📝 자막 OFF"}</button>
              <button onClick={toggleTts} style={{ background: isTtsOn ? "#F7C948" : "#333", color: "#fff", border: "none", borderRadius: 12, padding: "12px 24px", cursor: "pointer" }}>{isTtsOn ? "🔊 듣기 ON" : "🔈 듣기 OFF"}</button>
            </div>
          </div>
        );

      case 2:
        const today = new Date().getDate(); 
        return (
          <div style={{ background: "#141822", borderRadius: 20, padding: 24, height: "100%", border: "1px solid rgba(255,255,255,0.05)", display: "flex", flexDirection: "column" }}>
            <span style={{ fontSize: 16, fontWeight: 800, color: "#FFF", display: "block" }}>🗓️ 배리어프리 감정 캘린더 ({userId})</span>
            <p style={{ fontSize: 12, color: "#6B7090", margin: "4px 0 16px 0" }}>현재 세션에서 도출된 주된 감정이 오늘 날짜에 자동 기록됩니다.</p>
            <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 8, flex: 1 }}>
              {["일", "월", "화", "수", "목", "금", "토"].map(d => (
                <div key={d} style={{ fontSize: 12, fontWeight: 700, color: "#8B90A8", textAlign: "center", paddingBottom: 8 }}>{d}</div>
              ))}
              {Array.from({ length: 31 }).map((_, idx) => {
                const dayNum = idx + 1;
                const isToday = dayNum === today; 
                return (
                  <div key={idx} style={{ background: isToday ? "rgba(79,142,247,0.12)" : "rgba(255,255,255,0.02)", border: `1px solid ${isToday ? "#4F8EF7" : "rgba(255,255,255,0.04)"}`, borderRadius: 12, padding: 10, display: "flex", flexDirection: "column", justifyContent: "space-between", minHeight: 70, transition: "all 0.3s" }}>
                    <span style={{ fontSize: 12, fontWeight: 800, color: isToday ? "#4F8EF7" : "#4A4F68" }}>{dayNum}</span>
                    {isToday && emotion && (<div style={{ fontSize: 24, textAlign: "center", animation: "popIn 0.3s ease" }}>{emotion.emoji}</div>)}
                  </div>
                );
              })}
            </div>
          </div>
        );

      case 3:
        return (
          <div style={{ background: "#141822", borderRadius: 20, padding: 24, height: "100%", border: "1px solid rgba(255,255,255,0.05)", display: "flex", flexDirection: "column", gap: 16 }}>
            <div>
              <span style={{ fontSize: 16, fontWeight: 800, display: "block", color: "#FFF" }}>📥 AI 대화 요약서 및 감정 리포트 추출</span>
              <p style={{ fontSize: 12, color: "#6B7090", margin: "4px 0 0 0" }}>접속자({userId})의 세션에서 도출된 자막 로그와 분석 보고서를 내보냅니다.</p>
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 12, marginTop: 10 }}>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: 16, background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.04)", borderRadius: 12 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
                  <span style={{ fontSize: 24 }}>📊</span>
                  <div>
                    <span style={{ fontSize: 14, fontWeight: 700, display: "block", color: "#E2E4F0" }}>{userId}_감정_로그_보고서.csv</span>
                    <span style={{ fontSize: 11, color: "#6B7090" }}>엑셀 데이터 (CSV) • 전체 감정 추이 및 신뢰도 값 포함</span>
                  </div>
                </div>
                <button onClick={exportLogCSV} style={{ background: "#4F8EF7", border: "none", color: "#FFF", borderRadius: 8, fontSize: 12, fontWeight: 700, padding: "8px 16px", cursor: "pointer", transition: "background 0.2s" }}>다운로드</button>
              </div>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: 16, background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.04)", borderRadius: 12 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
                  <span style={{ fontSize: 24 }}>🔑</span>
                  <div>
                    <span style={{ fontSize: 14, fontWeight: 700, display: "block", color: "#E2E4F0" }}>{userId}_실시간_키워드_추출.csv</span>
                    <span style={{ fontSize: 11, color: "#6B7090" }}>엑셀 데이터 (CSV) • 대화 내 주요 키워드 추출 세트</span>
                  </div>
                </div>
                <button onClick={exportKeywordsCSV} style={{ background: "#4F8EF7", border: "none", color: "#FFF", borderRadius: 8, fontSize: 12, fontWeight: 700, padding: "8px 16px", cursor: "pointer", transition: "background 0.2s" }}>다운로드</button>
              </div>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: 16, background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.04)", borderRadius: 12 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
                  <span style={{ fontSize: 24 }}>📝</span>
                  <div>
                    <span style={{ fontSize: 14, fontWeight: 700, display: "block", color: "#E2E4F0" }}>{userId}_대화록_추출.md</span>
                    <span style={{ fontSize: 11, color: "#6B7090" }}>마크다운 원문 (MD) • 시간대별 대화 스크립트 및 이모지</span>
                  </div>
                </div>
                <button onClick={exportTranscriptMD} style={{ background: "#4F8EF7", border: "none", color: "#FFF", borderRadius: 8, fontSize: 12, fontWeight: 700, padding: "8px 16px", cursor: "pointer", transition: "background 0.2s" }}>다운로드</button>
              </div>
            </div>
          </div>
        );
      default: return null;
    }
  };

  return (
    <div style={{ fontFamily: "'Pretendard', sans-serif", background: "#0C0E14", color: "#E2E4F0", height: "100vh", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <style>{`
        @keyframes pulse-danger { 0% { box-shadow: 0 0 20px rgba(239,68,68,0.4); } 50% { box-shadow: 0 0 50px rgba(239,68,68,0.8); } 100% { box-shadow: 0 0 20px rgba(239,68,68,0.4); } }
        .pulse-animation { animation: pulse-danger 1.5s infinite ease-in-out; }
      `}</style>
      
      <header style={{ background: "rgba(18,20,28,0.95)", borderBottom: "1px solid rgba(255,255,255,0.07)", display: "flex", alignItems: "center", padding: "0 20px", height: 52, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, marginRight: 28 }}><div style={{ width: 28, height: 28, background: "linear-gradient(135deg,#4F8EF7,#7B5EFB)", borderRadius: 7, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14 }}>🌉</div><span style={{ fontSize: 15, fontWeight: 700, color: "#FFF" }}>BridgeBoard Barrier-Free</span></div>
        <nav style={{ display: "flex", gap: 2, flex: 1 }}>
          {NAV_ITEMS.map((item, i) => (
            <button key={i} onClick={() => setActiveNav(i)} style={{ background: activeNav === i ? "rgba(79,142,247,0.15)" : "transparent", border: "none", borderRadius: 8, color: activeNav === i ? "#4F8EF7" : "#8B90A8", cursor: "pointer", display: "flex", alignItems: "center", gap: 6, fontSize: 13, fontWeight: activeNav === i ? 600 : 400, padding: "6px 12px" }}>{item.icon} {item.label}</button>
          ))}
        </nav>
        <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 5, background: connected ? "rgba(61,214,140,0.1)" : "rgba(239,68,68,0.1)", border: `1px solid ${connected ? "rgba(61,214,140,0.3)" : "rgba(239,68,68,0.3)"}`, borderRadius: 20, padding: "3px 10px", fontSize: 11, color: connected ? "#3DD68C" : "#EF4444" }}>
            <div style={{ width: 5, height: 5, borderRadius: "50%", background: connected ? "#3DD68C" : "#EF4444" }}/>{connected ? "AI 인프라 실시간 결합됨" : "서버 오프라인"}
          </div>
          <div style={{ width: 30, height: 30, borderRadius: "50%", background: "linear-gradient(135deg,#4F8EF7,#7B5EFB)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14, fontWeight: 800 }}>
            {userId.charAt(0).toUpperCase()}
          </div>
        </div>
      </header>

      <div style={{ display: "flex", flex: 1, overflow: "hidden" }}>
        <div style={{ flex: 1, display: "flex", flexDirection: "column", padding: "16px", gap: 12, overflow: "hidden" }}>
          {renderTabContent()}

          <div style={{ display: "flex", gap: 8, padding: "8px 12px", background: "rgba(255,255,255,0.03)", borderRadius: 10, border: "1px solid rgba(255,255,255,0.06)", flexShrink: 0 }}>
            <input value={inputText} onChange={e => setInputText(e.target.value)} 
              onKeyDown={e => {
                if (e.nativeEvent.isComposing) return;
                if (e.key === "Enter") handleSend();
              }} 
              placeholder="텍스트를 직접 입력하거나 우측의 마이크 버튼을 누르고 말씀하세요..." style={{ flex: 1, background: "transparent", border: "none", outline: "none", color: "#E2E4F0", fontSize: 13 }} />
            
            <button onClick={handleSend} style={{ background: "#4F8EF7", border: "none", borderRadius: 7, color: "#fff", fontSize: 12, fontWeight: 600, padding: "6px 14px", cursor: "pointer" }}>전송</button>
            
            {/* 🎤 PTT (누르고 말하기) 버튼 */}
            <button 
              onMouseDown={startPttRecording}
              onMouseUp={stopPttRecording}
              onMouseLeave={stopPttRecording}
              onTouchStart={startPttRecording}
              onTouchEnd={stopPttRecording}
              style={{ 
                background: isSttOn ? "#EF4444" : "#3DD68C", 
                border: "none", 
                borderRadius: 7, 
                color: "#fff", 
                fontSize: 12, 
                fontWeight: 600, 
                padding: "6px 14px", 
                cursor: "pointer",
                transition: "all 0.2s ease",
                boxShadow: isSttOn ? "0 0 10px rgba(239,68,68,0.5)" : "none"
              }}
            >
              {isSttOn ? "🎙️ 듣는 중..." : "🎤 누르고 말하기"}
            </button>
          </div>
        </div>

        <div style={{ width: 300, background: "rgba(14,16,22,0.95)", borderLeft: "1px solid rgba(255,255,255,0.06)", display: "flex", flexDirection: "column", flexShrink: 0 }}>
          <div style={{ padding: "13px 16px", borderBottom: "1px solid rgba(255,255,255,0.06)", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <div style={{ display: "flex", alignItems: "center", gap: 7 }}><span style={{ fontSize: 14 }}>✨</span><span style={{ fontSize: 14, fontWeight: 700 }}>AI Assistant Pipeline</span></div>
            <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <button onClick={handleResetSession} style={{ background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.08)", borderRadius: 6, color: "#A0A5B5", fontSize: 11, fontWeight: 600, padding: "3px 8px", cursor: "pointer", transition: "all 0.15s" }}>🔄 초기화</button>
              <div style={{ display: "flex", alignItems: "center", gap: 5, background: connected ? "rgba(61,214,140,0.15)" : "rgba(255,255,255,0.05)", border: `1px solid ${connected ? "#3DD68C" : "rgba(255,255,255,0.1)"}`, borderRadius: 20, padding: "2px 9px", fontSize: 10, fontWeight: 700, color: connected ? "#3DD68C" : "#6B7090" }}>{connected ? "WS_LIVE" : "OFFLINE"}</div>
            </div>
          </div>
          <div ref={chatRef} style={{ flex: 1, overflowY: "auto", padding: "12px 14px", display: "flex", flexDirection: "column", gap: 8 }}>
            {msgs.map((msg, i) => (
              <div key={i} style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.05)", borderLeft: `2px solid ${msg.hi ? "#4F8EF7":"transparent"}`, borderRadius: 9, padding: "9px 11px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 4 }}>
                  <span style={{ fontSize: 11, fontWeight: 700, color: "#4F8EF7" }}>{msg.user}</span>
                  <span style={{ fontSize: 10, padding: "1px 6px", background: "rgba(255,255,255,0.06)", borderRadius: 10, color: "#3DD68C" }}>{msg.emoji} {msg.label}</span>
                </div>
                <p style={{ margin: 0, fontSize: (msg.label === "분노" || msg.label === "불안") ? 14 : 12, fontWeight: (msg.label === "분노" || msg.label === "불안") ? 700 : 400, color: (msg.label === "분노" || msg.label === "불안") ? "#FFF" : "#B0B4CC" }}>{msg.text}</p>
              </div>
            ))}
          </div>
          <div style={{ padding: "12px 14px", borderTop: "1px solid rgba(255,255,255,0.06)" }}>
            <span style={{ fontSize: 10, fontWeight: 700, color: "#6B7090", display: "block", marginBottom: 6 }}>REAL-TIME KEYWORDS</span>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 5 }}>
              {keywords.map((kw, i) => <div key={i} style={{ background: "rgba(79,142,247,0.15)", border: "1px solid #4F8EF7", borderRadius: 20, padding: "3px 9px", fontSize: 11, color: "#4F8EF7" }}>{kw}</div>)}
            </div>
          </div>
          <div style={{ padding: "12px 14px", borderTop: "1px solid rgba(255,255,255,0.06)" }}>
            <span style={{ fontSize: 10, fontWeight: 700, color: "#6B7090", display: "block", marginBottom: 6 }}>SENTIMENT TREND</span>
            <div style={{ height: 5, background: "rgba(255,255,255,0.07)", borderRadius: 3, overflow: "hidden", marginBottom: 6 }}>
              {sentiment !== null && <div style={{ width: `${sentiment}%`, height: "100%", background: "linear-gradient(90deg,#EF4444 0%,#F7C948 45%,#3DD68C 100%)", transition: "width 0.8s ease" }}/>}
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", fontSize: 10 }}>
              <span style={{ color: "#4A4F68" }}>부정</span><span style={{ color: "#3DD68C", fontWeight: 700 }}>긍정 수치 ({sentiment || 0}%)</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}