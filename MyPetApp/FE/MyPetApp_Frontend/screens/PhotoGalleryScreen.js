// screens/PhotoGalleryScreen.js
import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  Image,
  TouchableOpacity,
  StyleSheet,
  FlatList,
  Platform,
  Dimensions,
} from "react-native";
import { useNavigation } from "@react-navigation/native";
import AsyncStorage from "@react-native-async-storage/async-storage";

const API_BASE = "http://10.138.31.34:4000";
const screenWidth = Dimensions.get("window").width;

// imageId → require 매핑
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

export default function PhotoGalleryScreen() {
  const navigation = useNavigation();
  const numColumns = Platform.OS === "web" ? 5 : 3;
  const [items, setItems] = useState([]);

  // 🔹 journals 기준으로 photo_items 재생성 (지난 일기 응원 배경도 사진첩에 반영)
  const rebuildPhotoItemsFromJournals = async () => {
    try {
      const rawJ = await AsyncStorage.getItem("journals");
      const journals = rawJ ? JSON.parse(rawJ) : [];
      if (!Array.isArray(journals) || journals.length === 0) {
        return;
      }

      // 1) supportImage === "wallpaper" 인 일기만 골라서 photo_items 후보 만들기
      const photoFromJournals = journals
        .filter(
          (j) =>
            j.supportImage === "wallpaper" &&
            j.supportImageId &&
            j.date &&
            j.time
        )
        .map((j) => ({
          id: `j_${j.id}`, // 중복 방지용 prefix
          date: j.date,
          time: j.time,
          image: "wallpaper",
          imageId: j.supportImageId,
          message: j.supportMessage || "",
          journalId: j.id,
          moodScore: j.mood ?? 0,
          keywords: j.keywords || [],
        }));

      // 2) 기존 photo_items와 합치되, 같은 date+time은 journals 쪽으로 덮어쓰기
      const rawP = await AsyncStorage.getItem("photo_items");
      const oldPhotos = rawP ? JSON.parse(rawP) : [];
      const map = new Map();

      // 기존 것 먼저 넣고
      if (Array.isArray(oldPhotos)) {
        oldPhotos.forEach((p) => {
          const key = `${p.date} ${p.time || ""}`;
          map.set(key, p);
        });
      }

      // journals에서 만든 것들로 덮어쓰기
      photoFromJournals.forEach((p) => {
        const key = `${p.date} ${p.time || ""}`;
        map.set(key, p);
      });

      const merged = Array.from(map.values()).sort(
        (a, b) =>
          new Date(b.date + " " + (b.time || "00:00")) -
          new Date(a.date + " " + (a.time || "00:00"))
      );

      await AsyncStorage.setItem("photo_items", JSON.stringify(merged));
      setItems(merged);

      // 3) 서버에도 동기화 (실패해도 무시)
      (async () => {
        try {
          const res = await fetch(`${API_BASE}/photo-items`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ items: merged }),
          });
          const json = await res.json();
          console.log("rebuild /photo-items ok =", json.ok);
        } catch (e) {
          console.log("rebuild /photo-items 서버 동기화 에러:", e);
        }
      })();
    } catch (e) {
      console.log("rebuildPhotoItemsFromJournals 에러:", e);
    }
  };

  // 🔹 1단계: 로컬 photo_items + journals만으로 동기화
  const syncPhotosWithJournals = async () => {
    try {
      const rawJ = await AsyncStorage.getItem("journals");
      const journals = rawJ ? JSON.parse(rawJ) : [];

      const rawP = await AsyncStorage.getItem("photo_items");
      const photos = rawP ? JSON.parse(rawP) : [];

      if (!Array.isArray(journals) || !Array.isArray(photos)) {
        setItems([]);
        return;
      }

      const keySet = new Set(
        journals.map((j) => `${j.date} ${j.time || ""}`)
      );

      const cleaned = photos.filter((p) =>
        keySet.has(`${p.date} ${p.time || ""}`)
      );

      await AsyncStorage.setItem("photo_items", JSON.stringify(cleaned));
      setItems(cleaned);

      // 🔹 서버에도 정리된 photo_items 반영 (백그라운드)
      (async () => {
        try {
          const res = await fetch(`${API_BASE}/photo-items`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ items: cleaned }),
          });
          const json = await res.json();
          console.log("sync /photo-items ok =", json.ok);
        } catch (e) {
          console.log("sync /photo-items 서버 동기화 에러:", e);
        }
      })();
    } catch (e) {
      console.log("사진첩 동기화 에러:", e);
      setItems([]);
    }
  };

  // 🔹 2단계: 서버에서 최신 photo-items를 가져와 로컬/상태 덮어쓰기
  const syncPhotoItemsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/photo-items`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.items)) {
        await AsyncStorage.setItem("photo_items", JSON.stringify(json.items));
        setItems(json.items);
      }
    } catch (e) {
      console.log("syncPhotoItemsFromServer 에러:", e);
    }
  };

  useEffect(() => {
    const run = async () => {
      // 지난 일기에 있는 사진들(journals 기반) 먼저 photo_items에 반영
      await rebuildPhotoItemsFromJournals();

      // 1) 로컬 기준으로 먼저 갤러리 채우기 (옛날 값이라도 바로 보여줌)
      await syncPhotosWithJournals();

      // 2) 백그라운드에서 서버 최신값을 가져와 로컬/상태 덮어쓰기
      syncPhotoItemsFromServer();
    };
    run();
  }, []);

  const cleanPhotoItemsWithoutTime = async () => {
    try {
      const raw = await AsyncStorage.getItem("photo_items");
      if (!raw) return;

      const list = JSON.parse(raw);
      const cleaned = list.filter((item) => !!item.time);

      await AsyncStorage.setItem("photo_items", JSON.stringify(cleaned));
      console.log(
        `photo_items 정리 완료: 원래 ${list.length}개 → ${cleaned.length}개`
      );
      setItems(cleaned);
    } catch (e) {
      console.log("photo_items 정리 에러:", e);
    }
  };

  const getImageSource = (item) => {
    if (item.image === "wallpaper" && item.imageId) {
      const src = WALLPAPER_IMAGES[item.imageId];
      // 매핑이 없으면 null 반환해서 아예 안 보여주도록
      return src || null;
    }
    // 과거 구조 호환: remote + imageUrl
    if (item.image === "remote" && item.imageUrl) {
      return { uri: item.imageUrl };
    }
    // 그 외는 표시하지 않음
    return null;
  };

  const renderItem = ({ item, index }) => {
    const totalMargin = 8 * 2 + 4 * (numColumns - 1);
    const itemWidth = (screenWidth - totalMargin) / numColumns;

    const web = Platform.OS === "web";
    const width = itemWidth;
    const height = web ? (itemWidth * 3) / 4 : (itemWidth * 4) / 3;

    const src = getImageSource(item);
    if (!src) {
      return null;
    }

    return (
      <TouchableOpacity
        style={[styles.item, { width }]}
        onPress={() =>
          navigation.navigate("Support", {
            fromTodayJournal: false,
            // SupportScreen 갤러리 모드에서 사용할 전체 배열.
            // 여기서 각 요소에 imageSource(썸네일과 동일)까지 붙여서 넘겨줌.
            items: items.map((p) => ({
              ...p,
              imageSource: getImageSource(p),
            })),
            initialIndex: index,
          })
        }
      >
        <Image
          source={src}
          style={[styles.thumb, { width, height }]}
          resizeMode="cover"
        />
        <Text style={styles.date}>
          {item.date} {item.time || ""}
        </Text>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      {/* 정리 버튼 */}
      <TouchableOpacity
        style={styles.cleanBtn}
        onPress={async () => {
          await rebuildPhotoItemsFromJournals();
          await syncPhotosWithJournals();
          await cleanPhotoItemsWithoutTime();
        }}
      >
        <Text style={styles.cleanText}>일기 기준으로 사진 데이터 정리</Text>
      </TouchableOpacity>

      <FlatList
        data={items}
        renderItem={renderItem}
        keyExtractor={(item) => item.id}
        numColumns={numColumns}
        contentContainerStyle={styles.list}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={styles.emptyText}>아직 저장된 사진이 없어요.</Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5f5f5" },
  list: { padding: 8 },
  item: {
    margin: 4,
    alignItems: "center",
  },
  thumb: {
    borderRadius: 8,
  },
  date: {
    marginTop: 4,
    fontSize: 10,
    color: "#555",
  },
  cleanBtn: {
    margin: 8,
    padding: 8,
    borderRadius: 8,
    backgroundColor: "#eee",
    alignItems: "center",
  },
  cleanText: {
    fontSize: 12,
    color: "#555",
  },
  empty: {
    flex: 1,
    alignItems: "center",
    marginTop: 40,
  },
  emptyText: {
    color: "#777",
  },
});
