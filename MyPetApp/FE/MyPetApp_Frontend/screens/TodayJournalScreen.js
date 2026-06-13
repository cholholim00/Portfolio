// screens/TodayJournalScreen.js
import React, { useState, useEffect, useRef } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Alert,
  Modal,
  StyleSheet,
  KeyboardAvoidingView,
  Platform,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useNavigation } from "@react-navigation/native";
import LottieView from "lottie-react-native";


const API_BASE = "http://10.138.31.34:4000";

// 감정별 메타 정보 테이블 polarity: 0 = 긍정, 1 = 부정 (혹은 반대 감정)
// value: 감정 점수
const EMOTION_TABLE = {
  sad: { polarity: 1, value: 10 },
  anger: { polarity: 1, value: 20 },
  anxious: { polarity: 1, value: 15 },
  calm: { polarity: 0, value: 30 },
  happy: { polarity: 0, value: 40 },
  love: { polarity: 0, value: 50 },
};

// UI에서 쓸 감정 버튼 리스트 (key + 한글 라벨)
const EMOTIONS = [
  { key: "sad", label: "슬픔" },
  { key: "anger", label: "분노" },
  { key: "anxious", label: "불안" },
  { key: "calm", label: "차분" },
  { key: "happy", label: "기쁨" },
  { key: "love", label: "사랑" },
];


const MIN_LENGTH = 15; // 일기 최소 글자 수
const STREAK_BONUS_TABLE = [0, 2, 3, 4, 6, 8, 10];// 일기를 하루하루 연속적으로 썼을때 보너스 XP


// 🔹 미래 편지 관련 키
// [{id, targetDate, createdDate, text, viewedDate?}]
const FUTURE_LETTERS_KEY = "future_letters"; 
// 오늘 날짜를 YYYY-MM-DD 문자열로 반환하는 함수
const getTodayLocalDate = () => {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
};

// 감정 키워드를 하나라도 선택했는지 체크하는 함수
const hasAnyEmotion = (emoObj) => {
  return Object.values(emoObj).some((v) => !!v);
};

// 선택된 감정에 따라 기분 점수 계산하는 함수
function calcMoodScoreByRule(selected) {
  const posScores = [];
  const negScores = [];

   // 선택된 감정을 긍정/부정 배열에 나눠서 담음
  Object.entries(selected).forEach(([key, on]) => {
    if (!on) return;
    const meta = EMOTION_TABLE[key];
    if (!meta) return;
    if (meta.polarity === 0) posScores.push(meta.value);
    else negScores.push(meta.value);
  });

  // 아무 감정도 선택 안 했으면 0점
  if (posScores.length === 0 && negScores.length === 0) return 0;

  // 기본 점수: 선택된 모든 감정의 value 합 ?
  const base =
    posScores.reduce((s, v) => s + v, 0) +
    negScores.reduce((s, v) => s + v, 0);

  // 긍정/부정 점수 합계
  const sumPos = posScores.reduce((s, v) => s + v, 0);
  const sumNeg = negScores.reduce((s, v) => s + v, 0);

  // 모든 감정이 선택되었는지 여부
  const allSelected = Object.keys(EMOTION_TABLE).every((k) => selected[k]);


  let finalScore = base;

  // 부정적 감 더 큰 경우: 긍정 중 가장 큰 값 빼기
  if (sumNeg > sumPos) {
    const a = posScores.length > 0 ? Math.max(...posScores) : 0;
    finalScore = base - a;
  } else if (sumNeg === sumPos) { // 긍/부 합이 같은 경우
    if (allSelected) {// 전부 다 골랐다면 특수 케이스로 100점 처리
      finalScore = 100;
    } else {// 부정 중 가장 큰 값 하나 빼기
      const a = negScores.length > 0 ? Math.max(...negScores) : 0;
      finalScore = base - a;
    }
  } else {
    if (negScores.length === 0) {
      finalScore = base;
    } else {
      const a = Math.min(...negScores);
      finalScore = base - a;
    }
  }


  return finalScore;
}


// 🔹 emotions 객체 → ["불안","분노"] 같은 감정 태그 배열로 변환
const buildEmotionKeywords = (emotionsObj) => {
  return EMOTIONS.filter((e) => emotionsObj[e.key]).map((e) => e.label);
};


