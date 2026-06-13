<%@ page import="java.sql.*" %>
<%@ page import="membership.MemberDAO" %>
<%@ page import="membership.MemberDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

String lastName = request.getParameter("name_list1");
String firstName = request.getParameter("name_list2");
String email = request.getParameter("email_list");
String phone = request.getParameter("phone_list");
String password1 = request.getParameter("pwd_list1");
String password2 = request.getParameter("pwd_list2");

String check1 = request.getParameter("check_box1");
String check2 = request.getParameter("check_box2");
String check3 = request.getParameter("check_box3");
String check4 = request.getParameter("check_box4");

if (!password1.equals(password2)) {
	out.println("history.back();");
    return;
}

if (check1 == null || check2 == null || check3 == null || check4 == null) {
	out.println("history.back();");
    return;
}

String oracleDriver = application.getInitParameter("oracleDriver");
String oracleURL = application.getInitParameter("oracleUrl");
String oracleId = application.getInitParameter("oracleId");
String oraclePwd = application.getInitParameter("oraclePwd");

MemberDTO memberDTO = new MemberDTO();
memberDTO.setLast_name(lastName);
memberDTO.setFirst_name(firstName);
memberDTO.setUser_id(email); 
memberDTO.setPassword(password1);
memberDTO.setPhone(phone);

MemberDAO dao = new MemberDAO(oracleDriver, oracleURL, oracleId, oraclePwd);
int result = dao.insertMember(memberDTO);
System.out.println(result);
dao.close();

if (result == 1) {
		out.println("<script>alert('회원가입 성공 !')");
    response.sendRedirect("../login/bluebottlecoffee_account_login.jsp");
} else {
    out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
}
%>
