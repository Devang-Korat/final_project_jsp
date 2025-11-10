<%@ page import="java.sql.*" %>
<%
    int facultyId = Integer.parseInt(request.getParameter("faculty_id"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // Delete faculty subjects first to maintain referential integrity
        PreparedStatement ps1 = con.prepareStatement("DELETE FROM faculty_subjects WHERE faculty_id=?");
        ps1.setInt(1, facultyId);
        ps1.executeUpdate();
        ps1.close();

        // Now delete the faculty record
        PreparedStatement ps2 = con.prepareStatement("DELETE FROM faculty WHERE faculty_id=?");
        ps2.setInt(1, facultyId);
        int rows = ps2.executeUpdate();
        ps2.close();

        con.close();

        if (rows > 0) {
            response.sendRedirect("Faculty.jsp?msg=deleted");
        } else {
            out.println("<script>alert('Error: Faculty not found!'); window.location='Faculty.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Database Error: " + e.getMessage() + "'); window.location='Faculty.jsp';</script>");
    }
%>
