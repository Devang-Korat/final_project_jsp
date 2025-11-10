<%-- 
    Document   : register
    Created on : 2 Nov 2025, 2:14:56?pm
    Author     : ADMIN
--%>
<%-- 
    Document   : register
    Created on : 2 Nov 2025, 2:14:56 pm
    Author     : ADMIN
--%>
<%@ page import="java.sql.*" %>
<%
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");
String department = request.getParameter("department");
String phone = request.getParameter("phone");

try {
    // Load JDBC driver
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    // Connect to the database
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
    
    // SQL insert statement for 'faculty' table
    String sql = "INSERT INTO faculty (name, email, password, department, phone) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement ps = con.prepareStatement(sql);
    
    ps.setString(1, name);
    ps.setString(2, email);
    ps.setString(3, password);
    ps.setString(4, department);
    ps.setString(5, phone);
    
    int i = ps.executeUpdate();
    
    if (i > 0) {
        out.println("<script>alert('Faculty Registration Successful!'); window.location='../login.html';</script>");
    } else {
        out.println("<script>alert('Faculty Registration Failed! Please try again.'); window.location='register.html';</script>");
    }
    
    con.close();
    
} catch (SQLException e) {
    out.println("<script>alert('Database Error: " + e.getMessage().replace("'", "\\'") + "'); window.history.back();</script>");
} catch (Exception e) {
    out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.history.back();</script>");
}
%>


