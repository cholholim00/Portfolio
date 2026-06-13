// screens/TodayScreen.js
import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Alert,
  Image,
  Modal,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useIsFocused } from "@react-navigation/native";

const API_BASE = "http://10.138.31.34:4000";

// 🔹 펫 이미지들 (예시: 기본/강아지/고양이)
const PET_IMAGES = {
  default: require("../assets/images/pet_default.png"),
  dog: require("../assets/images/pet_dog.png"),
  cat: require("../assets/images/pet_cat.png"),
};

// 기본 키
const DEFAULT_PET_IMAGE_KEY = "default";

const getTodayLocalDate = () => {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
};

const showTodayTimeCapsuleOnce = async (navigation) => {
  try {
    const today = getTodayLocalDate();
    const lastShown = await AsyncStorage.getItem("lastTimeCapsuleShownDate");
    if (lastShown === today) return;

    const raw = await AsyncStorage.getItem("time_capsules");
    const list = raw ? JSON.parse(raw) : [];
    if (!Array.isArray(list) || list.length === 0) return;

    const candidates = list.filter((c) => c.openDate === today);
    if (candidates.length === 0) return;

    const picked =
      candidates[Math.floor(Math.random() * candidates.length)];

    Alert.alert(
      "과거의 나에게서 온 편지",
      picked.body || "그때의 내가 지금의 나에게 보내는 응원 편지야.",
      [
        {
          text: "닫기",
          style: "default",
          onPress: async () => {
            await AsyncStorage.setItem(
              "lastTimeCapsuleShownDate",
              today
            );
          },
        },
      ]
    );
  } catch (e) {
    console.log("Time Capsule 팝업 에러:", e);
  }
};

// 영어 mood → 한글 라벨 매핑
const moodLabelMap = {
  calm: "차분함",
  happy: "행복함",
  sad: "슬픔",
  angry: "화남",
  anxious: "불안함",
  love: "애정 가득",
  tired: "피곤함",
};

// 🔹 journals 배열로부터 연속 작성일(streak) 계산
const calcStreakFromJournals = (journals) => {
  if (!Array.isArray(journals) || journals.length === 0) return 0;

  const todayStr = getTodayLocalDate();
  const datesSet = new Set(journals.map((j) => j.date));

  let count = 0;
  let current = new Date(todayStr);

  while (true) {
    const y = current.getFullYear();
    const m = String(current.getMonth() + 1).padStart(2, "0");
    const d = String(current.getDate()).padStart(2, "0");
    const key = `${y}-${m}-${d}`;

    if (datesSet.has(key)) {
      count += 1;
      current.setDate(current.getDate() - 1);
    } else {
      break;
    }
  }

  const streak = Math.max(0, count - 1);
  return streak;
};

