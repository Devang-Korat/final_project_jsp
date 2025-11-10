<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String facultyName = "Professor";

    Connection con = null;
    StringBuilder studentTable = new StringBuilder();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // Fetch faculty name
        PreparedStatement ps = con.prepareStatement("SELECT name FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            facultyName = rs.getString("name");
        }
        rs.close();
        ps.close();

        // Fetch all students
        Statement st = con.createStatement();
        ResultSet rsStu = st.executeQuery("SELECT * FROM students ORDER BY name ASC");

        while (rsStu.next()) {
            studentTable.append("<tr>");
            studentTable.append("<td>").append(rsStu.getString("Enrollment")).append("</td>");
            studentTable.append("<td>").append(rsStu.getString("name")).append("</td>");
            studentTable.append("<td>").append(rsStu.getString("email")).append("</td>");
            studentTable.append("<td>").append(rsStu.getString("course")).append("</td>");
            studentTable.append("<td>").append(rsStu.getInt("semester")).append("</td>");
            studentTable.append("<td>").append(rsStu.getString("phone")).append("</td>");
            studentTable.append("</tr>");
        }

        if (studentTable.length() == 0) {
            studentTable.append("<tr><td colspan='6' class='text-center text-muted'>No students found.</td></tr>");
        }

        rsStu.close();
        st.close();

    } catch (Exception e) {
        e.printStackTrace();
        studentTable.append("<tr><td colspan='6' style='color:red;'>Database error loading students.</td></tr>");
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard - Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f7f9fc; font-family: 'Poppins', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; left: 0; top: 0; background: linear-gradient(180deg, #3b4fe4, #5563de); color: #fff; padding-top: 30px; }
        .sidebar h4 { text-align: center; margin-bottom: 30px; }
        .sidebar a { display: flex; align-items: center; color: white; padding: 12px 25px; text-decoration: none; margin: 5px 0; gap: 10px; }
        .sidebar a:hover, .sidebar a.active { background: rgba(255,255,255,0.2); border-radius: 8px; }
        .main-content { margin-left: 250px; padding: 30px; }
        .header-section { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .header-section .title { font-size: 1.8rem; font-weight: 600; color: #333; }
        .header-section .welcome-text { font-size: 1.5rem; color: #3b4fe4; font-weight: 700; }

        /* Student Table Styling */
        .student-table th { background-color: #3b4fe4; color: white; text-align: center; }
        .student-table td { text-align: center; vertical-align: middle; }
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
         <a href="Faculty_Students.jsp"  class="active"><i class="bi bi-people-fill"></i> Students</a>
         <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i>  Attendance</a>
         <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Study Materials</a>
         <a href="Faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
         <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
         <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header-section">
            <div class="title"><i class="bi bi-people-fill me-2"></i> Student Details</div>
            <div class="welcome-text">Prof. <%= facultyName %></div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <table class="table table-striped table-hover student-table">
                    <thead>
                        <tr>
                            <th>Enrollment No.</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Course</th>
                            <th>Semester</th>
                            <th>Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%= studentTable.toString() %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>
