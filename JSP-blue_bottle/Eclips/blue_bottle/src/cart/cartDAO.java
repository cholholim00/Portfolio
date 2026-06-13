package cart;

import javax.servlet.ServletContext;

import common.JDBConnect;

public class cartDAO extends JDBConnect {
	public cartDAO(ServletContext application) {
		super(application);
	}
	
	// 1. cart 테이블에 세션으로 받아온 user_idx 삽입 (insert)
//	public int insertCart(cartDTO cart) {
//		int count = 0;
//		String query = "INSERT INTO cart(user_idx) VALUES(?)";
//		try {
//			pstmt = getConnection().prepareStatement(query);
//			pstmt.setInt(1, cart.getUser_idx());
//			count = pstmt.executeUpdate();
//		}catch(Exception e) {
//			System.out.println("Exception[insertCart]:"+e.getMessage());
//		}
//		return count;
//	}
	
	// 2. cart 테이블에서 해당 user_idx의 cart_idx 값을 가져오기 (select)
//	public cartDTO selectCartIdx(int user_idx) {
//		cartDTO cart = null;
//		String query = "SELECT product_idx FROM cart_item WHERE user_idx=?";
//		try {
//			pstmt = getConnection().prepareStatement(query);
//			pstmt.setInt(1, user_idx);
//			rs = pstmt.executeQuery();
//			if(rs.next()) {
//				cart = new cartDTO();
//				cart.setCart_idx(rs.getInt("product_idx"));
//			}
//		}catch(Exception e) {
//			System.out.println("Exception[selectCartIdx]:"+e.getMessage());
//		}
//		
//		return cart;
//	}
	public boolean hasProductInCart(int user_idx, String product_idx) {
	    boolean exists = false;
	    String query = "SELECT * FROM cart_item WHERE user_idx = ? AND product_idx = ?";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, user_idx);
	        pstmt.setString(2, product_idx);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            exists = true; // 이미 담은 상품 있음
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[hasProductInCart]: " + e.getMessage());
	    }
	    return exists;
	}
	
	// 3. cart_item 테이블에 상품 삽입 (insert)
	public int insertCartItem(cartDTO cart) {
		int count = 0;
		String query = "INSERT INTO cart_item(quantity,price,options,product_idx,img_src,user_idx) VALUES"
				+ "(?,?,?,?,?,?)";
		System.out.println(query);
		try {
			pstmt = getConnection().prepareStatement(query);
			pstmt.setInt(1, cart.getQuantity());
			pstmt.setInt(2, cart.getPrice());
			pstmt.setString(3, cart.getOption());
			pstmt.setString(4, cart.getProduct_idx());
			pstmt.setString(5, cart.getImg_src());
			pstmt.setInt(6, cart.getUser_idx());
			count = pstmt.executeUpdate();
		}catch(Exception e) {
			System.out.println("Exception[insertCartItem]:" + e.getMessage());
		}
		return count;
	}
	
	
	
	
	
}
