// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

// CORS + JSON body 파서
app.use(cors());
app.use(express.json());

// ========== 타입 정의 ==========

type EmotionsMap = {
  sad?: boolean;
  anger?: boolean;
  anxious?: boolean;
  calm?: boolean;
  happy?: boolean;
  love?: boolean;
  [key: string]: boolean | undefined;
};

type Journal = {
  id: string;
  date: string;
  time?: string;
  text: string;
  length?: number;
  score?: number;
  moodScore?: number;
  mood?: number;
  xp?: number;
  emotions?: EmotionsMap;
  // 나중에 서버 쪽에 응원 문장까지 같이 저장하고 싶으면:
  supportMessage?: string;
};

type PetState = {
  userId: string;
  level: number;
  xp: number;
  streak: number;
  intimacy: number;
  updatedAt: string;
};

type SupportMessage = {
  id: string;
  journalId: string;
  userId?: string;
  message: string;
  createdAt: string;
};

type PhotoItem = {
  id: string;
  date: string;
  time: string;
  image: string;   // "wallpaper"
  imageId?: number | null;
  message: string;
};

// ========== 메모리 저장소 ==========

const journals = new Map<string, Journal>();
const petStore = new Map<string, PetState>();
const supportStore = new Map<string, SupportMessage>();
const photoItems: PhotoItem[] = []; // 사진첩 서버 동기화용

// ========== OpenAI 공통 함수 ==========

async function callOpenAIChat(
  messages: any[],
  options?: { temperature?: number; max_tokens?: number },
) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    console.error('❌ OPENAI_API_KEY 없음');
    throw new Error('OPENAI_API_KEY가 .env에 설정되어 있지 않습니다.');
  }

  console.log('📡 [OpenAI] 요청 보냄 - model=gpt-4.1-mini');

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4.1-mini',
      messages,
      temperature: options?.temperature ?? 0.7,
      max_tokens: options?.max_tokens ?? 200,
    }),
  });

  console.log('📡 [OpenAI] 응답 status =', res.status);

  if (!res.ok) {
    const text = await res.text();
    console.error('OpenAI error:', res.status, text);
    throw new Error('OpenAI API 호출 실패');
  }

  const data: any = await res.json();
  console.log('📡 [OpenAI] usage =', data.usage);
  return data.choices?.[0]?.message?.content?.trim() ?? '';
}

// 감정 분석 헬퍼
async function analyzeTextEmotions(text: string): Promise<EmotionsMap> {
  const systemPrompt = `
너는 감정 태깅 봇이야.
입력으로 한국어 일기 텍스트를 받으면 아래 JSON 형식 "만" 출력해.

{
  "emotions": {
    "sad": boolean,
    "anger": boolean,
    "anxious": boolean,
    "calm": boolean,
    "happy": boolean,
    "love": boolean
  }
}

각 필드는 해당 감정이 비교적 뚜렷하면 true, 아니면 false로 해.
설명 문장, 코드 블록, 기타 텍스트는 절대 붙이지 마.
  `.trim();

  const content = await callOpenAIChat(
    [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: text },
    ],
    { temperature: 0, max_tokens: 200 },
  );

  const base: EmotionsMap = {
    sad: false,
    anger: false,
    anxious: false,
    calm: false,
    happy: false,
    love: false,
  };

  try {
    const parsed = JSON.parse(content);
    const emo = parsed?.emotions || {};
    return {
      sad: !!emo.sad,
      anger: !!emo.anger,
      anxious: !!emo.anxious,
      calm: !!emo.calm,
      happy: !!emo.happy,
      love: !!emo.love,
    };
  } catch (err) {
    console.error('❗ analyzeTextEmotions JSON 파싱 실패, content =', content);
    return base;
  }
}

