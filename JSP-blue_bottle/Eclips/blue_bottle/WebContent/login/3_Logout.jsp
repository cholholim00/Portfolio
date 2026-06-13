<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    session.removeAttribute("UserId");
    session.removeAttribute("UserName");
    session.removeAttribute("UserIdx");

    session.invalidate();

    response.sendRedirect("../main/index.jsp");
%>
