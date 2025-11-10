<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int studentId = (Integer) sess.getAttribute("userid");
    String name = request.getParameter("name");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("UPDATE students SET name=? WHERE student_id=?");
        ps.setString(1, name);
        ps.setInt(2, studentId);
        ps.executeUpdate();
        con.close();
        response.sendRedirect("viewprofile.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
