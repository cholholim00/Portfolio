// 메인 단계 2: K-NN 기반 위급도 판별 엔진 탑재 업데이트
#include <iostream>
#include <cmath>
#include <windows.h> // Windows 터미널 제어를 위한 헤더 추가

using namespace std;

struct PatientNode {
    int patient_id;
    float heart_rate;
    float systolic_bp;
    float oxygen_saturation;
    int triage_score;
    PatientNode* next;
};

struct HistoricalCase {
    float heart_rate;
    float systolic_bp;
    float oxygen_saturation;
    int result_score;
};

const int DATASET_SIZE = 4;
HistoricalCase dataset[DATASET_SIZE] = {
    {120.0, 90.0, 88.0, 1},
    {80.0, 120.0, 98.0, 5},
    {140.0, 160.0, 95.0, 2},
    {60.0, 100.0, 90.0, 3}
};

void calculateTriageScore(PatientNode* patient) {
    float min_distance = 999999.0;
    int predicted_score = 5;

    for (int i = 0; i < DATASET_SIZE; ++i) {
        float dist = sqrt(
            pow(patient->heart_rate - dataset[i].heart_rate, 2) +
            pow(patient->systolic_bp - dataset[i].systolic_bp, 2) +
            pow(patient->oxygen_saturation - dataset[i].oxygen_saturation, 2)
        );

        if (dist < min_distance) {
            min_distance = dist;
            predicted_score = dataset[i].result_score;
        }
    }
    patient->triage_score = predicted_score;
}

int main() {
    // 윈도우 터미널의 출력 인코딩을 강제로 UTF-8로 변경 (한글 깨짐 완벽 방지)
    SetConsoleOutputCP(CP_UTF8);

    PatientNode* head = nullptr;

    cout << "=== 독립형 구급차 Triage 시스템 가동 ===" << endl;

    PatientNode* newPatient = new PatientNode;
    newPatient->patient_id = 1001;
    newPatient->heart_rate = 120.0;
    newPatient->systolic_bp = 85.0;
    newPatient->oxygen_saturation = 88.0;
    newPatient->triage_score = 0;
    newPatient->next = nullptr;

    head = newPatient;
    
    cout << "\n[System] 환자 ID " << head->patient_id << " 데이터 적재 완료." << endl;
    
    calculateTriageScore(head);
    
    cout << " >>> [분석 결과] Triage 점수: " << head->triage_score << " 등급 판정 완료." << endl;

    delete head;
    head = nullptr;

    cout << "\n[System] 메모리 안전 해제 (Memory Leak 0%). 시스템 종료." << endl;

    return 0;
}