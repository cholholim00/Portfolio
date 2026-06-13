// screens/EmotionAnalysisScreen.js
import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";

// 새 서버 IP
const API_BASE = "http://10.138.31.34:4000";

export default function EmotionAnalysisScreen() {
  const [testText, setTestText] = useState("");
  const [testResult, setTestResult] = useState(null);
  const [testLogs, setTestLogs] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // 최근 10개 일기
  const [recentJournals, setRecentJournals] = useState([]);

  // 전체/최근 평균 기분 점수
  const [stats, setStats] = useState({
    total: 0,
    recent: 0,
    avgMoodAll: 0,
    avgMoodRecent: 0,
    emotionCounts: {},
  });

  // 🔹 통계 재계산 함수 (로컬/서버 공통 사용)
  const recomputeStatsFromList = (list) => {
    const sorted = [...list].sort(
      (a, b) =>
        new Date(b.date + " " + (b.time || "00:00")) -
        new Date(a.date + " " + (a.time || "00:00"))
    );

    setRecentJournals(sorted.slice(0, 10));

    const validAll = sorted.filter((j) => typeof j.mood === "number");
    const sumAll = validAll.reduce((s, j) => s + j.mood, 0);
    const avgAll =
      validAll.length > 0 ? Math.round(sumAll / validAll.length) : 0;

    const today = new Date();
    const weekAgo = new Date(
      today.getTime() - 7 * 24 * 60 * 60 * 1000
    );
    const recentList = sorted.filter((j) => new Date(j.date) >= weekAgo);
    const validRecent = recentList.filter(
      (j) => typeof j.mood === "number"
    );
    const sumRecent = validRecent.reduce((s, j) => s + j.mood, 0);
    const avgRecent =
      validRecent.length > 0
        ? Math.round(sumRecent / validRecent.length)
        : 0;

    const emotionCounts = {};
    sorted.forEach((j) => {
      if (!j.emotions) return;
      Object.entries(j.emotions).forEach(([key, on]) => {
        if (!on) return;
        emotionCounts[key] = (emotionCounts[key] || 0) + 1;
      });
    });

    setStats({
      total: sorted.length,
      recent: recentList.length,
      avgMoodAll: avgAll,
      avgMoodRecent: avgRecent,
      emotionCounts,
    });
  };

  // 🔹 서버에서 journals 최신값 가져와 로컬/통계 덮어쓰기 (백그라운드)
  const syncJournalsFromServer = async () => {
    try {
      const res = await fetch(`${API_BASE}/journals`);
      const json = await res.json();
      if (json.ok && Array.isArray(json.journals)) {
        await AsyncStorage.setItem(
          "journals",
          JSON.stringify(json.journals)
        );
        recomputeStatsFromList(json.journals);
      }
    } catch (e) {
      console.log("EmotionAnalysis syncJournalsFromServer 에러:", e);
    }
  };

  // journals + 통계 + 테스트 로그 로드
  useEffect(() => {
    const loadJournals = async () => {
      try {
        // 1) 로컬 journals 기준으로 먼저 통계 그리기 (옛날 값이라도 바로 보여줌)
        const raw = await AsyncStorage.getItem("journals");
        const list = raw ? JSON.parse(raw) : [];
        recomputeStatsFromList(list);

        // 2) 백그라운드에서 서버 최신값 받아서 로컬/통계 덮어쓰기
        syncJournalsFromServer();
      } catch (e) {
        console.log("감정 분석용 journals 로드 에러:", e);
      }
    };

    const loadTests = async () => {
      try {
        const raw = await AsyncStorage.getItem("analysis_tests");
        const list = raw ? JSON.parse(raw) : [];
        setTestLogs(list.slice(-10).reverse());
      } catch (e) {
        console.log("analysis_tests 로드 에러:", e);
      }
    };

    loadJournals();
    loadTests();
  }, []);

  // 🔹 감정 요약(label / score / comment) 만드는 함수
  const summarizeEmotions = (emotions = {}) => {
    const posKeys = ["happy", "love", "calm"];
    const negKeys = ["sad", "anger", "anxious"];

    const active = Object.entries(emotions)
      .filter(([_, on]) => !!on)
      .map(([k]) => k);

    const hasPos = posKeys.some((k) => emotions[k]);
    const hasNeg = negKeys.some((k) => emotions[k]);

    let label = "중립/무감정";
    if (hasPos && !hasNeg) label = "긍정적";
    else if (!hasPos && hasNeg) label = "부정적";
    else if (hasPos && hasNeg) label = "복합적";

    const score = Math.min(active.length * 20, 100);

    let comment = "";
    if (active.length === 0) {
      comment =
        "뚜렷하게 드러나는 감정은 적지만, 그런 날도 충분히 괜찮아.";
    } else if (label === "긍정적") {
      comment =
        "기분이 꽤 괜찮은 날인 것 같아. 이 기분을 천천히 음미해 보는 것도 좋을 것 같아.";
    } else if (label === "부정적") {
      comment =
        "마음이 꽤 무거워 보이네. 이런 감정을 느끼고 있다는 것만으로도 이미 잘 버티고 있는 거야.";
    } else {
      comment =
        "여러 감정이 섞여 있는 하루였던 것 같아. 뭐가 옳고 그른 감정은 아니니까, 그냥 ‘그랬구나’ 하고 바라봐 줘도 좋아.";
    }

    return { label, score, comment, active };
  };

  // 테스트 텍스트 AI 분석
  const runTest = async () => {
    if (!testText.trim()) return;
    try {
      setLoading(true);
      setError("");
      setTestResult(null);

      const res = await fetch(`${API_BASE}/analyze`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: testText.trim() }),
      });

      if (!res.ok) {
        console.log("analyze status =", res.status);
        setError("감정 분석 API 호출에 실패했어요.");
        setLoading(false);
        return;
      }

      const data = await res.json();
      console.log("analyze data =", data);

      const emotions = data.emotions || {};
      const { label, score, comment, active } =
        summarizeEmotions(emotions);

      const result = {
        label,
        score,
        comment,
        emotions,
        active,
      };
      setTestResult(result);

      // 로그에 저장
      const now = new Date();
      const y = now.getFullYear();
      const m = String(now.getMonth() + 1).padStart(2, "0");
      const d = String(now.getDate()).padStart(2, "0");
      const date = `${y}-${m}-${d}`;
      const time = now.toTimeString().slice(0, 5);

      const newLog = {
        id: Date.now().toString(),
        date,
        time,
        text: testText.trim(),
        label: result.label,
        score: result.score,
        comment: result.comment,
      };

      const raw = await AsyncStorage.getItem("analysis_tests");
      const list = raw ? JSON.parse(raw) : [];
      const updated = [...list, newLog].slice(-50); // 최대 50개
      await AsyncStorage.setItem(
        "analysis_tests",
        JSON.stringify(updated)
      );
      setTestLogs(updated.slice(-10).reverse());
    } catch (e) {
      console.log("AI 감정 테스트 에러:", e);
      setError("분석 중 오류가 발생했어요.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScrollView style={styles.container}>
      {/* 통계 카드 */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>일기 감정 통계</Text>
        <Text style={styles.statText}>
          전체 일기 수: {stats.total}개
        </Text>
        <Text style={styles.statText}>
          최근 7일 일기 수: {stats.recent}개
        </Text>
        <Text style={styles.statText}>
          전체 평균 감정 점수: {stats.avgMoodAll}
        </Text>
        <Text style={styles.statText}>
          최근 7일 평균 감정 점수: {stats.avgMoodRecent}
        </Text>
      </View>

      {/* 감정 태그 사용 횟수 */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>감정 태그 사용 횟수</Text>
        {Object.keys(stats.emotionCounts).length === 0 ? (
          <Text style={styles.statText}>
            아직 감정 태그 데이터가 없어요.
          </Text>
        ) : (
          Object.entries(stats.emotionCounts).map(([key, count]) => (
            <Text key={key} style={styles.statText}>
              {key}: {count}회
            </Text>
          ))
        )}
      </View>

      {/* 자유 텍스트 감정 테스트 */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>자유 텍스트 감정 테스트</Text>
        <TextInput
          style={styles.input}
          value={testText}
          onChangeText={setTestText}
          placeholder="분석해 보고 싶은 문장을 적어줘..."
          multiline
          textAlignVertical="top"
        />
        <TouchableOpacity
          style={styles.runBtn}
          onPress={runTest}
          disabled={loading}
        >
          <Text style={styles.runBtnText}>
            {loading ? "분석 중..." : "지금의 나의 감정은? 🤔"}
          </Text>
        </TouchableOpacity>

        {error ? <Text style={styles.errorText}>{error}</Text> : null}

        {testResult && (
          <View style={styles.resultBox}>
            <Text style={styles.resultTitle}>분석 결과</Text>
            <Text style={styles.resultText}>
              예측 감정(요약): {testResult.label}
            </Text>
            <Text style={styles.resultText}>
              예측 점수: {testResult.score}
            </Text>
            <Text style={styles.resultText}>
              감정 플래그:{" "}
              {testResult.active && testResult.active.length > 0
                ? testResult.active.join(", ")
                : "감정 플래그 없음"}
            </Text>
            <Text style={styles.resultComment}>
              {testResult.comment}
            </Text>
          </View>
        )}
      </View>

      {/* 최근 감정 테스트 로그 */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>최근 감정 테스트 기록</Text>
        {testLogs.length === 0 ? (
          <Text style={styles.statText}>아직 테스트 기록이 없어요.</Text>
        ) : (
          testLogs.map((log) => (
            <View key={log.id} style={styles.logItem}>
              <Text style={styles.logDate}>
                {log.date} {log.time}
              </Text>
              <Text style={styles.logText}>{log.text}</Text>
              <Text style={styles.logMeta}>
                감정: {log.label} / 점수: {log.score}
              </Text>
              <Text style={styles.logComment}>{log.comment}</Text>
            </View>
          ))
        )}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    padding: 16,
  },

  // 공통 카드
  section: {
    backgroundColor: "#fff",
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e3f2fd",
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: "800",
    color: "#333",
    marginBottom: 8,
  },
  statText: {
    fontSize: 13,
    color: "#555",
    marginTop: 2,
  },

  // 입력 박스 + 버튼
  input: {
    marginTop: 8,
    borderWidth: 1,
    borderColor: "#e0e0e0",
    borderRadius: 10,
    padding: 10,
    minHeight: 80,
    backgroundColor: "#fafafa",
    textAlignVertical: "top",
    fontSize: 14,
  },
  runBtn: {
    marginTop: 10,
    backgroundColor: "#2457d6",
    paddingVertical: 10,
    borderRadius: 10,
    alignItems: "center",
  },
  runBtnText: {
    color: "#fff",
    fontWeight: "700",
    fontSize: 14,
  },
  errorText: {
    marginTop: 8,
    color: "#f44336",
    fontSize: 12,
  },

  // 결과 박스
  resultBox: {
    marginTop: 10,
    padding: 12,
    borderRadius: 10,
    backgroundColor: "#f1f8ff",
  },
  resultTitle: {
    fontSize: 15,
    fontWeight: "700",
    marginBottom: 4,
    color: "#2457d6",
  },
  resultText: {
    marginTop: 2,
    fontSize: 13,
    color: "#333",
  },
  resultComment: {
    marginTop: 6,
    fontSize: 13,
    color: "#555",
  },

  // 최근 테스트 로그
  logItem: {
    marginTop: 8,
    paddingVertical: 6,
    borderTopWidth: 1,
    borderTopColor: "#eee",
  },
  logDate: {
    fontSize: 11,
    color: "#999",
  },
  logText: {
    fontSize: 13,
    color: "#333",
    marginTop: 2,
  },
  logMeta: {
    fontSize: 11,
    color: "#555",
    marginTop: 2,
  },
  logComment: {
    fontSize: 11,
    color: "#777",
    marginTop: 2,
  },
});
