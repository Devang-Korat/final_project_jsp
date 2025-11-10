<%@ page import="java.sql.*" %>

<%
    int id = Integer.parseInt(request.getParameter("student_id"));
    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        PreparedStatement ps = con.prepareStatement("DELETE FROM students WHERE student_id=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();

        if (rows > 0) {
            out.println("<script>alert('Student record deleted successfully!'); window.location='Students.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to delete student record.'); window.location='Students.jsp';</script>");
        }

        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='Students.jsp';</script>");
    }
%>
