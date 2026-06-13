<%@ page import="membership.MemberDTO" %>
<%@ page import="membership.MemberDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

String userId = request.getParameter("user_id");  
String userPwd = request.getParameter("user_pw");

String oracleDriver = application.getInitParameter("oracleDriver");
String oracleURL = application.getInitParameter("oracleUrl");
String oracleId = application.getInitParameter("oracleId");
String oraclePwd = application.getInitParameter("oraclePwd");


MemberDAO dao = new MemberDAO(oracleDriver, oracleURL, oracleId, oraclePwd);
MemberDTO memberDTO = dao.getMemberDTO(userId, userPwd);
dao.close();

if (userId == null || userId.trim().isEmpty() || userPwd == null || userPwd.trim().isEmpty()) {
	request.setAttribute("LoginErrMsg", "이메일 또는 비밀번호가 잘못되었습니다.");
	request.getRequestDispatcher("bluebottlecoffee_account_login.jsp").forward(request, response);
    return;
}

if (memberDTO.getUser_id() != null) {
    session.setAttribute("user_idx", memberDTO.getIdx());
    session.setAttribute("user_id", memberDTO.getUser_id());
    session.setAttribute("first_name", memberDTO.getFirst_name());
    session.setAttribute("last_name", memberDTO.getLast_name());
    session.setAttribute("phone", memberDTO.getPhone());
    session.setAttribute("user_name", memberDTO.getLast_name() + memberDTO.getFirst_name());

    response.sendRedirect("../main/index.jsp");
} else {
    request.setAttribute("LoginErrMsg", "이메일 또는 비밀번호가 잘못되었습니다.");
	request.getRequestDispatcher("bluebottlecoffee_account_login.jsp").forward(request, response);
}

 %>