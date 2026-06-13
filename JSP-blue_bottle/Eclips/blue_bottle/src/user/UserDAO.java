package user;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class UserDAO extends JDBConnect {
    public UserDAO() {}

    // 전체 회원 목록 조회 (페이징 포함)
    public List<UserDTO> getAllUsers(int offset, int pageSize) {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT * FROM (" +
                    "    SELECT u.*, ROWNUM rnum FROM (" +
                    "        SELECT * FROM users ORDER BY idx DESC" +
                    "    ) u WHERE ROWNUM <= ?" +
                    ") WHERE rnum >= ?";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setInt(1, offset + pageSize);
            pstmt.setInt(2, offset + 1);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setIdx(rs.getInt("idx"));
                user.setUser_id(rs.getString("user_id"));
                user.setPassword(rs.getString("password"));
                user.setLast_name(rs.getString("last_name"));
                user.setFirst_name(rs.getString("first_name"));
                user.setPhone(rs.getString("phone"));
                userList.add(user);
            }
        } catch (Exception e) {
            System.out.println("Exception[getAllUsers]: " + e.getMessage());
            e.printStackTrace();
        }
        return userList;
    }
    
    // 전체 회원 수 조회
    public int getTotalUserCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Exception[getTotalUserCount]: " + e.getMessage());
        }
        return count;
    }
    
    // 특정 회원 정보 조회 (ID로)
    public UserDTO getUserById(String userId) {
        UserDTO user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new UserDTO();
                user.setIdx(rs.getInt("idx"));
                user.setUser_id(rs.getString("user_id"));
                user.setPassword(rs.getString("password"));
                user.setLast_name(rs.getString("last_name"));
                user.setFirst_name(rs.getString("first_name"));
                user.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            System.out.println("Exception[getUserById]: " + e.getMessage());
        }
        return user;
    }
    
    // 특정 회원 정보 조회 (idx로)
    public UserDTO getUserByIdx(int idx) {
        UserDTO user = null;
        String sql = "SELECT * FROM users WHERE idx = ?";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setInt(1, idx);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new UserDTO();
                user.setIdx(rs.getInt("idx"));
                user.setUser_id(rs.getString("user_id"));
                user.setPassword(rs.getString("password"));
                user.setLast_name(rs.getString("last_name"));
                user.setFirst_name(rs.getString("first_name"));
                user.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            System.out.println("Exception[getUserByIdx]: " + e.getMessage());
        }
        return user;
    }
    
    // 회원의 주소 정보 조회 (간단한 문자열 리스트로 반환)
    public List<String> getUserAddresses(int userIdx) {
        List<String> addressList = new ArrayList<>();
        String sql = "SELECT last_name, first_name, post_num, addr, detail_addr FROM user_addr WHERE idx = ? ORDER BY user_addr_idx";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String fullName = rs.getString("last_name") + rs.getString("first_name");
                String address = rs.getString("addr") + " " + rs.getString("detail_addr") + " (" + rs.getInt("post_num") + ")";
                addressList.add(fullName + " - " + address);
            }
        } catch (Exception e) {
            System.out.println("Exception[getUserAddresses]: " + e.getMessage());
        }
        return addressList;
    }
    
    // 회원 삭제 (연관 데이터도 함께 삭제)
    public boolean deleteUser(int userIdx) {
        try {
            // 트랜잭션 시작
            getConnection().setAutoCommit(false);
            
            // 1. 리뷰 이미지 삭제
            String deleteReviewImages = "DELETE FROM review_image WHERE review_idx IN " +
                                       "(SELECT review_idx FROM review WHERE user_idx = ?)";
            pstmt = getConnection().prepareStatement(deleteReviewImages);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 2. 리뷰 삭제
            String deleteReviews = "DELETE FROM review WHERE user_idx = ?";
            pstmt = getConnection().prepareStatement(deleteReviews);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 3. 주문 아이템 삭제
            String deleteOrderItems = "DELETE FROM order_item WHERE order_idx IN " +
                                     "(SELECT order_idx FROM orders WHERE user_idx = ?)";
            pstmt = getConnection().prepareStatement(deleteOrderItems);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 4. 주문 삭제
            String deleteOrders = "DELETE FROM orders WHERE user_idx = ?";
            pstmt = getConnection().prepareStatement(deleteOrders);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 5. 장바구니 아이템 삭제
            String deleteCartItems = "DELETE FROM cart_item WHERE cart_idx IN " +
                                    "(SELECT cart_idx FROM cart WHERE user_idx = ?)";
            pstmt = getConnection().prepareStatement(deleteCartItems);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 6. 장바구니 삭제
            String deleteCart = "DELETE FROM cart WHERE user_idx = ?";
            pstmt = getConnection().prepareStatement(deleteCart);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 7. 주소 삭제
            String deleteAddresses = "DELETE FROM user_addr WHERE idx = ?";
            pstmt = getConnection().prepareStatement(deleteAddresses);
            pstmt.setInt(1, userIdx);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 8. 회원 삭제
            String deleteUser = "DELETE FROM users WHERE idx = ?";
            pstmt = getConnection().prepareStatement(deleteUser);
            pstmt.setInt(1, userIdx);
            int result = pstmt.executeUpdate();
            
            // 커밋
            getConnection().commit();
            return result > 0;
            
        } catch (Exception e) {
            try {
                getConnection().rollback();
            } catch (SQLException se) {
                System.out.println("Rollback failed: " + se.getMessage());
            }
            System.out.println("Exception[deleteUser]: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                getConnection().setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // 회원 검색 (ID 또는 이름으로)
    public List<UserDTO> searchUsers(String searchType, String keyword, int offset, int pageSize) {
        List<UserDTO> userList = new ArrayList<>();
        String searchField = "";
        
        if ("user_id".equals(searchType)) {
            searchField = "user_id";
        } else if ("name".equals(searchType)) {
            searchField = "CONCAT(last_name, first_name)";
        }
        
        String sql = "SELECT * FROM (" +
                    "    SELECT u.*, ROWNUM rnum FROM (" +
                    "        SELECT * FROM users WHERE " + searchField + " LIKE ? ORDER BY idx DESC" +
                    "    ) u WHERE ROWNUM <= ?" +
                    ") WHERE rnum >= ?";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setInt(2, offset + pageSize);
            pstmt.setInt(3, offset + 1);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setIdx(rs.getInt("idx"));
                user.setUser_id(rs.getString("user_id"));
                user.setPassword(rs.getString("password"));
                user.setLast_name(rs.getString("last_name"));
                user.setFirst_name(rs.getString("first_name"));
                user.setPhone(rs.getString("phone"));
                userList.add(user);
            }
        } catch (Exception e) {
            System.out.println("Exception[searchUsers]: " + e.getMessage());
        }
        return userList;
    }
    
    // 검색 결과 수 조회
    public int getSearchResultCount(String searchType, String keyword) {
        int count = 0;
        String searchField = "";
        
        if ("user_id".equals(searchType)) {
            searchField = "user_id";
        } else if ("name".equals(searchType)) {
            searchField = "CONCAT(last_name, first_name)";
        }
        
        String sql = "SELECT COUNT(*) FROM users WHERE " + searchField + " LIKE ?";
        
        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Exception[getSearchResultCount]: " + e.getMessage());
        }
        return count;
    }
}