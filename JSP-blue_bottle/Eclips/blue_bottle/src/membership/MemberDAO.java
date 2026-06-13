package membership;

import bluebottle.JDBConnect;

public class MemberDAO  extends JDBConnect {
	public MemberDAO(String driver, String url, String id, String pwd) {
	    super(url, id, pwd, driver); 
	}


    public MemberDTO getMemberDTO(String uid, String upass) {
        MemberDTO dto = new MemberDTO();
        String query = "SELECT * FROM users WHERE USER_ID = ? AND PASSWORD = ?";
        System.out.println("입력된 아이디: " + uid);
        System.out.println("입력된 비밀번호: " + upass);
        System.out.println("DB 연결 여부: " + (con != null));


        try {
            psmt = con.prepareStatement(query);
            psmt.setString(1, uid);
            psmt.setString(2, upass);
            rs = psmt.executeQuery();

            if (rs.next()) {
                dto.setIdx(rs.getInt("idx"));
                dto.setUser_id(rs.getString("user_id"));
                dto.setPassword(rs.getString("password"));
                dto.setLast_name(rs.getString("last_name"));
                dto.setFirst_name(rs.getString("first_name"));
                dto.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }
    
    public int insertMember(MemberDTO dto) {
        int result = 0;
        try {
            String query = "INSERT INTO users (idx, last_name, first_name, user_id, password, phone) "
                         + "VALUES (seq_users_idx.NEXTVAL, ?, ?, ?, ?, ?)";
            psmt = con.prepareStatement(query);
            psmt.setString(1, dto.getLast_name());
            psmt.setString(2, dto.getFirst_name());
            psmt.setString(3, dto.getUser_id());
            psmt.setString(4, dto.getPassword());
            psmt.setString(5, dto.getPhone());

            result = psmt.executeUpdate();
            System.out.println(result);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
//    public boolean updateMemberInfo(int idx, String lastName, String firstName, String phone) {
//        boolean result = false;
//        try {
//            String query = "UPDATE member SET last_name = ?, first_name = ?, phone = ? WHERE idx = ?";
//            psmt = con.prepareStatement(query);
//            psmt.setString(1, lastName);
//            psmt.setString(2, firstName);
//            psmt.setString(3, phone);
//            psmt.setInt(4, idx);
//
//            int affected = psmt.executeUpdate();
//            if (affected == 1) result = true;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return result;
//    }
}