// 응원 문장 생성 헬퍼 (SupportScreen용)
function emotionsToKoreanList(emotions?: EmotionsMap): string {
  if (!emotions) return '감정 정보 없음';

  const label: Record<string, string> = {
    sad: '슬픔',
    anger: '분노',
    anxious: '불안',
    calm: '차분',
    happy: '기쁨',
    love: '사랑',
  };

  const active = Object.entries(emotions)
    .filter(([, v]) => !!v)
    .map(([k]) => label[k] ?? k);

  return active.length ? active.join(', ') : '감정 정보 없음';
}

async function generateSupportMessageForJournal(journal: Journal): Promise<string> {
  const emoSummary = emotionsToKoreanList(journal.emotions);
  const mood = journal.moodScore ?? journal.mood ?? '없음';

  const systemPrompt = `
너는 사용자의 감정을 공감해주는 부드러운 상담가야.
아래 일기 내용을 읽고, 사용자가 덜 부담스럽게 느낄 수 있는
짧은 응원/위로 문장을 한 단락(3~5문장) 만들어줘.
말투는 너무 딱딱하지 않은 존댓말로 해 줘.
  `.trim();

  const userPrompt = `
[일기 날짜] ${journal.date}
[시간] ${journal.time ?? ''}
[감정 점수] ${mood}
[감정 정보] ${emoSummary}

[일기 내용]
${journal.text}
  `.trim();

  const message = await callOpenAIChat(
    [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userPrompt },
    ],
    { temperature: 0.8, max_tokens: 300 },
  );

  return (
    message?.trim() ||
    '오늘도 기록해줘서 고마워. 네 마음은 충분히 소중해, 스스로를 너무 몰아붙이지 않았으면 좋겠어.'
  );
}

// ========== 공통 로깅 ==========

