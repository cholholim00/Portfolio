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

	String last_name = request.getParameter("last_name");
	String first_name = request.getParameter("first_name");
	String post_num = request.getParameter("zipcode");
	String addr = request.getParameter("address");
	String detail_addr = request.getParameter("detail_address");
	
	System.out.println(last_name);
	System.out.println(first_name);
	System.out.println(post_num);
	System.out.println(addr);
	System.out.println(detail_addr);
	System.out.println(phone);
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String id = "musthave";
		String pwd = "1234";
		Class.forName("oracle.jdbc.OracleDriver");
		conn = DriverManager.getConnection(url, id, pwd);
		
		String sql = "INSERT INTO user_addr(last_name, first_name, post_num, addr, detail_addr, idx, phone) VALUES(?,?,?,?,?,?,?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, last_name);
		pstmt.setString(2, first_name);
		pstmt.setString(3, post_num);
		pstmt.setString(4, addr);
		pstmt.setString(5, detail_addr);
		pstmt.setInt(6, user_idx);
		pstmt.setString(7, phone);
		pstmt.executeUpdate();
		out.println("<script>alert('주소등록이 완료되었습니다.'); location.href='./bluebottlecoffee_account_addresses.jsp';</script>");
		//rs = pstmt.executeQuery();
		
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	
%>