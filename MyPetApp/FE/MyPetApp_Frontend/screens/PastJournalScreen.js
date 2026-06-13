// screens/PastJournalScreen.js
import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  Platform,
  Alert,
  TouchableOpacity,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useNavigation, useRoute } from "@react-navigation/native";
import JournalCard from "../components/JournalCard";


const API_BASE = "http://10.138.31.34:4000";


// 이미지 이모티콘 매핑
const MOOD_ICONS = {
  veryPositive: require("../assets/emojis/very_positive.png"), // 🤩
  positive: require("../assets/emojis/positive.png"), // 😊
  slightPositive: require("../assets/emojis/slight_positive.png"), // 🙂
  neutral: require("../assets/emojis/neutral.png"), // 😐
  strongNegative: require("../assets/emojis/strong_negative.png"), // 😭
  negative: require("../assets/emojis/negative.png"), // 😢
  weakNegative: require("../assets/emojis/weak_negative.png"), // 😟
};


export default function PastJournalScreen() {
  const navigation = useNavigation();
  const route = useRoute();
  const fromSupport = route.params?.fromSupport ?? false; // Support에서 왔는지 플래그


  const [journals, setJournals] = useState([]);


  // 다중 선택 모드
  const [selectMode, setSelectMode] = useState(false);
  const [selectedIds, setSelectedIds] = useState([]); // String(id) 배열


  const getMoodIcon = (j) => {
    const mood = j.mood ?? 0;


    if (mood >= 70) return MOOD_ICONS.veryPositive;
    if (mood >= 50) return MOOD_ICONS.positive;
    if (mood >= 40) return MOOD_ICONS.slightPositive;
    if (mood === 0) return MOOD_ICONS.neutral;
    if (mood < 36 && mood > 10) return MOOD_ICONS.strongNegative;
    if (mood === 10) return MOOD_ICONS.negative;
    return MOOD_ICONS.weakNegative;
  };


  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.journals)) {
        await AsyncStorage.setItem("journals", JSON.stringify(json.journals));
        const sorted = [...json.journals].sort(
          (a, b) =>
            new Date(b.date + " " + (b.time || "00:00")) -
            new Date(a.date + " " + (a.time || "00:00"))
        );
        setJournals(sorted);
      }
    } catch (e) {
      console.log("syncJournalsFromServer 에러:", e);
    }
  };


  useEffect(() => {
    const load = async () => {
      try {
        const raw = await AsyncStorage.getItem("journals");
        const list = raw ? JSON.parse(raw) : [];


        const sortedLocal = [...list].sort(
          (a, b) =>
            new Date(b.date + " " + (b.time || "00:00")) -
            new Date(a.date + " " + (a.time || "00:00"))
        );


        setJournals(sortedLocal);
        setSelectedIds([]);
        setSelectMode(false);


        syncJournalsFromServer();
      } catch (e) {
        console.log("지난 일기 로드 에러:", e);
        setJournals([]);
      }
    };


    const unsub = navigation.addListener("focus", load);
    return unsub;
  }, [navigation]);


  // 단일 삭제
  const handleDeleteSingle = (journal) => {
    const doDelete = async () => {
      try {
        const rawJ = await AsyncStorage.getItem("journals");
        const list = rawJ ? JSON.parse(rawJ) : [];
        const filtered = list.filter(
          (j) => String(j.id) !== String(journal.id)
        );
        await AsyncStorage.setItem("journals", JSON.stringify(filtered));


        (async () => {
          try {
            const res = await fetch(`${API_BASE}/journals`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ journals: filtered }),
            });
            const json = await res.json();
            console.log("DELETE /journals ok =", json.ok);
          } catch (e) {
            console.log("DELETE /journals 서버 동기화 에러:", e);
          }
        })();


        const rawP = await AsyncStorage.getItem("photo_items");
        const photos = rawP ? JSON.parse(rawP) : [];
        const cleanedPhotos = photos.filter(
          (p) =>
            !(
              p.date === journal.date &&
              (p.time || "") === (journal.time || "")
            )
        );
        await AsyncStorage.setItem(
          "photo_items",
          JSON.stringify(cleanedPhotos)
        );


        (async () => {
          try {
            const res2 = await fetch(`${API_BASE}/photo-items`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ items: cleanedPhotos }),
            });
            const json2 = await res2.json();
            console.log("DELETE /photo-items ok =", json2.ok);
          } catch (e) {
            console.log("DELETE /photo-items 서버 동기화 에러:", e);
          }
        })();


        setJournals(filtered);
      } catch (e) {
        console.log("일기 삭제 에러:", e);
      }
    };


    if (Platform.OS === "web") {
      const ok = window.confirm("정말로 삭제하시겠습니까?");
      if (ok) doDelete();
    } else {
      Alert.alert("삭제 확인", "정말로 삭제하시겠습니까?", [
        { text: "취소", style: "cancel" },
        { text: "삭제", style: "destructive", onPress: doDelete },
      ]);
    }
  };


  // 선택 토글
  const toggleSelect = (id) => {
    const key = String(id);
    setSelectedIds((prev) =>
      prev.includes(key) ? prev.filter((v) => v !== key) : [...prev, key]
    );
  };


  // 전체 선택/해제
  const toggleSelectAll = () => {
    if (selectedIds.length === journals.length) {
      setSelectedIds([]);
    } else {
      setSelectedIds(journals.map((j) => String(j.id)));
    }
  };


  // 선택된 여러 개 한 번에 삭제
  const handleDeleteSelected = () => {
    if (selectedIds.length === 0) return;


    const doDelete = async () => {
      try {
        const rawJ = await AsyncStorage.getItem("journals");
        const list = rawJ ? JSON.parse(rawJ) : [];


        const filtered = list.filter(
          (j) => !selectedIds.includes(String(j.id))
        );
        await AsyncStorage.setItem("journals", JSON.stringify(filtered));


        (async () => {
          try {
            const res = await fetch(`${API_BASE}/journals`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ journals: filtered }),
            });
            const json = await res.json();
            console.log("BULK DELETE /journals ok =", json.ok);
          } catch (e) {
            console.log("BULK DELETE /journals 서버 동기화 에러:", e);
          }
        })();


        const rawP = await AsyncStorage.getItem("photo_items");
        const photos = rawP ? JSON.parse(rawP) : [];
        const cleanedPhotos = photos.filter((p) => {
          return !list.some(
            (j) =>
              selectedIds.includes(String(j.id)) &&
              p.date === j.date &&
              (p.time || "") === (j.time || "")
          );
        });
        await AsyncStorage.setItem(
          "photo_items",
          JSON.stringify(cleanedPhotos)
        );


        (async () => {
          try {
            const res2 = await fetch(`${API_BASE}/photo-items`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ items: cleanedPhotos }),
            });
            const json2 = await res2.json();
            console.log("BULK DELETE /photo-items ok =", json2.ok);
          } catch (e) {
            console.log("BULK DELETE /photo-items 서버 동기화 에러:", e);
          }
        })();


        setJournals(filtered);
        setSelectedIds([]);
        setSelectMode(false);
      } catch (e) {
        console.log("다중 일기 삭제 에러:", e);
      }
    };


    if (Platform.OS === "web") {
      const ok = window.confirm(
        `${selectedIds.length}개의 일기를 정말로 삭제하시겠습니까?`
      );
      if (ok) doDelete();
    } else {
      Alert.alert(
        "여러 일기 삭제",
        `${selectedIds.length}개의 일기를 정말로 삭제하시겠습니까?`,
        [
          { text: "취소", style: "cancel" },
          { text: "삭제", style: "destructive", onPress: doDelete },
        ]
      );
    }
  };


  const renderItem = ({ item }) => {
    const idKey = String(item.id);
    const selected = selectedIds.includes(idKey);


    return (
      <JournalCard
        date={item.date}
        time={item.time}
        score={item.score}
        mood={item.mood}
        xp={item.xp}
        moodIcon={getMoodIcon(item)}
        onDelete={() => handleDeleteSingle(item)}
        onPress={() =>
          selectMode
            ? toggleSelect(idKey)
            : navigation.navigate("JournalDetail", {
                journal: item,
                allJournals: journals,
              })
        }
        selectable={selectMode}
        selected={selected}
      />
    );
  };


  // 🔹 뒤로가기 동작: fromSupport 면 홈으로, 아니면 기본 goBack
  const handleBack = () => {
    if (fromSupport) {
      navigation.reset({
        index: 0,
        routes: [{ name: "Today" }],
      });
    } else {
      navigation.goBack();
    }
  };


  return (
    <View style={styles.container}>
      {/* 상단 바: 뒤로가기 + 선택/삭제 + 개수 */}
      <View style={styles.topBar}>



        <Text style={styles.countText}>지난 일기 {journals.length}개</Text>


        <View style={styles.topBarRight}>
          <TouchableOpacity
            style={[
              styles.modeBtn,
              selectMode && { backgroundColor: "#1976d2" },
            ]}
            onPress={() => {
              setSelectMode((v) => !v);
              setSelectedIds([]);
            }}
          >
            <Text
              style={[styles.modeBtnText, selectMode && { color: "#fff" }]}
            >
              {selectMode ? "선택 해제" : "여러 개 선택"}
            </Text>
          </TouchableOpacity>


          {selectMode && (
            <>
              <TouchableOpacity
                style={styles.smallBtn}
                onPress={toggleSelectAll}
              >
                <Text style={styles.smallBtnText}>
                  {selectedIds.length === journals.length
                    ? "전체 해제"
                    : "전체 선택"}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[
                  styles.smallBtn,
                  selectedIds.length === 0 && { backgroundColor: "#ccc" },
                ]}
                onPress={handleDeleteSelected}
                disabled={selectedIds.length === 0}
              >
                <Text style={styles.smallBtnText}>선택 삭제</Text>
              </TouchableOpacity>
            </>
          )}
        </View>
      </View>


      {journals.length === 0 ? (
        <View style={styles.emptyBox}>
          <Text style={styles.emptyText}>아직 작성한 일기가 없어요.</Text>
        </View>
      ) : (
        <FlatList
          data={journals}
          keyExtractor={(item) => String(item.id)}
          renderItem={renderItem}
          contentContainerStyle={styles.list}
        />
      )}
    </View>
  );
}


const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5f5f5" },
  list: { padding: 16 },
  emptyBox: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingVertical: 60,
  },
  emptyText: {
    fontSize: 16,
    fontWeight: "600",
    color: "#666",
    textAlign: "center",
  },
  topBar: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 16,
    paddingTop: 10,
    paddingBottom: 4,
    justifyContent: "space-between",
  },
  backBtn: {
    paddingVertical: 4,
    paddingRight: 8,
    paddingLeft: 0,
  },
  topBarRight: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },
  countText: {
    fontSize: 14,
    fontWeight: "600",
    color: "#555",
  },
  modeBtn: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#1976d2",
    backgroundColor: "#e3f2fd",
  },
  modeBtnText: {
    fontSize: 13,
    fontWeight: "700",
    color: "#1976d2",
  },
  smallBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
    backgroundColor: "#ff5252",
    marginLeft: 6,
  },
  smallBtnText: {
    fontSize: 12,
    fontWeight: "700",
    color: "#fff",
  },
});