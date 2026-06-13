package cart;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

import common.JDBConnect;

public class cartPayDAO extends JDBConnect {
	public cartPayDAO(ServletContext application) {
		super(application); 
	}
	
	public int selectCount(Map<String, Object> map) {
		return 0;
	}
	
	public List<cartPayDTO> selectList(int user_idx){
		List<cartPayDTO> list = new Vector<cartPayDTO>();
		String query = "SELECT ci.*, p.name AS product_name " +
                "FROM cart_item ci " +
                "JOIN product p ON ci.product_idx = p.product_idx " +
                "WHERE ci.user_idx = ?";
		try {
			pstmt = getConnection().prepareStatement(query);
			pstmt.setInt(1, user_idx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				cartPayDTO dto = new cartPayDTO();
				dto.setImg_src(rs.getString("img_src"));
				dto.setPrice(rs.getInt("price"));
				dto.setProduct_idx(rs.getString("product_idx"));
				dto.setQuantity(rs.getInt("quantity"));
				dto.setUser_idx(rs.getInt("user_idx"));
				dto.setProduct_name(rs.getString("product_name"));
				list.add(dto);
			}
			
		}catch(Exception e) {
			System.out.println("Exception[List]:"+e.getMessage());
		}
		
		return list;
	}
	
	
	
}
