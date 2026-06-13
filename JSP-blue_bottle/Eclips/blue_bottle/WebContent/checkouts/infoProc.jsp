<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<%
	request.setCharacterEncoding("UTF-8");
	
	
	String name = request.getParameter("user_name"); // order
	int post_num = Integer.parseInt(request.getParameter("post_num")); // order
	String addr = request.getParameter("addr"); // order
	
	System.out.println("\n\n[infoProc.jsp]\nname:"+name+"\npost_num:"+post_num+"\naddr:"+addr+"\nphone:"+phone+"\n");
	/////////////////////////////////////////////////////////////
	int index = Integer.parseInt(request.getParameter("index"));
  int total_price = Integer.parseInt(request.getParameter("total-price")); // order
  
  String gift_name = request.getParameter("gift-name");
  String gift_price = request.getParameter("gift-price");
  String gift_idx = request.getParameter("gift-idx");
  
  String[] names = new String[index];
  int[] quantities = new int[index];
  String[] prices = new String[index];
  String[] products = new String[index];

  // hidden input 값 받기
	 for (int i = 1; i < index; i++) {
	     names[i] = request.getParameter("name" + i);
	     quantities[i] = Integer.parseInt(request.getParameter("quantity" + i));
	     prices[i] = request.getParameter("price" + i);
	     products[i] = request.getParameter("product" + i);
	 }

  // 확인을 위한 출력
  for (int i = 1; i < index; i++) {
      System.out.println("name: " + names[i] + ", quantity: " + quantities[i] + ", price: " + prices[i] + ", product_idx: " + products[i]);
  }
  if(!gift_name.isEmpty()){
	  	int gift_quantity = Integer.parseInt(request.getParameter("gift-quantity"));
	  	System.out.println("gift_name: "+gift_name+", gift_quantity: "+gift_quantity+", gift_price: "+gift_price + ", gift_idx: " + gift_idx);
	  }
	System.out.println("total_price: "+total_price+", index: "+index+"\n\n");
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	String cardNum1 = request.getParameter("cardNum1");
	String cardNum2 = request.getParameter("cardNum2");
	String cardNum3 = request.getParameter("cardNum3");
	String cardNum4 = request.getParameter("cardNum4");
	
	String card_name = request.getParameter("card"); // order
	String card_num = cardNum1+"-"+cardNum2+"-"+cardNum3+"-"+cardNum4; // order
	int ex_month = Integer.parseInt(request.getParameter("expirationMonth")); // order
	int ex_year = Integer.parseInt(request.getParameter("expirationYear")); // order
	int birth = Integer.parseInt(request.getParameter("birth")); // order
	int card_pw = Integer.parseInt(request.getParameter("cardPass")); // order
	String installment = request.getParameter("installment"); // order
	
	System.out.println("card_name:"+card_name+"\ncard_num:"+card_num+"\nex_month:"+ex_month+"\nex_year:"+ex_year+"\nbirth:"+birth+"\ncard_pw:"+card_pw+"\ninstallment:"+installment+"\n");
	
	try{
		Connection conn = null;
		PreparedStatement pstmt = null;
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String id = "musthave";
		String pwd = "1234";
		Class.forName("oracle.jdbc.OracleDriver");
		conn = DriverManager.getConnection(url, id, pwd);
		
		String sql = "INSERT INTO orders(total_price, name, post_num, addr, phone, card_name, card_num, ex_month, ex_year, birth, card_pw, installment, user_idx) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, total_price);
		pstmt.setString(2, name);
		pstmt.setInt(3, post_num);
		pstmt.setString(4, addr);
		pstmt.setString(5, phone);
		pstmt.setString(6, card_name);
		pstmt.setString(7, card_num);
		pstmt.setInt(8, ex_month);
		pstmt.setInt(9, ex_year);
		pstmt.setInt(10, birth);
		pstmt.setInt(11, card_pw);
		pstmt.setString(12, installment);
		pstmt.setInt(13, user_idx);
		pstmt.executeUpdate();
		
		for(int i=1; i<index; i++){
			String query = "INSERT INTO order_item(quantity, price, product_idx, user_idx) VALUES(?,?,?,?)";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, quantities[i]);
			pstmt.setString(2, prices[i]);
			pstmt.setString(3, products[i]);
			pstmt.setInt(4, user_idx);
			pstmt.executeUpdate();
		}
		if(!gift_name.isEmpty()){
			int gift_quantity = Integer.parseInt(request.getParameter("gift-quantity"));
			String gift = "INSERT INTO order_item(quantity, price, product_idx, user_idx) VALUES(?,?,?,?)";
			pstmt = conn.prepareStatement(gift);
			pstmt.setInt(1, gift_quantity);
			pstmt.setString(2, gift_price);
			pstmt.setString(3, gift_idx);
			pstmt.setInt(4, user_idx);
			pstmt.executeUpdate();
		}

		out.println("<script>alert('결제가 완료되었습니다.');</script>");
		
		String del = "DELETE FROM cart_item WHERE user_idx=?";
		pstmt = conn.prepareStatement(del);
		pstmt.setInt(1, user_idx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
		
		out.println("<script>location.href='../cart/cart.jsp?idx="+user_idx+"'</script>");
		
	}catch(Exception e){
		out.println("<script>alert('DB연결에 실패했습니다.'); history.back();</script>");
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
%>






























