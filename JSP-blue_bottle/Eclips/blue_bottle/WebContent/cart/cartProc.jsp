<%@page import="java.util.List"%>
<%@page import="cart.cartPayDAO"%>
<%@page import="cart.cartPayDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<%
	request.setCharacterEncoding("UTF-8");

	String product_idx = request.getParameter("product_idx");
	System.out.println(product_idx);
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
			String url = "jdbc:oracle:thin:@localhost:1521:xe";
			String id = "musthave";
			String pwd = "1234";
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection(url, id, pwd);
			
			String sql = "DELETE FROM cart_item WHERE product_idx=? AND user_idx=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, product_idx);
			pstmt.setInt(2, user_idx);
    	pstmt.executeUpdate();
    	pstmt.close();
    	out.println("<script>location.href='./cart.jsp'</script>");
		}catch(Exception e){
				System.out.println(e.getMessage());
		}
%>