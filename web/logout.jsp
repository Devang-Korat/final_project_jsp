<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    // Get current session, if it exists
    HttpSession sess = request.getSession(false);

    // Invalidate session if found
    if (sess != null) {
        sess.invalidate();
    }

    // Redirect user to login page
    response.sendRedirect("login.html");
%>
