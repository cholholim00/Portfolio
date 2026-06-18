// 메인 단계 1: 환자 데이터 구조체 정의 및 메모리 동적 할당 
#include <iostream>
#include <windows.h> // Windows 터미널 제어를 위한 헤더 추가

using namespace std;

// 1. 환자 데이터를 담는 코어 단위 (구조체)
// 응급차에서 수집할 수 있는 최소한의 활력 징후와 상태를 정의합니다.
struct PatientNode {
    int patient_id;              // 환자 식별 번호
    float heart_rate;            // 심박수 (HR)
    float systolic_bp;           // 수축기 혈압 (SBP)
    float oxygen_saturation;     // 산소포화도 (SpO2)
    
    int triage_score;            // 알고리즘이 도출할 위험도 점수 (1~5등급)
    
    PatientNode* next;           // 연결 리스트 구성을 위한 다음 환자 포인터
};

int main() {
    // 윈도우 터미널의 출력 인코딩을 강제로 UTF-8로 변경 (한글 깨짐 완벽 방지)
    SetConsoleOutputCP(CP_UTF8);

    // 2. 우선순위 큐(대기열)의 시작점 선언
    // 처음엔 아무 환자도 없으므로 nullptr(빈 포인터)로 초기화합니다.
    PatientNode* head = nullptr;

    cout << "=== 독립형 구급차 Triage 시스템 가동 ===" << endl;

    // 3. 응급 환자 발생 시나리오 (동적 메모리 할당)
    // 환자가 들어올 때만 'new'를 사용해 메모리를 딱 필요한 만큼만 할당합니다.
    PatientNode* newPatient = new PatientNode;
    
    newPatient->patient_id = 1001;
    newPatient->heart_rate = 120.0;       // 빈맥 상태
    newPatient->systolic_bp = 85.0;       // 저혈압 상태
    newPatient->oxygen_saturation = 88.0; // 저산소증 상태
    newPatient->triage_score = 0;         // K-NN 판별 전이므로 0
    newPatient->next = nullptr;           // 일단 이 환자 뒤에는 아무도 없음

    // 대기열에 첫 환자 등록
    if (head == nullptr) {
        head = newPatient;
    }

    cout << "[System] 환자 ID " << head->patient_id << " 데이터 적재 완료." << endl;
    cout << " - 현재 심박수: " << head->heart_rate << " bpm" << endl;
    cout << " - 위험도 분석 대기 중..." << endl;

    // =========================================================
    // Phase 2 (K-NN 위급도 계산) 및 Phase 3 (우선순위 큐 정렬) 
    // 로직이 앞으로 이 구간에 들어가게 됩니다.
    // =========================================================

    // 4. 시스템 종료 및 메모리 반환 (가장 중요)
    // 병원에 환자를 인계한 후, 사용한 메모리를 OS에 반환하여 누수를 막습니다.
    delete head;
    head = nullptr;

    cout << "[System] 환자 인계 완료. 시스템 메모리 안전 해제 (Memory Leak 0%)." << endl;

    return 0;
}