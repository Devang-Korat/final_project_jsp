<%@ page import="java.sql.*" %>
<%
String Enrollment = request.getParameter("enrollment");
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");
String course = request.getParameter("course");
String class1 = request.getParameter("class1");
String semester = request.getParameter("semester");
String phone = request.getParameter("phone");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

    String sql = "INSERT INTO students (Enrollment, name, email, password, course, Class, semester, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setString(1, Enrollment);
    ps.setString(2, name);
    ps.setString(3, email);
    ps.setString(4, password);
    ps.setString(5, course);
    ps.setString(6, class1);
    ps.setString(7, semester);
    ps.setString(8, phone);

    int i = ps.executeUpdate();

    if (i > 0) {
        out.println("<script>alert('Registration Successful!'); window.location='../login.html';</script>");
    } else {
        out.println("<script>alert('Registration Failed!');</script>");
    }

    con.close();
} catch (SQLException e) {
    out.println("<p style='color:red;'>SQL Exception: " + e.getMessage() + "</p>");
} catch (Exception e) {
    out.println("<p style='color:red;'>General Error: " + e.getMessage() + "</p>");
}
%>


