package Address;

public class AddressDTO {
	private int userAddrIdx;
    private String lastName;
    private String firstName;
    private String phone;
    private int postNum;
    private String addr;
    private String detailAddr;
    private int idx;
    private boolean isDefault;
    
    public String getFullName() {
        return this.lastName + " " + this.firstName;
    }

    public String getFullAddress() {
        return this.addr + " " + this.detailAddr;
    }

    
	public boolean isDefault() {
		return isDefault;
	}
	public void setDefault(boolean isDefault) {
		this.isDefault = isDefault;
	}
	public int getUserAddrIdx() {
		return userAddrIdx;
	}
	public void setUserAddrIdx(int userAddrIdx) {
		this.userAddrIdx = userAddrIdx;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public int getPostNum() {
		return postNum;
	}
	public void setPostNum(int postNum) {
		this.postNum = postNum;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getDetailAddr() {
		return detailAddr;
	}
	public void setDetailAddr(String detailAddr) {
		this.detailAddr = detailAddr;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
    
    
}
