// screens/JournalSearchScreen.js
import React, { useEffect, useState, useMemo } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  FlatList,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useNavigation } from "@react-navigation/native";

const API_BASE = "http://10.138.31.34:4000";

const EMOTION_FILTERS = [
  { key: "", label: "전체" },
  { key: "happy", label: "😊 기쁨" },
  { key: "love", label: "💕 사랑" },
  { key: "excited", label: "🎉 설렘" },
  { key: "calm", label: "😌 평온" },
  { key: "sad", label: "😢 슬픔" },
  { key: "anger", label: "😣 화남" },
];

export default function JournalSearchScreen() {
  const navigation = useNavigation();
  const [journals, setJournals] = useState([]);
  const [keyword, setKeyword] = useState("");
  const [dateFilter, setDateFilter] = useState(""); // "YYYY-MM-DD"
  const [emotionFilter, setEmotionFilter] = useState("");

  // 🔹 서버에서 최신 journals 받아와 로컬/상태 갱신 (백그라운드)
  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.journals)) {
        await AsyncStorage.setItem("journals", JSON.stringify(json.journals));

        const sorted = json.journals.sort((a, b) => {
          const aKey = `${a.date || ""} ${a.time || "00:00"}`;
          const bKey = `${b.date || ""} ${b.time || "00:00"}`;
          return new Date(bKey) - new Date(aKey);
        });
        setJournals(sorted);
      }
    } catch (e) {
      console.log("JournalSearch syncJournalsFromServer 에러:", e);
    }
  };

  useEffect(() => {
    const load = async () => {
      try {
        // 1) 로컬에서 읽어서 최신순 정렬 → 일단 이걸로 즉시 UI 채움
        const raw = await AsyncStorage.getItem("journals");
        const list = raw ? JSON.parse(raw) : [];

        const sortedLocal = list.sort((a, b) => {
          const aKey = `${a.date || ""} ${a.time || "00:00"}`;
          const bKey = `${b.date || ""} ${b.time || "00:00"}`;
          return new Date(bKey) - new Date(aKey);
        });

        setJournals(sortedLocal);

        // 2) 백그라운드에서 서버 최신값 받아서 로컬/상태 덮어쓰기
        syncJournalsFromServer();
      } catch (e) {
        console.log("JournalSearch load 에러:", e);
        setJournals([]);
      }
    };

    load();
  }, []);

  const filtered = useMemo(() => {
    return journals.filter((j) => {
      // 키워드 필터
      if (keyword.trim()) {
        const lower = keyword.toLowerCase();
        const body = (j.text || "").toLowerCase();
        if (!body.includes(lower)) return false;
      }

      // 날짜 필터 (정확히 같은 날짜만)
      if (dateFilter.trim()) {
        if (j.date !== dateFilter.trim()) return false;
      }

      // 감정 태그 필터
      if (emotionFilter) {
        const emo = j.emotions || {};
        if (!emo[emotionFilter]) return false;
      }

      return true;
    });
  }, [journals, keyword, dateFilter, emotionFilter]);

  const renderItem = ({ item }) => (
    <TouchableOpacity
      style={styles.card}
      onPress={() =>
        navigation.navigate("JournalDetail", {
          journal: item,
          allJournals: journals,
        })
      }
    >
      <Text style={styles.cardDate}>
        {item.date} {item.time || ""}
      </Text>
      <Text style={styles.cardPreview} numberOfLines={2}>
        {item.text}
      </Text>
      <Text style={styles.cardMeta}>
        기분 {item.mood ?? 0}점 · XP +{item.xp ?? 0}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      {/* 검색 영역 */}
      <View style={styles.searchBox}>
        <Text style={styles.label}>키워드 검색</Text>
        <TextInput
          style={styles.input}
          value={keyword}
          onChangeText={setKeyword}
          placeholder="내용으로 검색..."
        />

        <Text style={[styles.label, { marginTop: 16 }]}>
          날짜 (YYYY-MM-DD)
        </Text>
        <TextInput
          style={styles.input}
          value={dateFilter}
          onChangeText={setDateFilter}
          placeholder="예: 2025-12-04"
        />

        <Text style={[styles.label, { marginTop: 16 }]}>감정 태그</Text>
        <View style={styles.emotionRow}>
          {EMOTION_FILTERS.map((e) => (
            <TouchableOpacity
              key={e.key || "all"}
              style={[
                styles.emotionChip,
                emotionFilter === e.key && styles.emotionChipActive,
              ]}
              onPress={() => setEmotionFilter(e.key)}
            >
              <Text
                style={[
                  styles.emotionChipText,
                  emotionFilter === e.key && styles.emotionChipTextActive,
                ]}
              >
                {e.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        <TouchableOpacity
          style={styles.clearBtn}
          onPress={() => {
            setKeyword("");
            setDateFilter("");
            setEmotionFilter("");
          }}
        >
          <Text style={styles.clearText}>필터 초기화</Text>
        </TouchableOpacity>
      </View>

      {/* 결과 리스트 */}
      <FlatList
        data={filtered}
        keyExtractor={(item) => String(item.id)}
        renderItem={renderItem}
        contentContainerStyle={styles.list}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={styles.emptyText}>조건에 맞는 일기가 없습니다.</Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5f5f5" },
  searchBox: {
    padding: 16,
    backgroundColor: "#fff",
    margin: 12,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  label: {
    fontSize: 14,
    fontWeight: "600",
    color: "#333",
    marginBottom: 6,
  },
  input: {
    backgroundColor: "#fafafa",
    borderRadius: 10,
    borderWidth: 1,
    borderColor: "#ddd",
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 14,
  },
  emotionRow: {
    flexDirection: "row",
    flexWrap: "wrap",
    marginTop: 4,
  },
  emotionChip: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: "#ddd",
    marginRight: 6,
    marginTop: 6,
    backgroundColor: "#fafafa",
  },
  emotionChipActive: {
    backgroundColor: "#2457d6",
    borderColor: "#1a3fa0",
  },
  emotionChipText: {
    fontSize: 12,
    color: "#555",
    fontWeight: "500",
  },
  emotionChipTextActive: {
    color: "#fff",
    fontWeight: "700",
  },
  clearBtn: {
    marginTop: 12,
    alignSelf: "flex-end",
  },
  clearText: {
    fontSize: 12,
    color: "#888",
    textDecorationLine: "underline",
  },
  list: {
    paddingHorizontal: 12,
    paddingBottom: 20,
  },
  card: {
    backgroundColor: "#fff",
    borderRadius: 14,
    padding: 14,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  cardDate: {
    fontSize: 12,
    color: "#777",
    marginBottom: 4,
  },
  cardPreview: {
    fontSize: 14,
    color: "#333",
    marginBottom: 6,
  },
  cardMeta: {
    fontSize: 12,
    color: "#555",
  },
  empty: {
    paddingTop: 40,
    alignItems: "center",
  },
  emptyText: {
    color: "#777",
  },
});
