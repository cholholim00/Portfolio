// components/JournalCard.js
import React from "react";
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
} from "react-native";


export default function JournalCard({
  date,
  time,
  score,
  mood,
  xp,
  moodIcon, // 이미지 require() 들어옴
  onDelete,
  onPress,
  selectable, // 선택 모드 여부
  selected, // 선택 상태
}) {
  return (
    <TouchableOpacity
      style={[styles.card, selected && styles.cardSelected]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <View style={styles.header}>
        <View>
          <Text style={styles.date}>{date}</Text>
          {time && <Text style={styles.time}>{time}</Text>}
        </View>


        {/* 오른쪽 상단 감정 아이콘 (이미지) */}
        <View style={styles.iconBox}>
          {moodIcon ? (
            <Image
              source={moodIcon}
              style={styles.iconImage} // 기존 이모지 크기 비슷하게
              resizeMode="contain"
            />
          ) : (
            <Text style={styles.iconText}>❔</Text>
          )}
        </View>
      </View>


      <Text style={styles.text}>
        점수: {score} / 기분: {mood} / XP: {xp}
      </Text>


      {!selectable && (
        <TouchableOpacity
          style={styles.deleteBtn}
          onPress={() => {
            console.log("delete");
            onDelete && onDelete();
          }}
        >
          <Text style={styles.deleteText}>삭제</Text>
        </TouchableOpacity>
      )}
    </TouchableOpacity>
  );
}


const styles = StyleSheet.create({
  card: {
    borderWidth: 1,
    borderColor: "#e0e0e0",
    borderRadius: 14,
    padding: 20,
    marginBottom: 20,
    backgroundColor: "#fff",
    position: "relative",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  // 선택된 카드 배경을 연한 회색으로
  cardSelected: {
    backgroundColor: "#eeeeee",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 6,
    alignItems: "center",
  },
  date: { fontSize: 18, fontWeight: "800", color: "#2196f3" },
  time: {
    fontSize: 16,
    fontWeight: "600",
    color: "#4e4e4e",
    alignSelf: "flex-start",
  },
  text: { color: "#555", fontSize: 16, marginBottom: 8, fontWeight: "500" },
  deleteBtn: {
    position: "absolute",
    right: 16,
    bottom: 16,
    backgroundColor: "#ff5252",
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
  },
  deleteText: { color: "white", fontWeight: "700", fontSize: 14 },
  iconBox: {
    minWidth: 32,
    alignItems: "center",
    justifyContent: "center",
  },
  iconText: { fontSize: 22 },
  iconImage: {
    width: 40, // 기존 텍스트 이모티콘 크기와 비슷하게
    height: 40,
  },
});