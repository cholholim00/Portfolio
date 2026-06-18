# 메인 단계 8: 구급대원용 태블릿 UI 앱 만들기
import tkinter as tk
from tkinter import filedialog, messagebox
import ctypes
import os
import cv2
import numpy as np
from scipy.signal import find_peaks

# =========================================================
# 1. C++ 코어 엔진 로드
# =========================================================
dll_path = os.path.abspath('triage_engine.dll')
engine = ctypes.CDLL(dll_path)
engine.addPatient.argtypes = [ctypes.c_int, ctypes.c_float, ctypes.c_float, ctypes.c_float]
engine.addPatient.restype = ctypes.c_int
engine.popNextPatient.argtypes = []
engine.popNextPatient.restype = ctypes.c_int

# =========================================================
# 2. Vision 모듈 (EKG 분석)
# =========================================================
def extract_hr_from_ekg(image_path):
    # 한글 경로 에러를 방지하는 OpenCV 우회 읽기 방식
    img_array = np.fromfile(image_path, np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
    
    if img is None: return -1
    
    h, w, _ = img.shape
    strip = img[int(h*0.75):h, :]
    gray = cv2.cvtColor(strip, cv2.COLOR_BGR2GRAY)
    _, binary = cv2.threshold(gray, 120, 255, cv2.THRESH_BINARY_INV)
    col_sums = np.sum(binary == 255, axis=0)
    peaks, _ = find_peaks(col_sums, distance=w//30, height=np.max(col_sums)*0.4)
    
    if len(peaks) < 2: return -1
    
    pixels_per_second = w / 10.0
    avg_rr_seconds = np.mean(np.diff(peaks)) / pixels_per_second
    return int(60 / avg_rr_seconds)

# =========================================================
# 3. 그래픽 UI (Tkinter) 클래스
# =========================================================
class TriageUI:
    def __init__(self, root):
        self.root = root
        self.root.title("🚑 오프라인 구급차 Triage 시스템")
        self.root.geometry("450x550")
        self.root.configure(bg="#f4f4f4")
        
        self.current_id = 1001

        # 타이틀
        tk.Label(root, text="구급차 K-NN 환자 분류기", font=("Helvetica", 16, "bold"), bg="#f4f4f4").pack(pady=20)

        # 수동 입력 프레임
        frame1 = tk.LabelFrame(root, text="수동 환자 등록", bg="#f4f4f4", font=("Helvetica", 10, "bold"))
        frame1.pack(fill="x", padx=20, pady=10)
        
        tk.Label(frame1, text="수축기 혈압 (SBP):", bg="#f4f4f4").grid(row=0, column=0, padx=10, pady=5)
        self.entry_bp = tk.Entry(frame1, width=15)
        self.entry_bp.grid(row=0, column=1)
        self.entry_bp.insert(0, "120")

        tk.Label(frame1, text="산소포화도 (SpO2):", bg="#f4f4f4").grid(row=1, column=0, padx=10, pady=5)
        self.entry_spo2 = tk.Entry(frame1, width=15)
        self.entry_spo2.grid(row=1, column=1)
        self.entry_spo2.insert(0, "98")

        tk.Button(frame1, text="데이터 수동 적재", command=self.add_manual, bg="#4CAF50", fg="white").grid(row=2, columnspan=2, pady=10)

        # EKG 비전 입력 프레임
        frame2 = tk.LabelFrame(root, text="EKG 비전 자동 등록", bg="#f4f4f4", font=("Helvetica", 10, "bold"))
        frame2.pack(fill="x", padx=20, pady=10)
        
        tk.Button(frame2, text="📷 심전도 사진 불러오기 및 분석", command=self.add_ekg, bg="#2196F3", fg="white").pack(pady=15)

        # 출력 프레임 (대기열 호출)
        frame3 = tk.Frame(root, bg="#f4f4f4")
        frame3.pack(fill="both", expand=True, padx=20, pady=10)

        self.lbl_status = tk.Label(frame3, text="대기열 상태: 대기 중", font=("Helvetica", 11), bg="#f4f4f4", fg="blue")
        self.lbl_status.pack(pady=10)

        tk.Button(frame3, text="🚨 최우선 환자 호출 (치료 시작)", command=self.call_next, bg="#f44336", fg="white", font=("Helvetica", 12, "bold")).pack(pady=10)

    def add_manual(self):
        try:
            bp = float(self.entry_bp.get())
            spo2 = float(self.entry_spo2.get())
            # 수동 입력 시 심박수는 임의로 정상(75) 적용
            score = engine.addPatient(self.current_id, 75.0, bp, spo2)
            messagebox.showinfo("적재 완료", f"환자 {self.current_id}번 적재됨\n위험도: {score}등급")
            self.lbl_status.config(text=f"마지막 적재 환자: {self.current_id}번 ({score}등급)")
            self.current_id += 1
        except:
            messagebox.showerror("오류", "숫자를 올바르게 입력하세요.")

    def add_ekg(self):
        file_path = filedialog.askopenfilename(title="EKG 이미지 선택", filetypes=[("Image Files", "*.png;*.jpg;*.jpeg")])
        if not file_path: return
        
        bpm = extract_hr_from_ekg(file_path)
        if bpm == -1:
            messagebox.showerror("분석 실패", "EKG 파형을 읽을 수 없습니다.")
            return

        try:
            bp = float(self.entry_bp.get())
            spo2 = float(self.entry_spo2.get())
            score = engine.addPatient(self.current_id, float(bpm), bp, spo2)
            messagebox.showinfo("분석 및 적재 완료", f"추출된 심박수: {bpm} BPM\n환자 {self.current_id}번 적재됨\n위험도: {score}등급")
            self.lbl_status.config(text=f"마지막 적재 환자: {self.current_id}번 (EKG 분석, {score}등급)")
            self.current_id += 1
        except:
            messagebox.showerror("오류", "혈압/산소포화도 숫자를 확인하세요.")

    def call_next(self):
        target_id = engine.popNextPatient()
        if target_id == -1:
            messagebox.showwarning("대기열 비어있음", "현재 대기 중인 환자가 없습니다.")
        else:
            messagebox.showwarning("응급 환자 호출", f"🚨 가장 위급한 환자입니다!\n\n환자 ID: {target_id} 번\n즉각 치료를 시작하세요.")

# 앱 실행
if __name__ == "__main__":
    root = tk.Tk()
    app = TriageUI(root)
    root.mainloop()