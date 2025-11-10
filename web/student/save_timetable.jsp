<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    String course = request.getParameter("course");
    String className = request.getParameter("class");
    int semester = Integer.parseInt(request.getParameter("semester"));
    String day = request.getParameter("day");
    String subject_name = request.getParameter("subject_name");
    int faculty_id = Integer.parseInt(request.getParameter("faculty_id"));
    String time_slot = request.getParameter("time_slot");
    String classLocation = request.getParameter("class_location");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        String sql = "INSERT INTO timetable (course, semester, day, subject_name, faculty_id, time_slot, class_location, class) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, course);
        ps.setInt(2, semester);
        ps.setString(3, day);
        ps.setString(4, subject_name);
        ps.setInt(5, faculty_id);
        ps.setString(6, time_slot);
        ps.setString(7, classLocation);
        ps.setString(8, className);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.println("<script>alert('Timetable created successfully!'); window.location='create_timetable.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to create timetable'); window.history.back();</script>");
        }
        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
%>
