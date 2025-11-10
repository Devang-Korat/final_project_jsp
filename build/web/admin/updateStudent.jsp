<%@ page import="java.sql.*" %>

<%
    int id = Integer.parseInt(request.getParameter("student_id"));
    String enrollment = request.getParameter("enrollment");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String course = request.getParameter("course");
    String className = request.getParameter("className");
    String semester = request.getParameter("semester");

    Connection con = null;
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        PreparedStatement ps = con.prepareStatement(
            "UPDATE students SET Enrollment=?, name=?, email=?, phone=?, course=?, Class=?, semester=? WHERE student_id=?"
        );

        ps.setString(1, enrollment);
        ps.setString(2, name);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, course);
        ps.setString(6, className);
        ps.setString(7, semester);
        ps.setInt(8, id);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            out.println("<script>alert('Student details updated successfully!'); window.location='Students.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to update student details.'); window.location='Students.jsp';</script>");
        }

        ps.close();
        con.close();

    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='Students.jsp';</script>");
    }
%>