app.use((req, _res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// ========== 0) 헬스 체크 ==========

app.get('/', (_req, res) => {
  res.json({ ok: true, message: 'AI Support Server running' });
});

app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

// ========== 1) Journals ==========
// TodayJournalScreen:
//   POST /journals  { journals: [...] }
//   GET  /journals  → { journals: [...] }

app.post('/journals', (req, res) => {
  console.log('📒 POST /journals body =', req.body);
  const { journals: incoming } = req.body as { journals?: Journal[] };

  if (!incoming || !Array.isArray(incoming)) {
    return res
      .status(400)
      .json({ ok: false, error: 'journals 배열이 필요합니다.' });
  }

  // 기존 데이터 비우고 새로 채움 (전체 동기화 느낌)
  journals.clear();

  for (const j of incoming) {
    if (!j || !j.id || !j.date || !j.text) continue;

    const emotions: EmotionsMap =
      j.emotions && typeof j.emotions === 'object'
        ? { ...j.emotions }
        : {
            sad: false,
            anger: false,
            anxious: false,
            calm: false,
            happy: false,
            love: false,
          };

    const stored: Journal = {
      ...j,
      id: String(j.id),
      emotions,
    };

    journals.set(stored.id, stored);
  }

  console.log(`📒 /journals 동기화 완료 - count=${journals.size}`);

  return res.json({ ok: true, count: journals.size });
});

// GET /journals → { journals: [...] } (옵션: ?date=YYYY-MM-DD)
app.get('/journals', (req, res) => {
  const all = Array.from(journals.values());
  const { date } = req.query;

  let result = all;
  if (typeof date === 'string') {
    result = all.filter((j) => j.date === date);
  }

  return res.json({ journals: result });
});

// ========== 2) Pet ==========

app.get('/pet/:userId', (req, res) => {
  const { userId } = req.params;
  let pet = petStore.get(userId);

  if (!pet) {
    pet = {
      userId,
      level: 1,
      xp: 0,
      streak: 0,
      intimacy: 0,
      updatedAt: new Date().toISOString(),
    };
    petStore.set(userId, pet);
  }

  return res.json(pet);
});

app.put('/pet/:userId', (req, res) => {
  const { userId } = req.params;
  const incoming = req.body as Partial<PetState>;

  let current = petStore.get(userId);
  if (!current) {
    current = {
      userId,
      level: 1,
      xp: 0,
      streak: 0,
      intimacy: 0,
      updatedAt: new Date().toISOString(),
    };
  }

  const updated: PetState = {
    ...current,
    ...incoming,
    userId,
    updatedAt: new Date().toISOString(),
  };

  petStore.set(userId, updated);
  return res.json(updated);
});

// ========== 3) 감정 분석 API (/analyze) ==========
// TodayJournalScreen의 runEmotionAnalyzeInBackground 에서 사용
//   POST /analyze { text }
//   응답: { emotions: {...} }

app.post('/analyze', async (req, res) => {
  const { text } = req.body as { text?: string };
  if (!text) {
    return res
      .status(400)
      .json({ ok: false, error: 'text 필드는 필수입니다.' });
  }

  try {
    const emotions = await analyzeTextEmotions(text);
    return res.json({ emotions });
  } catch (err) {
    console.error(err);
    return res
      .status(500)
      .json({ ok: false, error: '감정 분석 중 오류가 발생했습니다.' });
  }
});

// ========== 4) 응원/위로 조회 API (/support-message) ==========
// SupportScreen:
//   GET /support-message?journalId=xxx
//   → { ok: true, message: "..." }
//   없으면 서버가 여기서 OpenAI 호출해서 바로 만들어서 돌려줌.

app.get('/support-message', async (req, res) => {
  const { journalId } = req.query;

  if (typeof journalId !== 'string') {
    return res
      .status(400)
      .json({ ok: false, error: 'journalId 쿼리 파라미터가 필요합니다.' });
  }

  // 1) 이미 생성된 응원 문장이 있으면 그대로 반환
  const existing = supportStore.get(journalId);
  if (existing) {
    return res.json({
      ok: true,
      journalId: existing.journalId,
      message: existing.message,
      createdAt: existing.createdAt,
    });
  }

  // 2) journals에서 해당 일기를 찾음 (TodayJournalScreen → POST /journals 로 동기화된 것)
  const journal = journals.get(journalId);
  if (!journal) {
    console.log('❗ support-message: journal not found:', journalId);
    return res.status(404).json({ ok: false, error: 'journal not found' });
  }

  try {
    console.log('🧡 support-message 생성 시작:', journalId);
    const msg = await generateSupportMessageForJournal(journal);

    const support: SupportMessage = {
      id: `${journalId}-${Date.now()}`,
      journalId,
      userId: undefined,
      message: msg,
      createdAt: new Date().toISOString(),
    };

    supportStore.set(journalId, support);

    // 서버 쪽 journal에도 같이 저장(선택 사항)
    journals.set(journalId, {
      ...journal,
      supportMessage: msg,
    });

    console.log('✅ support-message 생성 완료:', journalId);

    return res.json({
      ok: true,
      journalId,
      message: msg,
      createdAt: support.createdAt,
    });
  } catch (err) {
    console.error('GET /support-message error:', err);
    return res
      .status(500)
      .json({ ok: false, error: 'support message generation failed' });
  }
});

// ========== 5) 사진첩 동기화 API (/photo-items) ==========
// SupportScreen.savePhotoItem() 에서 사용
//   POST /photo-items { items: [...] }

app.post('/photo-items', (req, res) => {
  const { items } = req.body as { items?: PhotoItem[] };

  if (!items || !Array.isArray(items)) {
    return res
      .status(400)
      .json({ ok: false, error: 'items 배열이 필요합니다.' });
  }

  photoItems.length = 0;
  photoItems.push(...items);

  console.log(`📸 POST /photo-items 동기화 완료 - 개수: ${photoItems.length}`);
  return res.json({ ok: true, count: photoItems.length });
});

// (선택) 디버깅용: 현재 서버에 저장된 사진첩 보기
app.get('/photo-items', (_req, res) => {
  return res.json({ ok: true, items: photoItems });
});

// ========== 서버 시작 ==========

app.listen(PORT, () => {
  console.log(`🚀 Server listening on http://localhost:${PORT}`);
});
