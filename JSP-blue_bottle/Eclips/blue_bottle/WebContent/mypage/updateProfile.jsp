<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
		request.setCharacterEncoding("UTF-8");
		String last_name = request.getParameter("last_name");
		String first_name = request.getParameter("first_name");
		String phone = request.getParameter("phone");
		int user_idx = Integer.parseInt(request.getParameter("user_idx"));
		System.out.println(last_name);
		System.out.println(first_name);
		System.out.println(phone);
		System.out.println(user_idx);

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
				String url = "jdbc:oracle:thin:@localhost:1521:xe";
				String id = "musthave";
				String pwd = "1234";
				Class.forName("oracle.jdbc.OracleDriver");
				conn = DriverManager.getConnection(url, id, pwd);
				
				String sql = "UPDATE users SET last_name = ?, first_name = ?, phone = ? WHERE idx=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, last_name);
				pstmt.setString(2, first_name);
				pstmt.setString(3, phone);
				pstmt.setInt(4, user_idx);
        pstmt.executeUpdate();
        pstmt.close();
        out.println("<script>alert('계정정보가 수정되었습니다.'); location.href='./bluebottlecoffee_account.jsp';</script>");
		}catch(Exception e){
				System.out.println(e.getMessage());
		}
%>