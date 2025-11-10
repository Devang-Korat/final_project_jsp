<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String facultyName = "N/A";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT name FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) facultyName = rs.getString("name");
        rs.close(); ps.close(); con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Faculty Timetable</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
    /* Shared layout styles */
    body { background-color: #f7f9fc; font-family: 'Poppins', sans-serif; }
    .sidebar {
        width: 240px;
        height: 100vh;
        position: fixed;
        left: 0; top: 0;
        background: linear-gradient(180deg, #3b4fe4, #5563de);
        color: #fff;
        padding-top: 30px;
    }
    .sidebar h4 { text-align: center; margin-bottom: 30px; }
    .sidebar a {
        display: flex;
        align-items: center;
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        margin: 5px 0;
        gap: 10px;
    }
    .sidebar a:hover, .sidebar .active {
        background: rgba(255,255,255,0.2);
        border-radius: 8px;
    }
    .sidebar svg { width: 18px; height: 18px; fill: white; }

    .main-content {
        margin-left: 250px;
        padding: 30px;
    }

    .header-section {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 30px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }
    .header-section .title {
        font-size: 1.8rem;
        font-weight: 600;
        color: #333;
    }
    .header-section .welcome-text {
        font-size: 1.5rem;
        color: #3b4fe4;
        font-weight: 700;
    }

    /* Timetable Styling */
    .timetable-container {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        padding: 30px;
        margin-top: 20px;
    }
    .timetable-title {
        font-size: 1.6rem;
        font-weight: 600;
        color: #3b4fe4;
        text-align: center;
        margin-bottom: 25px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        text-align: center;
    }
    th {
        background-color: #3b4fe4;
        color: white;
        padding: 12px;
    }
    td {
        padding: 10px;
        border: 1px solid #ddd;
        vertical-align: middle;
    }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #eef2ff; }
    .no-data {
        text-align: center;
        color: gray;
        font-style: italic;
        padding: 20px;
    }
</style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4 class="text-center mb-4">
        <svg xmlns="http://www.w3.org/2000/svg" fill="white" viewBox="0 0 24 24" width="20" height="20">
            <path d="M12 2L2 7v6c0 5 4 9 10 9s10-4 10-9V7l-10-5z"/>
        </svg> Faculty Portal
    </h4>

    <a href="Faculty_Dashboard.jsp"><i class="bi bi-grid-fill"></i> Dashboard</a>
    <a href="Faculty_Students.jsp"><i class="bi bi-people-fill"></i> Students</a>
    <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i> Attendance</a>
    <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Materials</a>
    <a href="Faculty_Timetable.jsp" class="active"><i class="bi bi-clock-history"></i> Timetable</a>
    <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
    <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="header-section">
        <div class="title"><i class="bi bi-clock-history"></i> Teaching Timetable</div>
        <div class="welcome-text">Prof. <%= facultyName %></div>
    </div>

    <div class="timetable-container">
        <h3 class="timetable-title"> My Teaching Schedule</h3>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Day</th>
                    <th>Course</th>
                    <th>Class</th>
                    <th>Semester</th>
                    <th>Subject</th>
                    <th>Time Slot</th>
                    <th>Location</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
                        String sql = "SELECT day, course, class, semester, subject_name, time_slot, class_location " +
                                     "FROM timetable WHERE faculty_id = ? " +
                                     "ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), time_slot";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, facultyId);
                        ResultSet rs = ps.executeQuery();

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                %>
                            <tr>
                                <td><%= rs.getString("day") %></td>
                                <td><%= rs.getString("course") %></td>
                                <td><%= rs.getString("class") %></td>
                                <td><%= rs.getInt("semester") %></td>
                                <td><%= rs.getString("subject_name") %></td>
                                <td><%= rs.getString("time_slot") %></td>
                                <td><%= rs.getString("class_location") %></td>
                            </tr>
                <%
                        }
                        if (!hasData) {
                %>
                            <tr><td colspan="7" class="no-data">No timetable assigned yet.</td></tr>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' class='no-data'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
