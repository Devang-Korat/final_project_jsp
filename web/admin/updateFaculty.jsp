<%@ page import="java.sql.*" %>
<%
    int facultyId = Integer.parseInt(request.getParameter("faculty_id"));
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String department = request.getParameter("department");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement(
            "UPDATE faculty SET name=?, email=?, phone=?, department=? WHERE faculty_id=?"
        );
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, department);
        ps.setInt(5, facultyId);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("Faculty.jsp?msg=updated");
        } else {
            out.println("<script>alert('Update failed!'); window.location='Faculty.jsp';</script>");
        }

        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='Faculty.jsp';</script>");
    }
%>
