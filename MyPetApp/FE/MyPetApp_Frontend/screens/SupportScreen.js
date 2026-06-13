// screens/SupportScreen.js
import React, { useState, useEffect, useMemo } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  ImageBackground,
  BackHandler,
  ActivityIndicator,
  StyleSheet,
  Platform,
} from "react-native";
import { Ionicons } from "@expo/vector-icons";
import { Audio } from "expo-av";
import AsyncStorage from "@react-native-async-storage/async-storage";

const API_BASE = "http://10.138.31.34:4000";

// 감정별 배경/음악 쌍 (앱 번들에 포함된 정적 파일)
const POSITIVE_WALLPAPERS = [
  { id: 1, image: require("../wallpaper/0/1.jpg"), sound: require("../wallpaper/0/1.mp3") },
  { id: 2, image: require("../wallpaper/0/2.jpg"), sound: require("../wallpaper/0/2.mp3") },
  { id: 3, image: require("../wallpaper/0/3.jpg"), sound: require("../wallpaper/0/3.mp3") },
  { id: 4, image: require("../wallpaper/0/4.jpg"), sound: require("../wallpaper/0/4.mp3") },
  { id: 5, image: require("../wallpaper/0/5.jpg"), sound: require("../wallpaper/0/5.mp3") },
];

const NEGATIVE_WALLPAPERS = [
  { id: 6, image: require("../wallpaper/1/6.jpg"), sound: require("../wallpaper/1/6.mp3") },
  { id: 7, image: require("../wallpaper/1/7.jpg"), sound: require("../wallpaper/1/7.mp3") },
  { id: 8, image: require("../wallpaper/1/8.jpg"), sound: require("../wallpaper/1/8.mp3") },
  { id: 9, image: require("../wallpaper/1/9.jpg"), sound: require("../wallpaper/1/9.mp3") },
  { id: 10, image: require("../wallpaper/1/10.jpg"), sound: require("../wallpaper/1/10.mp3") },
];

// journals에 supportMessage / supportImage / supportImageId 저장
const saveSupportToJournal = async ({ journalId, date, time, message, wallpaper }) => {
  try {
    const raw = await AsyncStorage.getItem("journals");
    const list = raw ? JSON.parse(raw) : [];

    const updated = list.map((j) => {
      const same = journalId
        ? String(j.id) === String(journalId)
        : j.date === date && j.time === time;

      if (!same) return j;

      return {
        ...j,
        supportMessage: message,
        supportImage: "wallpaper",
        supportImageId: wallpaper ? wallpaper.id : null,
      };
    });

    await AsyncStorage.setItem("journals", JSON.stringify(updated));
  } catch (e) {
    console.log("saveSupportToJournal 에러:", e);
  }
};

// 사진첩용 photo_items에 저장 + 서버 동기화
const savePhotoItem = async ({ date, time, message, wallpaper }) => {
  try {
    const raw = await AsyncStorage.getItem("photo_items");
    const list = raw ? JSON.parse(raw) : [];

    const newItem = {
      id: Date.now().toString(),
      date,
      time,
      image: "wallpaper",
      imageId: wallpaper.id,
      message,
    };

    const updated = [...list, newItem];
    await AsyncStorage.setItem("photo_items", JSON.stringify(updated));

    (async () => {
      try {
        const res = await fetch(`${API_BASE}/photo-items`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ items: updated }),
        });
        const json = await res.json();
        console.log("POST /photo-items ok =", json.ok);
      } catch (e) {
        console.log("POST /photo-items error", e);
      }
    })();
  } catch (e) {
    console.log("photo_items 저장 에러:", e);
  }
};