// 🔹 선택된 감정을 한글 문장으로 (슬픔, 분노 ...)
const buildEmotionSentence = (emotionsObj) => {
  const labels = buildEmotionKeywords(emotionsObj);
  if (labels.length === 0) return "여러 가지 감정이 섞여 있었구나?";
  if (labels.length === 1) return `오늘의 너의 감정은 ${labels[0]}이었구나?`;
  return `오늘의 너의 감정은 ${labels.join(", ")}이었구나?`;
};


export default function TodayJournalScreen() {
  const navigation = useNavigation();


  const [text, setText] = useState("");
  const [emotions, setEmotions] = useState({
    sad: false,
    anger: false,
    anxious: false,
    calm: false,
    happy: false,
    love: false,
  });


  const [showRewardModal, setShowRewardModal] = useState(false);
  const [rewardXp, setRewardXp] = useState(0);
  const [rewardStreakMsg, setRewardStreakMsg] = useState("");
  const [savedDate, setSavedDate] = useState(null);
  const [savedTime, setSavedTime] = useState(null);


  // Support로 넘길 마지막 저장 일기 정보
  const [savedText, setSavedText] = useState("");
  const [savedEmotions, setSavedEmotions] = useState({
    sad: false,
    anger: false,
    anxious: false,
    calm: false,
    happy: false,
    love: false,
  });
  const [savedMoodScore, setSavedMoodScore] = useState(null);
  const [savedJournalId, setSavedJournalId] = useState(null);
  const [savedEmotionKeywords, setSavedEmotionKeywords] = useState([]); // '#불안 #분노'용 태그 배열


  // 팝업에서 보여줄 감정 문장
  const [savedEmotionSentence, setSavedEmotionSentence] = useState("");


  const isSaveDisabled = text.length < MIN_LENGTH;


  const toggleEmotion = (key) => {
    setEmotions((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };


  // 🔹 ScrollView ref (키보드 올라올 때 아래로 스크롤)
  const scrollRef = useRef(null);


  const scrollToEnd = () => {
    if (!scrollRef.current) return;
    scrollRef.current.scrollToEnd({ animated: true });
  };


  // 🔹 서버에서 journals 최신값 받아와 로컬/상태 갱신 (백그라운드)
  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      if (!res.ok) return;
      const data = await res.json();
      if (data && Array.isArray(data.journals)) {
        await AsyncStorage.setItem("journals", JSON.stringify(data.journals));
        console.log("GET /journals로 로컬 갱신 완료");
      }
    } catch (e) {
      console.log("GET /journals 동기화 에러:", e);
    }
  };


  // 🔹 일기 저장 시, photo_items에 “응원 준비 중” 상태로 먼저 한 장 저장
  const savePendingPhotoItem = async ({ date, time, message }) => {
    try {
      const raw = await AsyncStorage.getItem("photo_items");
      const list = raw ? JSON.parse(raw) : [];


      const newItem = {
        id: Date.now().toString(),
        date,
        time,
        image: "wallpaper",
        imageId: null,
        message,
      };


      const updated = [...list, newItem];
      await AsyncStorage.setItem("photo_items", JSON.stringify(updated));
      console.log("pending photo_item 저장 완료");
    } catch (e) {
      console.log("savePendingPhotoItem 에러:", e);
    }
  };


  // =========================
  // 🔹 미래 편지 기능 상태
  // =========================
  const [isFutureLetterMode, setIsFutureLetterMode] = useState(false);
  const [futureText, setFutureText] = useState(""); // 미래 편지 내용
  const [futureDate, setFutureDate] = useState(""); // YYYY-MM-DD 입력
  const [showFutureLetterPopup, setShowFutureLetterPopup] = useState(false);
  const [todayFutureLetter, setTodayFutureLetter] = useState(null);


  // 앱 진입 시: 오늘 날짜에 열릴 미래 편지 있는지 확인
  useEffect(() => {
    const checkFutureLetters = async () => {
      try {
        const today = getTodayLocalDate();
        const raw = await AsyncStorage.getItem(FUTURE_LETTERS_KEY);
        const list = raw ? JSON.parse(raw) : [];


        const target = list.find(
          (l) => l.targetDate === today && !l.viewedDate
        );
        if (target) {
          setTodayFutureLetter(target);
          setShowFutureLetterPopup(true);
        }
      } catch (e) {
        console.log("미래 편지 체크 에러:", e);
      }
    };


    checkFutureLetters();
  }, []);


  // 미래 편지 저장
  const saveFutureLetter = async () => {
    const trimmed = futureText.trim();
    if (!trimmed) {
      Alert.alert("내용 없음", "미래 편지 내용을 먼저 적어줘.");
      return;
    }
    if (!futureDate) {
      Alert.alert("날짜 없음", "언제 열릴지 날짜를 설정해줘. (예: 2025-12-31)");
      return;
    }


    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(futureDate)) {
      Alert.alert("날짜 형식 오류", "YYYY-MM-DD 형식으로 입력해줘.");
      return;
    }


    try {
      const raw = await AsyncStorage.getItem(FUTURE_LETTERS_KEY);
      const list = raw ? JSON.parse(raw) : [];


      const newLetter = {
        id: Date.now().toString(),
        text: trimmed,
        targetDate: futureDate,
        createdDate: getTodayLocalDate(),
        viewedDate: null,
      };


      const updated = [...list, newLetter];
      await AsyncStorage.setItem(FUTURE_LETTERS_KEY, JSON.stringify(updated));


      Alert.alert(
        "미래 편지 저장 완료",
        `${futureDate}에 다시 만날 수 있어.`
      );
      setFutureText("");
      setFutureDate("");
      setIsFutureLetterMode(false);
    } catch (e) {
      console.log("미래 편지 저장 에러:", e);
      Alert.alert("저장 실패", "미래 편지 저장 중 문제가 발생했어.");
    }
  };


  // 오늘 미래 편지 팝업 닫기 (확인 후 삭제/소멸)
  const handleCloseFuturePopup = async () => {
    try {
      if (!todayFutureLetter) {
        setShowFutureLetterPopup(false);
        return;
      }
      const raw = await AsyncStorage.getItem(FUTURE_LETTERS_KEY);
      const list = raw ? JSON.parse(raw) : [];


      const updated = list.map((l) =>
        l.id === todayFutureLetter.id
          ? { ...l, viewedDate: getTodayLocalDate() }
          : l
      );
      await AsyncStorage.setItem(FUTURE_LETTERS_KEY, JSON.stringify(updated));
    } catch (e) {
      console.log("미래 편지 viewed 처리 에러:", e);
    } finally {
      setShowFutureLetterPopup(false);
      setTodayFutureLetter(null);
    }
  };


  // 🔹 AI 감정 분석 → journals + 현재 화면 상태까지 반영
  const runEmotionAnalyzeInBackground = async (journal) => {
    try {
      console.log("runEmotionAnalyzeInBackground 시작");
      const res = await fetch(`${API_BASE}/analyze`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: journal.text }),
      });


      if (!res.ok) {
        console.log("analyze 응답 실패:", res.status);
        return;
      }


      const data = await res.json();
      console.log("analyze 응답:", data);
      if (!data.emotions) return;


      const analyzedEmotions = {
        sad: !!data.emotions.sad,
        anger: !!data.emotions.anger,
        anxious: !!data.emotions.anxious,
        calm: !!data.emotions.calm,
        happy: !!data.emotions.happy,
        love: !!data.emotions.love,
      };


      const saved = await AsyncStorage.getItem("journals");
      const list = saved ? JSON.parse(saved) : [];


      const updated = list.map((j) =>
        j.id === journal.id
          ? {
              ...j,
              emotions: analyzedEmotions,
              emotionKeywords: buildEmotionKeywords(analyzedEmotions),
            }
          : j
      );


      await AsyncStorage.setItem("journals", JSON.stringify(updated));
      console.log("AI 감정 분석 결과로 emotions / emotionKeywords 업데이트 완료");


      setEmotions(analyzedEmotions);
      setSavedEmotions(analyzedEmotions);
      const aiKeywords = buildEmotionKeywords(analyzedEmotions);
      setSavedEmotionKeywords(aiKeywords);
      setSavedEmotionSentence(buildEmotionSentence(analyzedEmotions));
    } catch (e) {
      console.log("runEmotionAnalyzeInBackground 에러:", e);
    }
  };


  const saveJournal = async () => {
    if (isSaveDisabled) {
      Alert.alert("조금 더 써볼까?", `최소 ${MIN_LENGTH}자 이상 작성해줘!`);
      return;
    }


    try {
      const today = getTodayLocalDate();
      const now = new Date();
      const timeStr = now.toTimeString().slice(0, 5);


      const newEmotions = { ...emotions };
      const moodScore = calcMoodScoreByRule(newEmotions);
      const baseXp = Math.floor(text.length * 0.5) + 10;


      const emotionKeywords = buildEmotionKeywords(newEmotions);


      const newJournal = {
        id: Date.now().toString(),
        date: today,
        time: timeStr,
        text: text.trim(),
        length: text.length,
        score: Math.floor(text.length * 0.5),
        moodScore: moodScore * 0.3,
        mood: moodScore,
        xp: baseXp,
        emotions: newEmotions,
        emotionKeywords,
        aiLabel: null,
        aiScore: null,
      };


      const saved = await AsyncStorage.getItem("journals");
      const list = saved ? JSON.parse(saved) : [];
      const updatedJournals = [...list, newJournal];


      await AsyncStorage.setItem("journals", JSON.stringify(updatedJournals));


      await savePendingPhotoItem({
        date: today,
        time: timeStr,
        message: "응원 문장을 준비 중이야. 조금 뒤에 다시 확인해 줘!",
      });


      (async () => {
        try {
          const res = await fetch(`${API_BASE}/journals`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ journals: updatedJournals }),
          });
          const json = await res.json();
          console.log("POST /journals ok =", json.ok);


          if (json.ok) {
            syncJournalsFromServer();
          }
        } catch (e) {
          console.log("POST /journals error", e);
        }
      })();


      if (!hasAnyEmotion(newEmotions)) {
        runEmotionAnalyzeInBackground(newJournal);
      }


      const dates = Array.from(
        new Set(updatedJournals.map((j) => j.date))
      ).sort();
      let streak = 0;
      let prev = null;
      for (const d of dates) {
        if (!prev) {
          streak = 1;
        } else {
          const diffDays =
            (new Date(d) - new Date(prev)) / (24 * 60 * 60 * 1000);
          streak = diffDays === 1 ? streak + 1 : 1;
        }
        prev = d;
      }
      const clamped = Math.min(streak, 7);
      const index = clamped - 1;
      const bonusXp = index >= 0 ? STREAK_BONUS_TABLE[index] : 0;
      const gainedXp = baseXp + bonusXp;


      const savedPet = await AsyncStorage.getItem("pet");
      const pet = savedPet
        ? JSON.parse(savedPet)
        : {
            name: "MY PET",
            xp: 0,
            level: 1,
            streak: 0,
            lastRewardDate: null,
          };


      const newXp = (pet.xp ?? 0) + gainedXp;
      const newLevel = Math.floor(newXp / 100) + 1;


      const updatedPet = {
        ...pet,
        xp: newXp,
        level: newLevel,
        streak,
        lastRewardDate: today,
      };
      await AsyncStorage.setItem("pet", JSON.stringify(updatedPet));


      setSavedText(newJournal.text);
      setSavedEmotions(newEmotions);
      setSavedMoodScore(newJournal.moodScore);
      setSavedDate(today);
      setSavedTime(timeStr);
      setSavedJournalId(newJournal.id);
      setSavedEmotionKeywords(emotionKeywords);
      setSavedEmotionSentence(buildEmotionSentence(newEmotions));


      setRewardXp(gainedXp);
      setRewardStreakMsg(
        streak > 1 ? `${streak}일 연속으로 일기를 쓰고 있어!` : ""
      );
      setShowRewardModal(true);


      setText("");
      setEmotions({
        sad: false,
        anger: false,
        anxious: false,
        calm: false,
        happy: false,
        love: false,
      });
    } catch (error) {
      console.log("saveJournal 에러", error);
      Alert.alert("저장 실패", "일기 저장 중 문제가 발생했어.");
    }
  };


  const handleCloseRewardModal = () => {
    setShowRewardModal(false);
    navigation.navigate("Support", {
      fromTodayJournal: true,
      text: savedText,
      emotions: savedEmotions,
      moodScore: savedMoodScore,
      date: savedDate,
      time: savedTime,
      journalId: savedJournalId,
      emotionKeywords: savedEmotionKeywords,
    });
  };


  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      keyboardVerticalOffset={Platform.OS === "ios" ? 0 : 0}
    >
      <ScrollView
        ref={scrollRef}
        style={styles.container}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {/* 감정 선택 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>오늘 기분은 어때?</Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.emotionsRow}
          >
            {EMOTIONS.map((emotion) => (
              <TouchableOpacity
                key={emotion.key}
                style={[
                  styles.emotionBtn,
                  emotions[emotion.key] && styles.emotionBtnActive,
                ]}
                onPress={() => toggleEmotion(emotion.key)}
              >
                <Text
                  style={[
                    styles.emotionText,
                    emotions[emotion.key] && styles.emotionTextActive,
                  ]}
                >
                  {emotion.label}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>


        {/* 텍스트 입력 */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>오늘의 기록</Text>
          <TextInput
            style={styles.textInput}
            value={text}
            onChangeText={setText}
            placeholder="오늘 하루 있었던 일을 자유롭게 적어줘..."
            multiline
            textAlignVertical="top"
            maxLength={2000}
          />
          <Text
            style={[
              styles.charCount,
              text.length < MIN_LENGTH && styles.charCountWarning,
            ]}
          >
            {text.length}자
          </Text>
        </View>


        {/* 🔹 미래 편지 토글 + 입력 영역 */}
        <View style={styles.section}>
          <View style={styles.futureHeader}>
            <Text style={styles.sectionTitle}>미래 편지</Text>
            <TouchableOpacity
              style={[
                styles.futureToggle,
                isFutureLetterMode && styles.futureToggleActive,
              ]}
              onPress={() => setIsFutureLetterMode((v) => !v)}
            >
              <Text
                style={[
                  styles.futureToggleText,
                  isFutureLetterMode && styles.futureToggleTextActive,
                ]}
              >
                {isFutureLetterMode ? "작성 끄기" : "작성 켜기"}
              </Text>
            </TouchableOpacity>
          </View>


          {isFutureLetterMode && (
            <>
              <Text style={styles.futureLabel}>미래의 나에게 하고 싶은 말</Text>
              <TextInput
                style={[styles.textInput, { minHeight: 140 }]}
                value={futureText}
                onChangeText={setFutureText}
                placeholder="미래의 나에게 편지를 써 줘..."
                multiline
                textAlignVertical="top"
                maxLength={2000}
                onFocus={scrollToEnd}
              />
              <Text style={styles.futureLabel}>언제 읽을까? (YYYY-MM-DD)</Text>
              <TextInput
                style={styles.futureDateInput}
                value={futureDate}
                onChangeText={setFutureDate}
                placeholder="예: 2025-12-31"
                onFocus={scrollToEnd}
              />
              <TouchableOpacity
                style={styles.futureSaveBtn}
                onPress={saveFutureLetter}
              >
                <Text style={styles.futureSaveText}>미래 편지 저장</Text>
              </TouchableOpacity>
            </>
          )}
        </View>


        {/* 저장 버튼 */}
        <TouchableOpacity
          style={[styles.saveBtn, isSaveDisabled && styles.saveBtnDisabled]}
          onPress={saveJournal}
          disabled={isSaveDisabled}
          activeOpacity={0.8}
        >
          <Text
            style={[
              styles.saveBtnText,
              isSaveDisabled && styles.saveBtnTextDisabled,
            ]}
          >
            {isSaveDisabled
              ? `최소 ${MIN_LENGTH - text.length}자 더 작성해줘`
              : "저장하기"}
          </Text>
        </TouchableOpacity>


        {/* 홈으로 버튼 */}
        <TouchableOpacity
          style={styles.homeBtn}
          onPress={() =>
            navigation.reset({
              index: 0,
              routes: [{ name: "Today" }],
            })
          }
        >
          <Text style={styles.homeBtnText}>홈으로</Text>
        </TouchableOpacity>


        {/* 감정/경험치 모달 */}
        <Modal
          visible={showRewardModal}
          transparent
          animationType="fade"
          onRequestClose={handleCloseRewardModal}
        >
          <View style={styles.modalOverlay}>
            <View style={styles.modalBox}>
              <LottieView
                source={require("../assets/animations/Happy_Dog.json")}
                autoPlay
                loop={false}
                style={{ width: 160, height: 160 }}
              />
              <Text style={styles.modalTitle}>{savedEmotionSentence}</Text>
              <Text style={styles.modalXpText}>{rewardXp} XP 얻었어!</Text>
              {!!rewardStreakMsg && (
                <Text style={styles.modalStreakText}>{rewardStreakMsg}</Text>
              )}
              <TouchableOpacity
                style={styles.modalButton}
                onPress={handleCloseRewardModal}
              >
                <Text style={styles.modalButtonText}>응원 받으러 가기</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>


        {/* 🔹 오늘 열릴 미래 편지 팝업 (하루 한 번) */}
        <Modal
          visible={showFutureLetterPopup}
          transparent
          animationType="fade"
          onRequestClose={handleCloseFuturePopup}
        >
          <View style={styles.modalOverlay}>
            <View style={styles.modalBox}>
              <Text style={styles.modalTitle}>미래의 나에게 보내주는 편지</Text>
              <ScrollView style={{ maxHeight: 260, marginTop: 10 }}>
                <Text style={styles.modalText}>
                  {todayFutureLetter?.text ?? ""}
                </Text>
              </ScrollView>
              <TouchableOpacity
                style={[styles.modalButton, { marginTop: 16 }]}
                onPress={handleCloseFuturePopup}
              >
                <Text style={styles.modalButtonText}>
                  오늘의 하루도 정말 고생 많았어
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  scrollContent: {
    padding: 20,
    paddingBottom: 40,
  },
  section: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 16,
    marginBottom: 20,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: "700",
    color: "#333",
    marginBottom: 16,
  },
  emotionsRow: {
    flexDirection: "row",
    paddingVertical: 8,
  },
  emotionBtn: {
    backgroundColor: "#f8f9fa",
    paddingHorizontal: 18,
    paddingVertical: 12,
    borderRadius: 25,
    marginRight: 12,
    borderWidth: 2,
    borderColor: "#e9ecef",
    minWidth: 80,
  },
  emotionBtnActive: {
    backgroundColor: "#2196f3",
    borderColor: "#1976d2",
  },
  emotionText: {
    fontSize: 14,
    fontWeight: "600",
    color: "#666",
    textAlign: "center",
  },
  emotionTextActive: {
    color: "white",
    fontWeight: "700",
  },
  textInput: {
    fontSize: 16,
    minHeight: 200,
    padding: 16,
    borderRadius: 12,
    backgroundColor: "#fafbfc",
    borderWidth: 1,
    borderColor: "#e9ecef",
    textAlignVertical: "top",
  },
  charCount: {
    textAlign: "right",
    marginTop: 8,
    fontSize: 14,
    color: "#666",
    fontWeight: "500",
  },
  charCountWarning: {
    color: "#f44336",
  },
  // 미래 편지 스타일
  futureHeader: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  futureToggle: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: "#ccc",
    backgroundColor: "#f5f5f5",
  },
  futureToggleActive: {
    backgroundColor: "#1976d2",
    borderColor: "#1565c0",
  },
  futureToggleText: {
    fontSize: 12,
    fontWeight: "600",
    color: "#555",
  },
  futureToggleTextActive: {
    color: "#fff",
  },
  futureLabel: {
    marginTop: 12,
    marginBottom: 6,
    fontSize: 13,
    color: "#555",
    fontWeight: "600",
  },
  futureDateInput: {
    borderWidth: 1,
    borderColor: "#e9ecef",
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 10,
    backgroundColor: "#fafbfc",
    fontSize: 14,
  },
  futureSaveBtn: {
    marginTop: 12,
    alignSelf: "flex-end",
    backgroundColor: "#4caf50",
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 10,
  },
  futureSaveText: {
    color: "#fff",
    fontSize: 13,
    fontWeight: "700",
  },
  saveBtn: {
    backgroundColor: "#4caf50",
    padding: 20,
    borderRadius: 16,
    alignItems: "center",
    marginBottom: 20,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 6,
  },
  saveBtnDisabled: {
    backgroundColor: "#ccc",
    shadowOpacity: 0,
    elevation: 0,
  },
  saveBtnText: {
    color: "white",
    fontSize: 18,
    fontWeight: "800",
  },
  saveBtnTextDisabled: {
    color: "#999",
  },
  homeBtn: {
    backgroundColor: "#6c757d",
    padding: 16,
    borderRadius: 12,
    alignItems: "center",
    marginBottom: 16,
  },
  homeBtnText: {
    color: "white",
    fontSize: 16,
    fontWeight: "700",
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    alignItems: "center",
  },
  modalBox: {
    width: 320,
    maxWidth: "90%",
    paddingVertical: 20,
    paddingHorizontal: 18,
    borderRadius: 18,
    backgroundColor: "#fff",
    alignItems: "center",
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: "800",
    marginTop: 8,
    color: "#333",
    textAlign: "center",
  },
  modalText: {
    marginTop: 8,
    fontSize: 13,
    color: "#555",
    textAlign: "center",
  },
  modalXpText: {
    marginTop: 10,
    fontSize: 15,
    fontWeight: "700",
    color: "#1976d2",
  },
  modalStreakText: {
    marginTop: 4,
    fontSize: 13,
    color: "#666",
    textAlign: "center",
  },
  modalButton: {
    marginTop: 14,
    backgroundColor: "#4caf50",
    paddingVertical: 10,
    paddingHorizontal: 28,
    borderRadius: 10,
  },
  modalButtonText: {
    color: "#fff",
    fontSize: 15,
    fontWeight: "700",
  },
});