export default function TodayScreen({ navigation }) {
  const isFocused = useIsFocused();
  const [pet, setPet] = useState({
    name: "MY PET",
    level: 1,
    xp: 0,
    maxXp: 100,
    intimacy: 1,
    mood: "calm",
    streak: 0,
    imageKey: DEFAULT_PET_IMAGE_KEY,
  });

  // 🔹 펫 이미지 선택 모달 상태
  const [showPetModal, setShowPetModal] = useState(false);

  // 서버에서 최신 pet 받아와 로컬/상태 갱신 (백그라운드)
  const syncPetFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/pet`);

      if (!res.ok) {
        console.log("syncPetFromServer status =", res.status);
        const text = await res.text();
        console.log("syncPetFromServer body =", text.slice(0, 200));
        return;
      }

      const json = await res.json();
      console.log("syncPetFromServer data =", json);

      if (json.ok && json.pet) {
        // 서버 pet 에 imageKey가 없을 수 있으니 기본값 보정
        const mergedPet = {
          ...json.pet,
          maxXp: json.pet.maxXp ?? 100,
          imageKey: json.pet.imageKey || DEFAULT_PET_IMAGE_KEY,
        };

        await AsyncStorage.setItem("pet", JSON.stringify(mergedPet));
        setPet((prev) => ({
          ...prev,
          ...mergedPet,
        }));
      }
    } catch (e) {
      console.log("TodayScreen syncPetFromServer 에러:", e);
    }
  };

  // 홈에 들어올 때마다: 1) 로컬 먼저 2) 서버는 백그라운드
  useEffect(() => {
    const loadPet = async () => {
      try {
        const savedPet = await AsyncStorage.getItem("pet");
        let petObj = savedPet ? JSON.parse(savedPet) : null;

        const rawJ = await AsyncStorage.getItem("journals");
        const journals = rawJ ? JSON.parse(rawJ) : [];
        const streak = calcStreakFromJournals(journals);

        if (!petObj) {
          petObj = {
            name: "MY PET",
            level: 1,
            xp: 0,
            maxXp: 100,
            intimacy: 1,
            mood: "calm",
            imageKey: DEFAULT_PET_IMAGE_KEY,
          };
        }

        const mergedPet = {
          ...petObj,
          streak,
          maxXp: petObj.maxXp ?? 100,
          imageKey: petObj.imageKey || DEFAULT_PET_IMAGE_KEY,
        };

        await AsyncStorage.setItem("pet", JSON.stringify(mergedPet));

        setPet((prev) => ({
          ...prev,
          ...mergedPet,
        }));

        syncPetFromServer();
      } catch (e) {
        console.log("TodayScreen pet 로드 에러:", e);
      }
    };

    if (isFocused) {
      loadPet();
      showTodayTimeCapsuleOnce(navigation);
    }
  }, [isFocused, navigation]);

  const moodLabel = moodLabelMap[pet.mood] || "기분 정보 없음";

  // 🔹 현재 pet.imageKey 에 맞는 이미지 소스
  const currentPetImageSource =
    PET_IMAGES[pet.imageKey] || PET_IMAGES[DEFAULT_PET_IMAGE_KEY];

  // 🔹 펫 이미지 선택 처리
  const handleSelectPetImage = async (key) => {
    try {
      const newPet = {
        ...pet,
        imageKey: key,
      };
      setPet(newPet);
      await AsyncStorage.setItem("pet", JSON.stringify(newPet));
      setShowPetModal(false);
    } catch (e) {
      console.log("펫 이미지 변경 에러:", e);
      setShowPetModal(false);
    }
  };

  return (
    <View style={styles.container}>
      {/* 펫 카드 */}
      <View style={styles.petBox}>
        <View style={styles.petInfoArea}>
          <Text style={styles.petName}>{pet.name}</Text>
          <Text>
            레벨 {pet.level} ( XP {pet.xp}/{pet.maxXp} )
          </Text>
          <Text>친밀도 {pet.intimacy}/5</Text>
          <Text>기분: {moodLabel}</Text>
        </View>

        {/* 🔹 펫 이미지: 터치 시 모달 오픈 */}
        <TouchableOpacity onPress={() => setShowPetModal(true)}>
          <Image source={currentPetImageSource} style={styles.petImage} />
        </TouchableOpacity>
      </View>

      <Text style={styles.streak}>연속 작성: {pet.streak ?? 0}일</Text>

      <TouchableOpacity
        style={styles.writeBtn}
        onPress={() => navigation.navigate("TodayJournal")}
      >
        <Text style={styles.writeText}>오늘의 일기 쓰기</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.menuBtn}
        onPress={() => navigation.navigate("Past")}
      >
        <Text style={styles.menuText}>지난 일기 보기</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.menuBtn}
        onPress={() => navigation.navigate("Calendar")}
      >
        <Text style={styles.menuText}>달력 보기</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.menuBtn}
        onPress={() => navigation.navigate("PhotoGallery")}
      >
        <Text style={styles.menuText}>사진첩 보기</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.menuBtn}
        onPress={() => navigation.navigate("PetLog")}
      >
        <Text style={styles.menuText}>펫 로그 보기</Text>
      </TouchableOpacity>

      {/* 🔹 펫 이미지 선택 모달 */}
      <Modal
        visible={showPetModal}
        transparent
        animationType="fade"
        onRequestClose={() => setShowPetModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalBox}>
            <Text style={styles.modalTitle}>펫 이미지 선택</Text>
            <View style={styles.petChoiceRow}>
              <TouchableOpacity
                style={styles.petChoiceItem}
                onPress={() => handleSelectPetImage("default")}
              >
                <Image
                  source={PET_IMAGES.default}
                  style={styles.petChoiceImage}
                />
                <Text style={styles.petChoiceLabel}>랑이</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.petChoiceItem}
                onPress={() => handleSelectPetImage("dog")}
              >
                <Image
                  source={PET_IMAGES.dog}
                  style={styles.petChoiceImage}
                />
                <Text style={styles.petChoiceLabel}>몽이</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.petChoiceItem}
                onPress={() => handleSelectPetImage("cat")}
              >
                <Image
                  source={PET_IMAGES.cat}
                  style={styles.petChoiceImage}
                />
                <Text style={styles.petChoiceLabel}>나비</Text>
              </TouchableOpacity>
            </View>

            <TouchableOpacity
              style={[styles.modalButton, { marginTop: 18 }]}
              onPress={() => setShowPetModal(false)}
            >
              <Text style={styles.modalButtonText}>닫기</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: "#f5f5f5" },
  petBox: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 10,
    padding: 16,
    backgroundColor: "#fff",
  },
  petInfoArea: {
    flex: 1,
    marginRight: 12,
  },
  petName: { fontWeight: "700", marginBottom: 6, fontSize: 16 },
  petImage: {
    width: 64,
    height: 64,
    borderRadius: 32,
  },
  streak: {
    marginVertical: 20,
    color: "#444",
  },
  writeBtn: {
    backgroundColor: "#000",
    padding: 16,
    borderRadius: 10,
    alignItems: "center",
    marginBottom: 14,
  },
  writeText: {
    color: "white",
    fontWeight: "700",
  },
  menuBtn: {
    padding: 16,
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 12,
    marginBottom: 10,
    alignItems: "center",
    backgroundColor: "#fff",
  },
  menuText: { fontSize: 15 },

  // 🔹 펫 이미지 선택 모달 스타일
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
    color: "#333",
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
  petChoiceRow: {
    flexDirection: "row",
    marginTop: 16,
    justifyContent: "space-between",
  },
  petChoiceItem: {
    alignItems: "center",
    marginHorizontal: 8,
  },
  petChoiceImage: {
    width: 56,
    height: 56,
    borderRadius: 28,
    marginBottom: 4,
  },
  petChoiceLabel: {
    fontSize: 12,
    color: "#444",
  },
});
