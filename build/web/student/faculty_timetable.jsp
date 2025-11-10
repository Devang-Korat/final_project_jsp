<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if faculty is logged in
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null || !"faculty".equals(sess.getAttribute("role"))) {
    response.sendRedirect("../login.html");
    return;
}
int facultyId = (Integer) sess.getAttribute("userid");

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Timetable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
        }
        .container {
            max-width: 1000px;
            background: #fff;
            margin-top: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #3246d3;
            margin-bottom: 25px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th {
            background-color: #3246d3;
            color: white;
            text-align: center;
        }
        td, th {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
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

<div class="container">
    <h2>📘 My Teaching Timetable</h2>

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

                    String sql = "SELECT day, course, class, semester, subject_name, time_slot, class_location FROM timetable WHERE faculty_id = ? ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), time_slot";
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

</body>
</html>
