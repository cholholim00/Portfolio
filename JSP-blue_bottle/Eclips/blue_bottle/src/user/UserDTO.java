package user;

public class UserDTO {
    private int idx;
    private String user_id;
    private String password;
    private String last_name;
    private String first_name;
    private String phone;
    
    // 기본 생성자
    public UserDTO() {}
    
    // Getter, Setter 메소드들
    public int getIdx() {
        return idx;
    }
    
    public void setIdx(int idx) {
        this.idx = idx;
    }
    
    public String getUser_id() {
        return user_id;
    }
    
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getLast_name() {
        return last_name;
    }
    
    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }
    
    public String getFirst_name() {
        return first_name;
    }
    
    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    // 헬퍼 메소드들
    public String getFullName() {
        return last_name + first_name;
    }
    
    // 전화번호 마스킹 (보안용)
    public String getMaskedPhone() {
        if (phone != null && phone.length() >= 8) {
            return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
        }
        return phone;
    }
}

// 회원 주소 정보 DTO
class UserAddressDTO {
    private int user_addr_idx;
    private String last_name;
    private String first_name;
    private int post_num;
    private String addr;
    private String detail_addr;
    private int idx; // users 테이블의 외래키
    
    // 기본 생성자
    public UserAddressDTO() {}
    
    // Getter, Setter 메소드들
    public int getUser_addr_idx() {
        return user_addr_idx;
    }
    
    public void setUser_addr_idx(int user_addr_idx) {
        this.user_addr_idx = user_addr_idx;
    }
    
    public String getLast_name() {
        return last_name;
    }
    
    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }
    
    public String getFirst_name() {
        return first_name;
    }
    
    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }
    
    public int getPost_num() {
        return post_num;
    }
    
    public void setPost_num(int post_num) {
        this.post_num = post_num;
    }
    
    public String getAddr() {
        return addr;
    }
    
    public void setAddr(String addr) {
        this.addr = addr;
    }
    
    public String getDetail_addr() {
        return detail_addr;
    }
    
    public void setDetail_addr(String detail_addr) {
        this.detail_addr = detail_addr;
    }
    
    public int getIdx() {
        return idx;
    }
    
    public void setIdx(int idx) {
        this.idx = idx;
    }
    
    // 헬퍼 메소드들
    public String getFullName() {
        return last_name + first_name;
    }
    
    public String getFullAddress() {
        return addr + " " + detail_addr + " (" + post_num + ")";
    }
}