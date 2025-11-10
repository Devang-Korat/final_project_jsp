<%-- 
    Document   : logout
    Created on : 08-Nov-2025, 6:08:13 pm
    Author     : Yagnik
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // End session
    session.invalidate();

    // Redirect to login.jsp (one folder up)
    response.sendRedirect("../login.jsp");
%>