// 로컬 journals에서 이미 저장된 supportMessage / 감정 키워드 먼저 불러오기
// 여기서 keywords 는 감정 태그(예: ["불안","분노"])라고 가정
const loadLocalSupport = async ({ journalId, date, time }) => {
  try {
    const raw = await AsyncStorage.getItem("journals");
    const list = raw ? JSON.parse(raw) : [];
    const target = list.find((j) =>
      journalId ? String(j.id) === String(journalId) : j.date === date && j.time === time
    );
    if (target) {
      return {
        supportMessage: target.supportMessage ? String(target.supportMessage) : null,
        emotionKeywords: Array.isArray(target.emotionKeywords)
          ? target.emotionKeywords
          : Array.isArray(target.keywords)
          ? target.keywords
          : [],
      };
    }
  } catch (e) {
    console.log("loadLocalSupport 에러:", e);
  }
  return { supportMessage: null, emotionKeywords: [] };
};

export default function SupportScreen({ route, navigation }) {
  const {
    fromTodayJournal,
    // 단일 진입용 기존 파라미터
    text,
    emotions,
    date,
    time,
    journalId,
    imageSource,
    message: initialMessage,
    moodScore,
    // 사진첩 갤러리 모드: 여러 개를 좌우로
    items, // [{ date, time, journalId, image, imageId, message, moodScore, emotionKeywords / keywords }, ...]
    initialIndex = 0,
  } = route.params ?? {};

  // 갤러리 모드 여부: items 배열이 있을 때
  const galleryMode = Array.isArray(items) && items.length > 0;

  // 현재 인덱스 (갤러리 모드일 때만 의미 있음)
  const [currentIndex, setCurrentIndex] = useState(
    galleryMode ? Math.min(initialIndex, items.length - 1) : 0
  );

  // 현재 카드에 해당하는 기본 값 계산
  const currentItem = useMemo(() => {
    if (!galleryMode) {
      return { date, time, journalId, imageSource, moodScore, emotionKeywords: [] };
    }
    return items[currentIndex] || items[0];
  }, [galleryMode, items, currentIndex, date, time, journalId, imageSource, moodScore]);

  const [bgmOn, setBgmOn] = useState(false);
  const [sound, setSound] = useState(null);
  const [wallpaper, setWallpaper] = useState(null);

  const [aiMessage, setAiMessage] = useState(initialMessage || "");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [forceShowLoading, setForceShowLoading] = useState(false);

  // 감정 키워드 상태 (journals 기준) – '#불안 #분노' 처럼 위에 보여줄 값
  const [emotionKeywords, setEmotionKeywords] = useState(
    Array.isArray(currentItem.emotionKeywords)
      ? currentItem.emotionKeywords
      : Array.isArray(currentItem.keywords)
      ? currentItem.keywords
      : []
  );

  // 홈 버튼 10초 페이드용 상태 (오늘 일기 플로우에서만 사용)
  const [homeBtnProgress, setHomeBtnProgress] = useState(fromTodayJournal ? 0 : 1);
  const [homeBtnEnabled, setHomeBtnEnabled] = useState(!fromTodayJournal);

  // 감정 기반 배경/음악 랜덤 선택 (현재 카드 기준)
  useEffect(() => {
    const score =
      typeof currentItem.moodScore === "number"
        ? currentItem.moodScore
        : moodScore;

    let list;
    if (typeof score === "number" && score > 0) {
      list = POSITIVE_WALLPAPERS;
    } else {
      list = NEGATIVE_WALLPAPERS;
    }
    const pick = list[Math.floor(Math.random() * list.length)];
    setWallpaper(pick);
  }, [currentItem.moodScore, moodScore, currentIndex]);

  // BGM 토글: 선택된 wallpaper.sound 사용
  const toggleBgm = async () => {
    try {
      if (!wallpaper) return;

      if (!bgmOn) {
        let s = sound;
        if (!s) {
          const { sound: newSound } = await Audio.Sound.createAsync(
            wallpaper.sound,
            { isLooping: true, volume: 1.0 }
          );
          s = newSound;
          setSound(newSound);
        }
        await s.playAsync();
        setBgmOn(true);
      } else {
        if (sound) {
          await sound.pauseAsync();
        }
        setBgmOn(false);
      }
    } catch (e) {
      console.log("BGM error:", e);
    }
  };

  // 화면 떠날 때 사운드 정리
  useEffect(() => {
    return () => {
      if (sound) {
        sound.unloadAsync();
      }
    };
  }, [sound]);

  // 오늘 작성 플로우에서 온 경우: 하드웨어/상단 뒤로 → Past(지난 일기, fromSupport:true)
  useEffect(() => {
    if (!fromTodayJournal) return;

    const goPastFromSupport = () => {
      navigation.replace("Past", { fromSupport: true });
    };

    const onBackPress = () => {
      goPastFromSupport();
      return true;
    };
    const sub = BackHandler.addEventListener("hardwareBackPress", onBackPress);

    const unsubNav = navigation.addListener("beforeRemove", (e) => {
      if (!e.data.action || e.data.action.type !== "GO_BACK") return;
      e.preventDefault();
      goPastFromSupport();
    });

    return () => {
      sub.remove();
      unsubNav();
    };
  }, [navigation, fromTodayJournal]);

  // 1~1.5초 동안만 로딩 스피너 강제 표시
  useEffect(() => {
    if (!loading) return;
    setForceShowLoading(true);
    const timer = setTimeout(() => {
      setForceShowLoading(false);
    }, 1500);
    return () => clearTimeout(timer);
  }, [loading]);

  // Support 화면에 들어오면 홈 버튼 10초 동안 서서히 진해지게 (오늘 일기 플로우에서만)
  useEffect(() => {
    if (!fromTodayJournal) {
      setHomeBtnProgress(1);
      setHomeBtnEnabled(true);
      return;
    }

    setHomeBtnProgress(0);
    setHomeBtnEnabled(false);

    let start = Date.now();
    const duration = 10000;

    const id = setInterval(() => {
      const elapsed = Date.now() - start;
      const p = Math.min(elapsed / duration, 1);
      setHomeBtnProgress(p);
      if (p >= 1) {
        setHomeBtnEnabled(true);
        clearInterval(id);
      }
    }, 100);

    return () => clearInterval(id);
  }, [fromTodayJournal]);

  // 로컬/route 메시지 + 감정 키워드 → 서버 최신 메시지 (현재 카드 기준)
  useEffect(() => {
    const { journalId: curJournalId, date: curDate, time: curTime } = currentItem;

    // 사진첩/지난 일기에서 온 경우(= fromTodayJournal 아님): 서버 호출 안 하고 로컬/route 값만 사용
    if (!fromTodayJournal) {
      (async () => {
        const local = await loadLocalSupport({
          journalId: curJournalId,
          date: curDate,
          time: curTime,
        });

        if (local.supportMessage) {
          setAiMessage(local.supportMessage);
          setError("");
        } else if (initialMessage) {
          setAiMessage(initialMessage);
          setError("");
        }

        // 감정 키워드: journals 값 우선, 없으면 currentItem.emotionKeywords/keywords 사용
        if (local.emotionKeywords && local.emotionKeywords.length > 0) {
          setEmotionKeywords(local.emotionKeywords);
        } else if (Array.isArray(currentItem.emotionKeywords)) {
          setEmotionKeywords(currentItem.emotionKeywords);
        } else if (Array.isArray(currentItem.keywords)) {
          setEmotionKeywords(currentItem.keywords);
        } else {
          setEmotionKeywords([]);
        }
      })();
      return;
    }

    // 오늘 일기 플로우: journalId, date, time, wallpaper가 준비된 뒤에만 요청
    if (!curJournalId || !curDate || !curTime || !wallpaper) return;

    const run = async () => {
      // journals 기준 supportMessage + 감정 키워드 먼저 반영
      const local = await loadLocalSupport({
        journalId: curJournalId,
        date: curDate,
        time: curTime,
      });

      if (local.supportMessage) {
        setAiMessage(local.supportMessage);
        setError("");
      } else if (initialMessage) {
        setAiMessage(initialMessage);
        setError("");
      }

      if (local.emotionKeywords && local.emotionKeywords.length > 0) {
        setEmotionKeywords(local.emotionKeywords);
      } else if (Array.isArray(currentItem.emotionKeywords)) {
        setEmotionKeywords(currentItem.emotionKeywords);
      } else if (Array.isArray(currentItem.keywords)) {
        setEmotionKeywords(currentItem.keywords);
      } else {
        setEmotionKeywords([]);
      }

      try {
        console.log("### fetchSupportMessage start", {
          journalId: curJournalId,
          date: curDate,
          time: curTime,
        });
        setLoading(true);
        setError("");

        const url = `${API_BASE}/support-message?journalId=${encodeURIComponent(
          curJournalId
        )}`;
        console.log("### GET", url);

        const res = await fetch(url);

        if (!res.ok) {
          console.log("support-message status =", res.status);
          return;
        }

        const data = await res.json();
        console.log("support-message data =", data);

        if (data && data.ok && data.message) {
          const msg = String(data.message).trim();
          console.log("### support-message ok, msg =", msg);

          setAiMessage(msg);
          setError("");

          await saveSupportToJournal({
            journalId: curJournalId,
            date: curDate,
            time: curTime,
            message: msg,
            wallpaper,
          });

          if (wallpaper) {
            await savePhotoItem({
              date: curDate,
              time: curTime,
              message: msg,
              wallpaper,
            });
          }
        } else {
          console.log("### support-message no message", data);
        }
      } catch (e) {
        console.log("support-message 조회 에러:", e);
        setError("응원 메시지를 가져오는 중 문제가 생겼어.");
      } finally {
        setLoading(false);
      }
    };

    run();
  }, [fromTodayJournal, currentItem, wallpaper, initialMessage]);

  // 중앙에 표시할 문구
  let displayText = "";
  if (loading && forceShowLoading) {
    displayText = "응원/위로글을 불러오는 중...";
  } else if (aiMessage) {
    displayText = aiMessage;
  } else if (error) {
    displayText = error;
  } else if (fromTodayJournal) {
    displayText =
      "오늘도 일기 써줘서 고마워.\n응원 문장은 서버에서 열심히 준비 중이야.\n조금 있다가 지난 일기 / 사진첩에서 확인해 볼 수 있어.";
  } else {
    displayText = "오늘도 여기까지 와 준 것만으로도 정말 잘했어요.";
  }

  const bgImage =
    currentItem.imageSource || imageSource || (wallpaper ? wallpaper.image : null);
  if (!bgImage) {
    return null;
  }

  const handlePressHome = () => {
    if (!homeBtnEnabled) return;
    navigation.reset({
      index: 0,
      routes: [{ name: "Today" }],
    });
  };

  // 상단 뒤로 버튼: 오늘 일기 플로우면 Past(fromSupport:true), 아니면 goBack
  const handleTopBack = () => {
    if (fromTodayJournal) {
      navigation.replace("Past", { fromSupport: true });
    } else {
      navigation.goBack();
    }
  };

  // 갤러리 좌우 이동 (클릭)
  const goPrev = () => {
    if (!galleryMode) return;
    setCurrentIndex((prev) => (prev > 0 ? prev - 1 : prev));
  };

  const goNext = () => {
    if (!galleryMode) return;
    setCurrentIndex((prev) =>
      prev < items.length - 1 ? prev + 1 : prev
    );
  };

  // 감정 키워드를 '#불안 #분노' 형태로
  const emotionText =
    emotionKeywords && emotionKeywords.length > 0
      ? emotionKeywords.map((k) => `#${k}`).join(" ")
      : "";

  return (
    <ImageBackground source={bgImage} style={[styles.container, styles.bgImage]}>
      {/* 상단: 뒤로 + BGM */}
      <View style={styles.topBar}>
        <TouchableOpacity onPress={handleTopBack}>
          <Ionicons name="chevron-back" size={24} color="#fff" />
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.bgmBtn, !bgmOn && { opacity: 0.4 }]}
          onPress={toggleBgm}
        >
          <Text style={styles.bgmText}>{bgmOn ? "BGM ON" : "BGM OFF"}</Text>
        </TouchableOpacity>
      </View>

      {/* 중앙 영역: 감정 키워드 + 좌우 클릭 이동 + 응원 문장 */}
      <View style={styles.centerBox}>
        {/* 감정 키워드 줄 (예: #불안 #분노) */}
        {emotionText ? (
          <View style={styles.emotionRow}>
            <Text style={styles.emotionText}>{emotionText}</Text>
          </View>
        ) : null}

        {galleryMode && (
          <View style={styles.galleryNavRow}>
            <TouchableOpacity
              style={[styles.arrowBtn, currentIndex === 0 && { opacity: 0.3 }]}
              disabled={currentIndex === 0}
              onPress={goPrev}
            >
              <Ionicons name="chevron-back" size={28} color="#fff" />
            </TouchableOpacity>

            <View style={styles.messageBox}>
              {loading && forceShowLoading && (
                <ActivityIndicator
                  size="small"
                  color="#ffffff"
                  style={{ marginBottom: 8 }}
                />
              )}
              <Text style={styles.messageText}>{displayText}</Text>
            </View>

            <TouchableOpacity
              style={[
                styles.arrowBtn,
                currentIndex === items.length - 1 && { opacity: 0.3 },
              ]}
              disabled={currentIndex === items.length - 1}
              onPress={goNext}
            >
              <Ionicons name="chevron-forward" size={28} color="#fff" />
            </TouchableOpacity>
          </View>
        )}

        {!galleryMode && (
          <View style={styles.messageBox}>
            {loading && forceShowLoading && (
              <ActivityIndicator
                size="small"
                color="#ffffff"
                style={{ marginBottom: 8 }}
              />
            )}
            <Text style={styles.messageText}>{displayText}</Text>
          </View>
        )}
      </View>

      {/* 하단 홈 버튼 */}
      <View style={styles.bottomBar}>
        <TouchableOpacity
          style={[
            styles.homeBtn,
            {
              opacity: 0.2 + 0.8 * homeBtnProgress,
            },
          ]}
          activeOpacity={homeBtnEnabled ? 0.7 : 1}
          onPress={handlePressHome}
        >
          <Text style={styles.homeText}>
            {homeBtnEnabled ? "🏠 홈으로" : "잠시만 기다려줘..."}
          </Text>
        </TouchableOpacity>
      </View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  bgImage: {
    width: "100%",
    ...(Platform.OS === "web" ? { height: "100%" } : { flex: 1 }),
  },
  topBar: {
    paddingTop: 40,
    paddingHorizontal: 16,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  bgmBtn: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: "rgba(0,0,0,0.4)",
  },
  bgmText: { color: "#fff", fontWeight: "700" },
  centerBox: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 24,
  },
  emotionRow: {
    marginBottom: 12,
  },
  emotionText: {
    color: "#ffa600ff",
    fontSize: 14,
    fontWeight: "700",
    textAlign: "center",
  },
  galleryNavRow: {
    flexDirection: "row",
    alignItems: "center",
  },
  arrowBtn: {
    padding: 12,
  },
  messageBox: {
    backgroundColor: "rgba(0,0,0,0.45)",
    borderRadius: 18,
    paddingVertical: 20,
    paddingHorizontal: 18,
    maxWidth: 420,
  },
  messageText: {
    color: "#fff",
    fontSize: 16,
    lineHeight: 24,
    textAlign: "center",
    fontWeight: "600",
  },
  bottomBar: {
    padding: 16,
    flexDirection: "row",
    justifyContent: "center",
  },
  homeBtn: {
    backgroundColor: "#1857f7ff",
    paddingVertical: 14,
    paddingHorizontal: 36,
    borderRadius: 12,
    alignItems: "center",
  },
  homeText: { color: "#fff", fontSize: 16, fontWeight: "700" },
});
