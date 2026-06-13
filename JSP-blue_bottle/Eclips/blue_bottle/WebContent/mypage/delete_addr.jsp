<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>

<%
		int user_addr_idx = Integer.parseInt(request.getParameter("user_addr_idx"));    

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
				String url = "jdbc:oracle:thin:@localhost:1521:xe";
				String id = "musthave";
				String pwd = "1234";
				Class.forName("oracle.jdbc.OracleDriver");
				conn = DriverManager.getConnection(url, id, pwd);
				
				String sql = "DELETE FROM user_addr WHERE user_addr_idx=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, user_addr_idx);
				pstmt.executeUpdate();
				pstmt.close();
				out.println("<script>alert('주소가 삭제되었습니다.'); location.href='./bluebottlecoffee_account_addresses.jsp';</script>");

		}catch(Exception e){
				System.out.println(e.getMessage());
		}
%>