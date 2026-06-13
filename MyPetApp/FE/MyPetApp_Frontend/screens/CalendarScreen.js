// CalendarScreen.js
import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Dimensions,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useNavigation, useFocusEffect } from "@react-navigation/native";

const API_BASE = "http://10.138.31.34:4000";
const { width: screenWidth } = Dimensions.get("window");
const DAY_SIZE = (screenWidth - 32 - 12) / 7;

// YYYY-MM-DD 문자열
const formatLocalDate = (d) => {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

// 날짜 중복 제거 후, 연속 작성일 수 맵 생성
const buildStreakMap = (journals) => {
  if (!Array.isArray(journals) || journals.length === 0) return {};

  const uniqueDates = Array.from(
    new Set(journals.map((j) => j.date))
  ).sort();

  const map = {};
  let prev = null;
  let streak = 0;

  for (const dateStr of uniqueDates) {
    if (!prev) {
      streak = 1;
    } else {
      const diffDays =
        (new Date(dateStr) - new Date(prev)) / (24 * 60 * 60 * 1000);
      streak = diffDays === 1 ? streak + 1 : 1;
    }
    map[dateStr] = streak;
    prev = dateStr;
  }

  return map;
};

export default function CalendarScreen() {
  const navigation = useNavigation();
  const [journals, setJournals] = useState([]);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [streakMap, setStreakMap] = useState({});

  // 🔹 서버에서 최신 journals 가져와 로컬/상태 덮어쓰기 (백그라운드)
  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.journals)) {
        await AsyncStorage.setItem(
          "journals",
          JSON.stringify(json.journals)
        );
        setJournals(json.journals);
        setStreakMap(buildStreakMap(json.journals));
      }
    } catch (e) {
      console.log("CalendarScreen syncJournalsFromServer 에러:", e);
    }
  };

  const loadJournals = async () => {
    try {
      // 1) 로컬에서 journals 읽어서 streakMap 계산 → 바로 UI 채움
      const saved = await AsyncStorage.getItem("journals");
      if (saved) {
        const parsed = JSON.parse(saved);
        setJournals(parsed);
        setStreakMap(buildStreakMap(parsed));
      } else {
        setJournals([]);
        setStreakMap({});
      }

      // 2) 백그라운드에서 서버 최신값 받아와 로컬/상태 덮어쓰기
      syncJournalsFromServer();
    } catch (e) {
      console.error(e);
      setJournals([]);
      setStreakMap({});
    }
  };

  // 최초 로드
  useEffect(() => {
    loadJournals();
  }, []);

  // 화면 다시 포커스될 때마다 최신 데이터 반영 (동일 패턴)
  useFocusEffect(
    React.useCallback(() => {
      loadJournals();
    }, [])
  );

  const isCurrentMonth = (date) => {
    return (
      date.getMonth() === currentDate.getMonth() &&
      date.getFullYear() === currentDate.getFullYear()
    );
  };

  // 연속 작성일 수 기반 색상
  const getStreakColor = (dateStr) => {
    const streak = streakMap[dateStr] || 0;
    if (streak === 0) {
      return isCurrentMonth(new Date(dateStr)) ? "#f8f9fa" : "#f0f0f0";
    }

    const level = Math.min(streak, 7); // 7 이상은 모두 최상단계 색
    const colors = [
      "#e3f2fd", // 1일
      "#bbdefb", // 2일
      "#90caf9", // 3일
      "#64b5f6", // 4일
      "#42a5f5", // 5일
      "#2196f3", // 6일
      "#1976d2", // 7일 이상
    ];
    return colors[level - 1];
  };

  const goToPrevMonth = () => {
    setCurrentDate(
      new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1)
    );
  };

  const goToNextMonth = () => {
    setCurrentDate(
      new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1)
    );
  };

  const renderDay = (date) => {
    const dateStr = formatLocalDate(date);
    const todayStr = formatLocalDate(new Date());
    const isToday = dateStr === todayStr;
    const inCurrentMonth = isCurrentMonth(date);

    const journalOfDay = journals.find((j) => j.date === dateStr);

    return (
      <TouchableOpacity
        key={dateStr}
        style={[
          styles.day,
          {
            backgroundColor: getStreakColor(dateStr),
            opacity: inCurrentMonth ? 1 : 0.3,
            borderWidth: isToday ? 2 : 0,
            borderColor: isToday ? "#ff9800" : "transparent",
          },
        ]}
        onPress={() => {
          if (journalOfDay && inCurrentMonth) {
            navigation.navigate("JournalDetail", {
              journal: journalOfDay,
              allJournals: journals,
            });
          }
        }}
        disabled={!inCurrentMonth || !journalOfDay}
      >
        <Text
          style={[
            styles.dayText,
            !inCurrentMonth && styles.dayTextDisabled,
            isToday && styles.todayText,
          ]}
        >
          {date.getDate()}
        </Text>
      </TouchableOpacity>
    );
  };

  const renderWeek = (startDate) => {
    const days = [];
    for (let i = 0; i < 7; i++) {
      const date = new Date(startDate);
      date.setDate(startDate.getDate() + i);
      days.push(renderDay(date));
    }
    return (
      <View key={startDate.toDateString()} style={styles.weekRow}>
        {days}
      </View>
    );
  };

  const renderMonth = () => {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    const firstDay = new Date(year, month, 1);
    const startDate = new Date(year, month, 1 - firstDay.getDay());

    const weeks = [];
    for (let week = 0; week < 6; week++) {
      const weekStart = new Date(
        startDate.getTime() + week * 7 * 24 * 60 * 60 * 1000
      );
      weeks.push(renderWeek(weekStart));
    }
    return weeks;
  };

  const monthName = currentDate.toLocaleDateString("ko-KR", {
    year: "numeric",
    month: "long",
  });

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{monthName}</Text>

      <View style={styles.header}>
        <TouchableOpacity style={styles.navBtn} onPress={goToPrevMonth}>
          <Text style={styles.navText}>‹</Text>
        </TouchableOpacity>
        <Text style={styles.monthTitle}>{monthName}</Text>
        <TouchableOpacity style={styles.navBtn} onPress={goToNextMonth}>
          <Text style={styles.navText}>›</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.weekdays}>
        {["일", "월", "화", "수", "목", "금", "토"].map((day) => (
          <Text key={day} style={styles.weekday}>
            {day}
          </Text>
        ))}
      </View>

      <ScrollView style={styles.calendar} showsVerticalScrollIndicator={false}>
        {renderMonth()}
      </ScrollView>

      <TouchableOpacity
        style={styles.homeBtn}
        onPress={() =>
  navigation.reset({
    index: 0,
    routes: [{ name: "Today" }], // 스택에 Today 하나만 남김
  })
}
      >
        <Text style={styles.homeBtnText}>🏠 홈으로</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5f5f5", padding: 16 },
  title: {
    fontSize: 28,
    fontWeight: "800",
    textAlign: "center",
    marginBottom: 8,
    color: "#333",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 16,
  },
  navBtn: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: "#fff",
    justifyContent: "center",
    alignItems: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  navText: { fontSize: 20, fontWeight: "700", color: "#666" },
  monthTitle: { fontSize: 18, fontWeight: "700", color: "#333" },
  weekdays: {
    flexDirection: "row",
    backgroundColor: "#fff",
    paddingVertical: 12,
    borderRadius: 12,
    marginBottom: 12,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  weekday: {
    flex: 1,
    textAlign: "center",
    fontWeight: "700",
    fontSize: 14,
    color: "#666",
  },
  calendar: { flex: 1 },
  weekRow: { flexDirection: "row", marginBottom: 4 },
  day: {
    flex: 1,
    height: DAY_SIZE,
    margin: 2,
    borderRadius: 10,
    justifyContent: "center",
    alignItems: "center",
  },
  dayText: { fontSize: 16, fontWeight: "700", color: "#333" },
  dayTextDisabled: { color: "#ccc", fontWeight: "400" },
  todayText: { color: "#ff5722", fontSize: 18 },
  homeBtn: {
    backgroundColor: "#2457d6",
    padding: 16,
    borderRadius: 12,
    alignItems: "center",
    marginTop: 16,
  },
  homeBtnText: { color: "white", fontSize: 18, fontWeight: "700" },
});
