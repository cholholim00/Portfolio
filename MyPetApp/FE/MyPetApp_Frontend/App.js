// App.js
import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";

import TodayScreen from "./screens/TodayScreen";
import PastJournalScreen from "./screens/PastJournalScreen";
import TodayJournalScreen from "./screens/TodayJournalScreen";
import CalendarScreen from "./screens/CalendarScreen";
import JournalDetailScreen from "./screens/JournalDetailScreen";
import SupportScreen from "./screens/SupportScreen";
import PhotoGalleryScreen from "./screens/PhotoGalleryScreen";
import PetLogScreen from "./screens/PetLogScreen";
import EmotionAnalysisScreen from "./screens/EmotionAnalysisScreen";
import JournalSearchScreen from "./screens/JournalSearchScreen";

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Today">
        <Stack.Screen
          name="Today"
          component={TodayScreen}
          options={{ title: "오늘의 일기 → MY펫 성장" }}
        />
        <Stack.Screen
          name="Past"
          component={PastJournalScreen}
          options={{ title: "지난 일기" }}
        />
        <Stack.Screen
          name="TodayJournal"
          component={TodayJournalScreen}
          options={{ title: "일기 작성" }}
        />
        <Stack.Screen
          name="Calendar"
          component={CalendarScreen}
          options={{ title: "달력" }}
        />
        <Stack.Screen
          name="JournalDetail"
          component={JournalDetailScreen}
          options={{ title: "일기 상세" }}
        />
        <Stack.Screen
          name="Support"
          component={SupportScreen}
          options={{ title: "위로 / 응원" }}
        />
        <Stack.Screen
          name="PhotoGallery"
          component={PhotoGalleryScreen}
          options={{ title: "사진첩" }}
        />
        <Stack.Screen
          name="PetLog"
          component={PetLogScreen}
          options={{ title: "MY펫 로그" }}
        />
        <Stack.Screen
          name="EmotionAnalysis"
          component={EmotionAnalysisScreen}
          options={{ title: "감정 분석 로그" }}
        />
        <Stack.Screen
          name="JournalSearch"
          component={JournalSearchScreen}
          options={{ title: "일기 검색 / 필터" }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

