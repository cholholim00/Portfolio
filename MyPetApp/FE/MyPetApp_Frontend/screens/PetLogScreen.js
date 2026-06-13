// screens/PetLogScreen.js
import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  Alert,
  Image,
} from "react-native";
import { useNavigation, useIsFocused } from "@react-navigation/native";
import AsyncStorage from "@react-native-async-storage/async-storage";

const API_BASE = "http://10.138.31.34:4000";

// 🔹 TodayScreen 과 동일한 키로 이미지 매핑
const PET_IMAGES = {
  default: require("../assets/images/pet_default.png"),
  dog: require("../assets/images/pet_dog.png"),
  cat: require("../assets/images/pet_cat.png"),
};

const DEFAULT_PET_IMAGE_KEY = "default";

export default function PetLogScreen() {
  const navigation = useNavigation();
  const isFocused = useIsFocused();
  const [pet, setPet] = useState(null);
  const [editingName, setEditingName] = useState("");
  const [isEditing, setIsEditing] = useState(false);
  const [stats, setStats] = useState({
    totalJournals: 0,
    lastDate: null,
    lastTime: null,
    recentAvgMood: 0,
    recentCount: 0,
  });

  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.journals)) {
        await AsyncStorage.setItem(
          "journals",
          JSON.stringify(json.journals)
        );
        console.log("PetLog /journals 동기화 완료");
        recomputeStats(json.journals);
      }
    } catch (e) {
      console.log("PetLog syncJournalsFromServer 에러:", e);
    }
  };

  const recomputeStats = async (journalsFromArg = null) => {
    try {
      let list = journalsFromArg;
      if (!Array.isArray(list)) {
        const jRaw = await AsyncStorage.getItem("journals");
        list = jRaw ? JSON.parse(jRaw) : [];
      }

      const total = list.length;

      const last =
        total > 0
          ? [...list].sort(
              (a, b) =>
                new Date(b.date + " " + (b.time || "00:00")) -
                new Date(a.date + " " + (a.time || "00:00"))
            )[0]
          : null;

      const tRaw = await AsyncStorage.getItem("analysis_tests");
      const tests = tRaw ? JSON.parse(tRaw) : [];

      const now = new Date();
      const weekAgo = new Date(
        now.getTime() - 7 * 24 * 60 * 60 * 1000
      );

      const recentTests = Array.isArray(tests)
        ? tests.filter((t) => {
            if (!t.date) return false;
            const d = new Date(t.date);
            return d >= weekAgo && d <= now;
          })
        : [];

      const sumTestMood = recentTests.reduce(
        (s, t) =>
          s +
          (typeof t.moodScore === "number"
            ? t.moodScore
            : typeof t.mood === "number"
            ? t.mood
            : 0),
        0
      );

      const recentCount = recentTests.length;
      const avgMood =
        recentCount > 0 ? Math.round(sumTestMood / recentCount) : 0;

      setStats({
        totalJournals: total,
        lastDate: last?.date ?? null,
        lastTime: last?.time ?? null,
        recentAvgMood: avgMood,
        recentCount,
      });
    } catch (e) {
      console.log("recomputeStats 에러:", e);
    }
  };

  useEffect(() => {
    const load = async () => {
      const petRaw = await AsyncStorage.getItem("pet");
      const p = petRaw ? JSON.parse(petRaw) : null;
      if (p) {
        setPet({
          ...p,
          imageKey: p.imageKey || DEFAULT_PET_IMAGE_KEY,
        });
        setEditingName(p.name || "루나");
      } else {
        setPet(null);
      }

      await recomputeStats();
      syncJournalsFromServer();
    };

    if (isFocused) {
      load();
    }
  }, [isFocused]);

  const savePetName = async () => {
    if (!pet) return;
    const trimmed = editingName.trim();
    if (!trimmed) return;

    const updated = { ...pet, name: trimmed };
    setPet(updated);
    setIsEditing(false);
    await AsyncStorage.setItem("pet", JSON.stringify(updated));
  };

  const resetEmotionTests = async () => {
    try {
      await AsyncStorage.removeItem("analysis_tests");
      Alert.alert("완료", "최근 감정 테스트 기록을 초기화했어.");
      recomputeStats();
    } catch (e) {
      console.log("resetEmotionTests 에러:", e);
      Alert.alert("에러", "초기화 중 문제가 생겼어.");
    }
  };

  const resetPetState = async () => {
    try {
      const defaultPet = {
        name: "MY PET",
        xp: 0,
        level: 1,
        streak: 0,
        lastRewardDate: null,
        intimacy: 1,
        mood: "calm",
        imageKey: DEFAULT_PET_IMAGE_KEY,
      };
      await AsyncStorage.setItem("pet", JSON.stringify(defaultPet));
      setPet(defaultPet);
      setEditingName(defaultPet.name);
      Alert.alert("완료", "MY펫 상태를 초기화했어.");
    } catch (e) {
      console.log("resetPetState 에러:", e);
      Alert.alert("에러", "초기화 중 문제가 생겼어.");
    }
  };

  if (!pet) {
    return (
      <View style={styles.container}>
        <View style={styles.inner}>
          <Text style={styles.emptyText}>펫 정보가 아직 없어요.</Text>
        </View>
      </View>
    );
  }

  const petImageSource =
    PET_IMAGES[pet.imageKey] || PET_IMAGES[DEFAULT_PET_IMAGE_KEY];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.inner}>
        {/* 1. MY펫 상태 카드 */}
        <View style={styles.card}>
          <Text style={styles.sectionTitle}>MY펫 상태</Text>

          <View style={styles.petHeaderRow}>
            {/* 왼쪽: 이름/정보 */}
            <View style={{ flex: 1, marginRight: 10 }}>
              {isEditing ? (
                <>
                  <View style={styles.nameEditRow}>
                    <TextInput
                      style={styles.nameInput}
                      value={editingName}
                      onChangeText={setEditingName}
                    />
                    <TouchableOpacity
                      style={styles.nameSaveBtn}
                      onPress={savePetName}
                    >
                      <Text style={styles.nameSaveText}>저장</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={styles.nameCancelBtn}
                      onPress={() => {
                        setEditingName(pet.name || "루나");
                        setIsEditing(false);
                      }}
                    >
                      <Text style={styles.nameCancelText}>취소</Text>
                    </TouchableOpacity>
                  </View>
                </>
              ) : (
                <>
                  <View style={styles.petNameRow}>
                    <Text style={styles.petName}>{pet.name}</Text>
                    <TouchableOpacity
                      style={styles.editBtn}
                      onPress={() => setIsEditing(true)}
                    >
                      <Text style={styles.editText}>이름 수정</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}

              <Text style={styles.petMeta}>Lv. {pet.level ?? 1}</Text>
              <Text style={styles.petMeta}>XP {pet.xp ?? 0}</Text>
              <Text style={styles.petMeta}>
                연속 작성일: {pet.streak ?? 0}일
              </Text>
            </View>

            {/* 오른쪽: 펫 이미지 (여기서는 수정 불가, 터치X) */}
            <Image source={petImageSource} style={styles.petImage} />
          </View>
        </View>

        {/* 2. 최근 감정 / 활동 카드 */}
        <View className={styles.card}>
          <Text style={styles.sectionTitle}>최근 감정 / 활동</Text>
          <Text style={styles.statLabel}>
            최근 7일 감정 테스트 횟수: {stats.recentCount}회
          </Text>
          <Text style={styles.statLabel}>
            최근 7일 평균 기분 점수: {stats.recentAvgMood}점
          </Text>

          <TouchableOpacity
            style={[styles.navBtn, { marginTop: 12, backgroundColor: "#f06292" }]}
            onPress={resetEmotionTests}
          >
            <Text style={styles.navText}>최근 감정 테스트 기록 초기화</Text>
          </TouchableOpacity>
        </View>

        {/* 3. 전체 히스토리 카드 */}
        <View style={styles.card}>
          <Text style={styles.sectionTitle}>전체 히스토리</Text>
          <Text style={styles.statLabel}>
            총 작성 일기 수: {stats.totalJournals}개
          </Text>
          <Text style={styles.statLabel}>
            마지막 일기: {stats.lastDate ?? "-"} {stats.lastTime ?? ""}
          </Text>
        </View>

        <TouchableOpacity
          style={[styles.navBtn, { backgroundColor: "#ff7043" }]}
          onPress={resetPetState}
        >
          <Text style={styles.navText}>MY펫 상태 초기화</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.navBtn}
          onPress={() => navigation.navigate("Past")}
        >
          <Text style={styles.navText}>지난 일기 보러가기</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.navBtn}
          onPress={() => navigation.navigate("EmotionAnalysis")}
        >
          <Text style={styles.navText}>감정 분석 페이지로</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    padding: 20,
  },
  inner: {
    flex: 1,
  },
  card: {
    backgroundColor: "#fff",
    borderRadius: 10,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e0e0e0",
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: "700",
    color: "#333",
    marginBottom: 8,
  },

  petHeaderRow: {
    flexDirection: "row",
    alignItems: "center",
  },

  petNameRow: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 6,
  },
  petName: {
    fontSize: 18,
    fontWeight: "800",
    color: "#111",
    marginRight: 8,
  },
  editBtn: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 999,
    backgroundColor: "#e3f2fd",
  },
  editText: {
    fontSize: 11,
    fontWeight: "700",
    color: "#2457d6",
  },
  petMeta: {
    fontSize: 13,
    color: "#555",
    marginTop: 2,
  },

  petImage: {
    width: 64,
    height: 64,
    borderRadius: 32,
  },

  nameEditRow: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 8,
  },
  nameInput: {
    flex: 1,
    borderWidth: 1,
    borderColor: "#e0e0e0",
    borderRadius: 8,
    paddingHorizontal: 10,
    paddingVertical: 6,
    fontSize: 14,
    marginRight: 6,
  },
  nameSaveBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
    backgroundColor: "#4caf50",
    marginRight: 4,
  },
  nameSaveText: {
    color: "#fff",
    fontWeight: "700",
    fontSize: 12,
  },
  nameCancelBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
    backgroundColor: "#ddd",
  },
  nameCancelText: {
    color: "#555",
    fontWeight: "600",
    fontSize: 12,
  },

  statLabel: {
    fontSize: 13,
    color: "#555",
    marginTop: 2,
  },
  navBtn: {
    backgroundColor: "#2457d6",
    paddingVertical: 14,
    borderRadius: 12,
    alignItems: "center",
    marginTop: 10,
  },
  navText: {
    color: "#fff",
    fontSize: 15,
    fontWeight: "700",
  },
  emptyText: {
    marginTop: 40,
    textAlign: "center",
    color: "#777",
    fontSize: 14,
  },
});
