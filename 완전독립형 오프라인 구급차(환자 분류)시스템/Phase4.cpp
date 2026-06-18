// 메인 단계 4: 파이프라인 통합 및 하이브리드 확장 - C++ 코어 엔진을 DLL 구조로 리팩토링하기
#include <cmath>

// 외부(Python)에서 이 C++ 함수들을 찾을 수 있도록 꼬리표를 달아주는 매크로
#define EXPORT extern "C" __declspec(dllexport)

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

// C++ 엔진 내부에서 관리될 구급차 대기열의 시작점 (은닉된 상태)
PatientNode* engine_head = nullptr;

// K-NN 연산 함수 (내부 전용)
int calculateTriageScore(float hr, float bp, float spo2) {
    float min_distance = 999999.0;
    int predicted_score = 5;

    for (int i = 0; i < DATASET_SIZE; ++i) {
        float dist = sqrt(
            pow(hr - dataset[i].heart_rate, 2) +
            pow(bp - dataset[i].systolic_bp, 2) +
            pow(spo2 - dataset[i].oxygen_saturation, 2)
        );

        if (dist < min_distance) {
            min_distance = dist;
            predicted_score = dataset[i].result_score;
        }
    }
    return predicted_score;
}

// ---------------------------------------------------------
// ▼ 여기서부터 파이썬(Python)에 제공할 API (인터페이스) ▼
// ---------------------------------------------------------

// API 1: 새로운 환자를 입력받아 큐에 정렬하고, 판정된 위급도 점수를 파이썬으로 반환
EXPORT int addPatient(int id, float hr, float bp, float spo2) {
    int score = calculateTriageScore(hr, bp, spo2);
    
    PatientNode* newPatient = new PatientNode{id, hr, bp, spo2, score, nullptr};

    // 우선순위 큐 정렬 로직
    if (engine_head == nullptr || newPatient->triage_score < engine_head->triage_score) {
        newPatient->next = engine_head;
        engine_head = newPatient;
    } else {
        PatientNode* current = engine_head;
        while (current->next != nullptr && current->next->triage_score <= newPatient->triage_score) {
            current = current->next;
        }
        newPatient->next = current->next;
        current->next = newPatient;
    }

    return score; // 파이썬에게 계산된 점수 알려주기
}

// API 2: 대기열에서 1순위 환자를 뽑아내어 ID를 파이썬으로 반환하고 메모리 해제 (치료 시작)
EXPORT int popNextPatient() {
    if (engine_head == nullptr) return -1; // 대기열이 비어있음

    PatientNode* target = engine_head;
    int target_id = target->patient_id;
    
    engine_head = engine_head->next; // 다음 환자를 1순위로 당김
    delete target;                   // 메모리 안전 해제

    return target_id;
}