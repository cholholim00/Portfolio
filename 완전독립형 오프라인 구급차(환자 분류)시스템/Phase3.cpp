// 메인 단계 3: 우선순위 큐 정렬 및 다중 환자 처리 엔진 업데이트
#include <iostream>
#include <cmath>
#include <windows.h>

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

// K-NN 위급도 계산 함수
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

// [핵심 로직] 우선순위 큐 기반 환자 삽입 함수
// 포인터의 참조(&)를 사용하여 필요시 head 자체를 변경합니다.
void enqueuePatient(PatientNode*& head, PatientNode* newPatient) {
    // 1. 대기열이 비어있거나, 새 환자가 현재 1순위(Head)보다 더 위급한 경우 (점수가 낮을수록 위급)
    if (head == nullptr || newPatient->triage_score < head->triage_score) {
        newPatient->next = head; // 새 환자의 뒤에 기존 리스트를 붙임
        head = newPatient;       // 새 환자가 새로운 1순위(Head)가 됨
        return;
    }

    // 2. 그 외의 경우, 대기열을 순회하며 자신의 점수에 맞는 위치를 찾음
    PatientNode* current = head;
    while (current->next != nullptr && current->next->triage_score <= newPatient->triage_score) {
        current = current->next;
    }

    // 찾은 위치에 환자 노드 삽입 (포인터 끊고 이어붙이기)
    newPatient->next = current->next;
    current->next = newPatient;
}

// 현재 대기열 상태 출력 함수
void printQueue(PatientNode* head) {
    cout << "\n[현재 구급차 치료 대기열 순위]" << endl;
    PatientNode* current = head;
    int rank = 1;
    while (current != nullptr) {
        cout << rank << "순위 - 환자 ID [" << current->patient_id 
             << "] (Triage: " << current->triage_score << "등급)" << endl;
        current = current->next;
        rank++;
    }
    cout << "---------------------------------" << endl;
}

int main() {
    SetConsoleOutputCP(CP_UTF8);
    PatientNode* head = nullptr;

    cout << "=== 독립형 다중 환자 Triage 시스템 가동 ===" << endl;

    // 시나리오: 3명의 환자가 순차적으로 구조됨
    
    // 환자 A (가벼운 증상)
    PatientNode* patientA = new PatientNode{1001, 65.0, 105.0, 92.0, 0, nullptr};
    calculateTriageScore(patientA);
    cout << "\n[System] 환자 ID 1001 탑승. 판정 등급: " << patientA->triage_score << endl;
    enqueuePatient(head, patientA);
    printQueue(head);

    // 환자 B (정상에 가까움)
    PatientNode* patientB = new PatientNode{1002, 75.0, 115.0, 97.0, 0, nullptr};
    calculateTriageScore(patientB);
    cout << "\n[System] 환자 ID 1002 탑승. 판정 등급: " << patientB->triage_score << endl;
    enqueuePatient(head, patientB);
    printQueue(head);

    // 환자 C (초응급 상태 - 나중에 탔지만 1순위로 새치기해야 함!)
    PatientNode* patientC = new PatientNode{1003, 130.0, 80.0, 85.0, 0, nullptr};
    calculateTriageScore(patientC);
    cout << "\n[System] 환자 ID 1003 (위급) 탑승. 판정 등급: " << patientC->triage_score << endl;
    enqueuePatient(head, patientC);
    printQueue(head);

    // [중요] 모든 환자 인계 후 연결 리스트 전체 메모리 해제
    PatientNode* current = head;
    while (current != nullptr) {
        PatientNode* nextNode = current->next;
        delete current;
        current = nextNode;
    }
    head = nullptr;

    cout << "\n[System] 모든 환자 인계 완료. 연결 리스트 메모리 완전 해제." << endl;

    return 0;
}