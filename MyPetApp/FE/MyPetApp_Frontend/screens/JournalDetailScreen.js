// screens/JournalDetailScreen.js
import React, { useState, useMemo, useEffect } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Platform,
  ImageBackground,
  useWindowDimensions,
} from "react-native";
import { useRoute, useNavigation } from "@react-navigation/native";
import AsyncStorage from "@react-native-async-storage/async-storage";


const API_BASE = "http://10.138.31.34:4000";


// wallpaper id → require 매핑 (SupportScreen과 동일 id 사용)
const WALLPAPER_IMAGES = {
  1: require("../wallpaper/0/1.jpg"),
  2: require("../wallpaper/0/2.jpg"),
  3: require("../wallpaper/0/3.jpg"),
  4: require("../wallpaper/0/4.jpg"),
  5: require("../wallpaper/0/5.jpg"),
  6: require("../wallpaper/1/6.jpg"),
  7: require("../wallpaper/1/7.jpg"),
  8: require("../wallpaper/1/8.jpg"),
  9: require("../wallpaper/1/9.jpg"),
  10: require("../wallpaper/1/10.jpg"),
};


// 날짜 유틸
const getTodayLocalDate = () => {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
};


export default function JournalDetailScreen() {
  const route = useRoute();
  const navigation = useNavigation();
  const { width: screenWidth } = useWindowDimensions();
  const { journal: initialJournal, allJournals } = route.params;


  // 항상 최신 내용을 쓰기 위해 journal을 state로 관리
  const [journal, setJournal] = useState(initialJournal);
  const [text, setText] = useState(initialJournal.text);
  const [showEditButtons, setShowEditButtons] = useState(false);


  // 마운트 시 / 포커스 시 최신 journals에서 다시 찾아오기 (로컬 기준)
  useEffect(() => {
    const syncJournal = async () => {
      try {
        const raw = await AsyncStorage.getItem("journals");
        const list = raw ? JSON.parse(raw) : [];
        const fresh = list.find(
          (j) => String(j.id) === String(initialJournal.id)
        );
        if (fresh) {
          setJournal(fresh);
          setText(fresh.text);
        }
      } catch (e) {
        console.log("JournalDetail sync error", e);
      }
    };


    syncJournal();


    const unsubscribe = navigation.addListener("focus", syncJournal);
    return unsubscribe;
  }, [initialJournal.id, navigation]);


  const supportMessage = journal.supportMessage ?? null;


  // 응원 카드용 이미지 선택 (supportImage / supportImageId 기준)
  const getSupportImageSource = () => {
    if (journal.supportImage === "wallpaper" && journal.supportImageId) {
      const img = WALLPAPER_IMAGES[journal.supportImageId];
      if (img) return img;
    }
    return null;
  };


  const { hasPrev, hasNext, prevJournal, nextJournal } = useMemo(() => {
    if (!Array.isArray(allJournals)) {
      return {
        hasPrev: false,
        hasNext: false,
        prevJournal: null,
        nextJournal: null,
      };
    }
    const idx = allJournals.findIndex(
      (j) => String(j.id) === String(journal.id)
    );
    if (idx === -1) {
      return {
        hasPrev: false,
        hasNext: false,
        prevJournal: null,
        nextJournal: null,
      };
    }
    return {
      hasPrev: idx > 0,
      hasNext: idx < allJournals.length - 1,
      prevJournal: idx > 0 ? allJournals[idx - 1] : null,
      nextJournal: idx < allJournals.length - 1 ? allJournals[idx + 1] : null,
    };
  }, [allJournals, journal]);


  // 저장: 로컬 먼저 업데이트 후 서버에 동기화
  const handleSave = async () => {
    try {
      const saved = await AsyncStorage.getItem("journals");
      const list = saved ? JSON.parse(saved) : [];


      const today = getTodayLocalDate();
      const isToday = journal.date === today;


      let newTime = journal.time ?? null;
      if (isToday) {
        const now = new Date();
        newTime = now.toTimeString().slice(0, 5);
      }


      const updatedList = list.map((j) =>
        String(j.id) === String(journal.id)
          ? { ...j, text, length: text.length, time: newTime }
          : j
      );


      // 1) 로컬 덮어쓰기
      await AsyncStorage.setItem("journals", JSON.stringify(updatedList));


      // 2) 서버에 journals 동기화 (실패해도 UI는 로컬 기준으로 유지)
      (async () => {
        try {
          const res = await fetch(`${API_BASE}/journals`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ journals: updatedList }),
          });
          const json = await res.json();
          console.log("Detail SAVE /journals ok =", json.ok);
        } catch (e) {
          console.log("Detail SAVE /journals 서버 동기화 에러:", e);
        }
      })();


      const updatedJournal = {
        ...journal,
        text,
        length: text.length,
        time: newTime,
      };


      const updatedAll = allJournals.map((j) =>
        String(j.id) === String(journal.id) ? updatedJournal : j
      );


      setJournal(updatedJournal);
      setShowEditButtons(false);


      navigation.replace("JournalDetail", {
        journal: updatedJournal,
        allJournals: updatedAll,
      });
    } catch (e) {
      console.log("handleSave error", e);
    }
  };


  // 삭제: 로컬에서 제거 후 서버에 동기화
  const handleDelete = async () => {
    try {
      if (Platform.OS === "web") {
        const ok = window.confirm("정말 이 일기를 삭제할까요?");
        if (!ok) return;
      }


      const saved = await AsyncStorage.getItem("journals");
      const list = saved ? JSON.parse(saved) : [];
      const filtered = list.filter(
        (j) => String(j.id) !== String(journal.id)
      );
      // 1) 로컬 덮어쓰기
      await AsyncStorage.setItem("journals", JSON.stringify(filtered));


      // 2) 서버에도 journals 동기화 (실패해도 화면은 바로 goBack)
      (async () => {
        try {
          const res = await fetch(`${API_BASE}/journals`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ journals: filtered }),
          });
          const json = await res.json();
          console.log("Detail DELETE /journals ok =", json.ok);
        } catch (e) {
          console.log("Detail DELETE /journals 서버 동기화 에러:", e);
        }
      })();


      navigation.goBack();
    } catch (e) {
      console.log("handleDelete error", e);
    }
  };


  const goToPrev = () => {
    if (!prevJournal) return;
    navigation.replace("JournalDetail", {
      journal: prevJournal,
      allJournals,
    });
  };


  const goToNext = () => {
    if (!nextJournal) return;
    navigation.replace("JournalDetail", {
      journal: nextJournal,
      allJournals,
    });
  };


  const onlyOneJournal = Array.isArray(allJournals) && allJournals.length === 1;


  const supportBg = getSupportImageSource();


  // 카드 최대 폭: 화면 폭의 90% 이면서 최대 480px 정도로 제한 (16:9 비율용)
  const cardMaxWidth = Math.min(screenWidth * 0.9, 480);
  const cardHeight = (cardMaxWidth * 9) / 16; // 16:9 비율로 고정


  return (
    <View style={styles.container}>
      {/* 상단 날짜/메타 */}
      <View style={styles.headerBox}>
        <Text style={styles.dateText}>
          {journal.date} {journal.time}
        </Text>
        <Text style={styles.metaText}>
          글자수 {journal.length ?? journal.text.length} · 기분{" "}
          {journal.mood ?? 0} · XP {journal.xp ?? 0}
        </Text>
      </View>


      {/* 본문 편집 */}
      <View style={styles.editorBox}>
        <Text style={styles.label}>일기 내용</Text>
        <ScrollView style={{ maxHeight: 320 }}>
          <TextInput
            style={styles.input}
            multiline
            textAlignVertical="top"
            value={text}
            onChangeText={setText}
            maxLength={2000}
            onFocus={() => setShowEditButtons(true)}
          />
        </ScrollView>
        <Text style={styles.charCount}>{text.length}자</Text>
      </View>


      {/* 응원/위로 메시지 박스 */}
      <View style={styles.supportBox}>
        <Text style={styles.supportTitle}>AI 응원 / 위로</Text>


        {/* 중앙 정렬 + 16:9 비율 카드 */}
        <View style={styles.supportImageOuter}>
          <View
            style={[
              styles.supportImageWrapper,
              { width: cardMaxWidth, height: cardHeight },
            ]}
          >
            {supportBg ? (
              <ImageBackground
                source={supportBg}
                style={styles.supportImage}
                imageStyle={{ borderRadius: 12 }}
                resizeMode="cover"
              >
                <View style={styles.supportOverlay}>
                  <Text style={styles.supportText}>
                    {supportMessage
                      ? supportMessage
                      : "아직 AI 응원 메시지가 없어요.\n오늘 일기를 쓰고 응원을 받아보세요."}
                  </Text>
                </View>
              </ImageBackground>
            ) : (
              <View
                style={[
                  styles.supportImage,
                  { backgroundColor: "#333", borderRadius: 12 },
                ]}
              >
                <View style={styles.supportOverlay}>
                  <Text style={styles.supportText}>
                    {supportMessage
                      ? supportMessage
                      : "아직 AI 응원 메시지가 없어요.\n오늘 일기를 쓰고 응원을 받아보세요."}
                  </Text>
                </View>
              </View>
            )}
          </View>
        </View>
      </View>


      {/* 저장/삭제 버튼 */}
      {showEditButtons && (
        <View style={styles.buttonRow}>
          <TouchableOpacity style={styles.saveBtn} onPress={handleSave}>
            <Text style={styles.saveText}>저장</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.deleteBtn} onPress={handleDelete}>
            <Text style={styles.deleteText}>삭제</Text>
          </TouchableOpacity>
        </View>
      )}


      {/* 이전/다음 또는 홈 버튼 */}
      {!showEditButtons && (
        <View style={styles.navRow}>
          {onlyOneJournal ? (
            <TouchableOpacity
              style={styles.navBtn}
              onPress={() =>
                navigation.reset({
                  index: 0,
                  routes: [{ name: "Today" }],
                })
              }
            >
              <Text style={styles.navText}>🏠 홈으로</Text>
            </TouchableOpacity>
          ) : (
            <>
              <TouchableOpacity
                style={[styles.navBtn, !hasPrev && styles.navBtnDisabled]}
                onPress={goToPrev}
                disabled={!hasPrev}
              >
                <Text
                  style={[
                    styles.navText,
                    !hasPrev && { color: "#aaa" },
                  ]}
                >
                  이전 일기
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.navBtn, !hasNext && styles.navBtnDisabled]}
                onPress={goToNext}
                disabled={!hasNext}
              >
                <Text
                  style={[
                    styles.navText,
                    !hasNext && { color: "#aaa" },
                  ]}
                >
                  다음 일기
                </Text>
              </TouchableOpacity>
            </>
          )}
        </View>
      )}
    </View>
  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    padding: 16,
  },
  headerBox: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 14,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  dateText: {
    fontSize: 14,
    color: "#555",
    marginBottom: 4,
  },
  metaText: {
    fontSize: 13,
    color: "#777",
  },
  editorBox: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 14,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  label: {
    fontSize: 14,
    fontWeight: "700",
    color: "#333",
    marginBottom: 6,
  },
  input: {
    fontSize: 15,
    minHeight: 200,
    padding: 10,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: "#e0e0e0",
    backgroundColor: "#fafafa",
  },
  charCount: {
    marginTop: 6,
    fontSize: 12,
    color: "#999",
    textAlign: "right",
  },
  supportBox: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 14,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  supportTitle: {
    fontSize: 14,
    fontWeight: "700",
    color: "#333",
    marginBottom: 8,
  },
  // 전체 카드 중앙 정렬용 래퍼
  supportImageOuter: {
    alignItems: "center",
    justifyContent: "center",
  },
  // 카드 자체 스타일 (폭/높이는 컴포넌트에서 동적으로 주입)
  supportImageWrapper: {
    borderRadius: 12,
    overflow: "hidden",
  },
  supportImage: {
    width: "100%",
    height: "100%",
    justifyContent: "center",
    alignItems: "center",
    ...(Platform.OS === "web" ? { alignSelf: "stretch" } : {}),
  },
  supportOverlay: {
    backgroundColor: "rgba(0,0,0,0.35)",
    padding: 12,
    width: "100%",
  },
  supportText: {
    color: "#fff",
    fontSize: 14,
    lineHeight: 20,
    textAlign: "center",
    fontWeight: "600",
  },
  buttonRow: {
    flexDirection: "row",
    marginTop: 8,
  },
  saveBtn: {
    flex: 1,
    backgroundColor: "#4caf50",
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: "center",
    marginRight: 6,
  },
  saveText: {
    color: "#fff",
    fontSize: 14,
    fontWeight: "700",
  },
  deleteBtn: {
    flex: 1,
    backgroundColor: "#f44336",
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: "center",
    marginLeft: 6,
  },
  deleteText: {
    color: "#fff",
    fontSize: 14,
    fontWeight: "700",
  },
  navRow: {
    flexDirection: "row",
    marginTop: 12,
  },
  navBtn: {
    flex: 1,
    backgroundColor: "#2457d6",
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: "center",
    marginHorizontal: 4,
  },
  navBtnDisabled: {
    backgroundColor: "#e0e0e0",
  },
  navText: {
    color: "#fff",
    fontSize: 14,
    fontWeight: "700",
  },
});