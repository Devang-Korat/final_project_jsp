<%@ page import="java.sql.*" %>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");

if (email == null || password == null) {
    response.sendRedirect("login.html");
    return;
}
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

    // 1. Check Admin
    ps = con.prepareStatement("SELECT * FROM admin WHERE email=? AND password=?");
    ps.setString(1, email);
    ps.setString(2, password);
    rs = ps.executeQuery();
    if (rs.next()) {
        session.setAttribute("role", "admin");
        session.setAttribute("userid", rs.getInt("admin_id"));
        response.sendRedirect("admin/Admin_Dashboard.jsp");
        return;
    }

    // 2. Check Faculty
    ps = con.prepareStatement("SELECT * FROM faculty WHERE email=? AND password=?");
    ps.setString(1, email);
    ps.setString(2, password);
    rs = ps.executeQuery();
    if (rs.next()) {
        session.setAttribute("role", "faculty");
        session.setAttribute("userid", rs.getInt("faculty_id"));
        response.sendRedirect("Faculty/Faculty_Dashboard.jsp");
        return;
    }

    // 3. Check Student
    ps = con.prepareStatement("SELECT * FROM students WHERE email=? AND password=?");
    ps.setString(1, email);
    ps.setString(2, password);
    rs = ps.executeQuery();
    if (rs.next()) {
        session.setAttribute("role", "student");
        session.setAttribute("userid", rs.getInt("student_id"));
        response.sendRedirect("student/student_dashboard.jsp");
        return;
    }

    // 4. Invalid credentials
    out.println("<script>alert('Invalid Email or Password!'); window.location='login.html';</script>");

} catch (Exception e) {
    out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='login.html';</script>");
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
}
%>
