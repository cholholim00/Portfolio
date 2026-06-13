package Address;

import Address.AddressDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {
    private String url = "jdbc:oracle:thin:@localhost:1521:xe";
    private String username = "your_username";
    private String password = "your_password";
    

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle Driver not found", e);
        }
    }
    

    public boolean insertAddress(AddressDTO address) {
        String sql = "INSERT INTO user_addr (user_addr_idx, last_name, first_name, phone, post_num, addr, detail_addr, idx, is_default) " +
                    "VALUES (user_addr_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            

            if (address.isDefault()) {
                updateDefaultAddress(address.getIdx(), false);
            }
            
            pstmt.setString(1, address.getLastName());
            pstmt.setString(2, address.getFirstName());
            pstmt.setString(3, address.getPhone());
            pstmt.setInt(4, address.getPostNum());
            pstmt.setString(5, address.getAddr());
            pstmt.setString(6, address.getDetailAddr());
            pstmt.setInt(7, address.getIdx());
            pstmt.setString(8, address.isDefault() ? "Y" : "N");
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    

    public List<AddressDTO> getAddressesByUserId(int userId) {
        List<AddressDTO> addresses = new ArrayList<>();
        String sql = "SELECT * FROM user_addr WHERE idx = ? ORDER BY is_default DESC, user_addr_idx ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AddressDTO address = new AddressDTO();
                address.setUserAddrIdx(rs.getInt("user_addr_idx"));
                address.setLastName(rs.getString("last_name"));
                address.setFirstName(rs.getString("first_name"));
                address.setPhone(rs.getString("phone"));
                address.setPostNum(rs.getInt("post_num"));
                address.setAddr(rs.getString("addr"));
                address.setDetailAddr(rs.getString("detail_addr"));
                address.setIdx(rs.getInt("idx"));
                address.setDefault("Y".equals(rs.getString("is_default")));
                
                addresses.add(address);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return addresses;
    }

    public boolean updateAddress(AddressDTO address) {
        String sql = "UPDATE user_addr SET last_name=?, first_name=?, phone=?, post_num=?, addr=?, detail_addr=?, is_default=? " +
                    "WHERE user_addr_idx=? AND idx=?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (address.isDefault()) {
                updateDefaultAddress(address.getIdx(), false);
            }
            
            pstmt.setString(1, address.getLastName());
            pstmt.setString(2, address.getFirstName());
            pstmt.setString(3, address.getPhone());
            pstmt.setInt(4, address.getPostNum());
            pstmt.setString(5, address.getAddr());
            pstmt.setString(6, address.getDetailAddr());
            pstmt.setString(7, address.isDefault() ? "Y" : "N");
            pstmt.setInt(8, address.getUserAddrIdx());
            pstmt.setInt(9, address.getIdx());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAddress(int addressIdx, int userId) {
        String sql = "DELETE FROM user_addr WHERE user_addr_idx=? AND idx=?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, addressIdx);
            pstmt.setInt(2, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void updateDefaultAddress(int userId, boolean setDefault) {
        String sql = "UPDATE user_addr SET is_default=? WHERE idx=?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, setDefault ? "Y" : "N");
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public AddressDTO getAddressById(int addressIdx, int userId) {
        String sql = "SELECT * FROM user_addr WHERE user_addr_idx=? AND idx=?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, addressIdx);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                AddressDTO address = new AddressDTO();
                address.setUserAddrIdx(rs.getInt("user_addr_idx"));
                address.setLastName(rs.getString("last_name"));
                address.setFirstName(rs.getString("first_name"));
                address.setPhone(rs.getString("phone"));
                address.setPostNum(rs.getInt("post_num"));
                address.setAddr(rs.getString("addr"));
                address.setDetailAddr(rs.getString("detail_addr"));
                address.setIdx(rs.getInt("idx"));
                address.setDefault("Y".equals(rs.getString("is_default")));
                
                return address;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}