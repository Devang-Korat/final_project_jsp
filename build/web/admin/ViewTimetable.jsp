<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    int adminId = Integer.parseInt(sess.getAttribute("userid").toString());
    String adminName = "Admin";

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT name FROM admin WHERE admin_id=?");
        ps.setInt(1, adminId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            adminName = rs.getString("name");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    // --- Fetch timetable details ---
    int timetableId = 0;
    String course = "", semester = "", day = "", subject = "", timeSlot = "", className = "", classLocation = "", facultyName = "";
    String message = "";

    try {
        timetableId = Integer.parseInt(request.getParameter("id"));
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        String sql = "SELECT t.*, f.name AS faculty_name FROM timetable t LEFT JOIN faculty f ON t.faculty_id = f.faculty_id WHERE t.timetable_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, timetableId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            course = rs.getString("course");
            semester = rs.getString("semester");
            day = rs.getString("day");
            subject = rs.getString("subject_name");
            timeSlot = rs.getString("time_slot");
            className = rs.getString("class");
            classLocation = rs.getString("class_location");
            facultyName = rs.getString("faculty_name") != null ? rs.getString("faculty_name") : "N/A";
        } else {
            message = "No timetable found with ID: " + timetableId;
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        message = "Error fetching timetable: " + e.getMessage();
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Timetable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6fa;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: linear-gradient(180deg, #3b4fe4, #5563de);
            color: #fff;
            padding-top: 30px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            margin: 5px 0;
            gap: 10px;
            transition: background 0.3s;
        }

        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
        }

        .portal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #4455EE;
            padding: 10px;
            border-radius: 6px;
            color: white;
            margin: 0 15px 20px 15px;
        }

        /* Main Content */
        .main-content {
            margin-left: 240px;
            padding: 25px;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .dashboard-header h2 {
            font-weight: 600;
            color: #2b2b2b;
        }

        .dashboard-header span {
            font-weight: 600;
            color: #3b4fe4;
        }

        /* Card Styling */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            background: #fff;
            padding: 30px;
            max-width: 700px;
            margin: 0 auto;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #ddd;
        }

        .detail-label {
            font-weight: 600;
            color: #555;
        }

        .detail-value {
            color: #1a237e;
            font-weight: 500;
        }

        .btn-primary {
            background-color: #3b4fe4;
            border: none;
        }

        .btn-primary:hover {
            background-color: #3246d3;
        }

        .bi, [data-lucide] {
            color: black !important;
            stroke: black !important;
        }

        @media (max-width: 768px) {
            .sidebar { width: 70px; }
            .sidebar span { display: none; }
            .main-content { margin-left: 70px; }
        }
    </style>
</head>

<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="portal-title">
            <i data-lucide="graduation-cap"></i>
            <span style="font-weight: bold;">Admin Portal</span>
        </div>

        <a href="Admin_Dashboard.jsp"><i data-lucide="layout-dashboard"></i><span>Dashboard</span></a>
        <a href="Profile.jsp"><i data-lucide="user"></i><span>Profile</span></a>
        <a href="Attandance.jsp"><i data-lucide="clipboard-list"></i><span>Student Attendance</span></a>
        <a href="Students.jsp"><i data-lucide="user-round-cog"></i><span>Manage Student</span></a>
        <a href="Faculty.jsp"><i data-lucide="users-round"></i><span>Manage Faculty</span></a>
        <a href="timetable.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;">
            <i data-lucide="calendar-days"></i><span>Timetable</span>
        </a>
        <a href="notice.jsp"><i data-lucide="bell"></i><span>Notice</span></a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>View Timetable Details</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-danger"><%= message %></div>
        <% } else { %>

        <div class="card">
            <h4 class="text-center text-primary fw-bold mb-4">
                <i class="bi bi-calendar-week"></i> Timetable Information
            </h4>

            <div class="detail-row">
                <div class="detail-label">Course:</div>
                <div class="detail-value"><%= course %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Semester:</div>
                <div class="detail-value"><%= semester %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Day:</div>
                <div class="detail-value"><%= day %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Subject Name:</div>
                <div class="detail-value"><%= subject %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Faculty:</div>
                <div class="detail-value"><%= facultyName %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Time Slot:</div>
                <div class="detail-value"><%= timeSlot %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Class:</div>
                <div class="detail-value"><%= className %></div>
            </div>

            <div class="detail-row">
                <div class="detail-label">Class Location:</div>
                <div class="detail-value"><%= classLocation %></div>
            </div>

            <div class="text-center mt-4">
                <a href="timetable.jsp" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Back to List
                </a>
            </div>
        </div>

        <% } %>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
