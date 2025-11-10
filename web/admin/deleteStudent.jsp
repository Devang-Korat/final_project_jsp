<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    int adminId = (Integer) sess.getAttribute("userid");
    int studentId = Integer.parseInt(request.getParameter("id"));

    String adminName = "N/A";
    String message = "";

    // Student details
    String enrollment = "", name = "", email = "", phone = "", course = "", className = "", semester = "";

    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // Fetch admin name
        PreparedStatement ps1 = con.prepareStatement("SELECT name FROM admin WHERE admin_id=?");
        ps1.setInt(1, adminId);
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) {
            adminName = rs1.getString("name");
        }
        rs1.close();
        ps1.close();

        // Fetch student details
        PreparedStatement ps = con.prepareStatement("SELECT * FROM students WHERE student_id=?");
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            enrollment = rs.getString("Enrollment");
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            course = rs.getString("course");
            className = rs.getString("Class");
            semester = rs.getString("semester");
        } else {
            message = "Student record not found.";
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "Database Error: " + e.getMessage();
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Student</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6fa;
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

        .profile-card {
            max-width: 900px;
            margin: 0 auto;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            background: white;
            padding: 30px;
        }

        .alert-danger {
            font-weight: 500;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }

        .data-item {
            padding: 12px 0;
            border-bottom: 1px dashed #ddd;
        }

        .data-label {
            font-weight: 600;
            color: #555;
        }

        .data-value {
            color: #1a237e;
            font-weight: 500;
        }

        .bi, .lucide {
            color: black !important;
            stroke: black !important;
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
        <a href="Students.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;"><i data-lucide="user-round-cog"></i><span>Manage Student</span></a>
        <a href="Faculty.jsp"><i data-lucide="users-round"></i><span>Manage Faculty</span></a>
        <a href="timetable.jsp"><i data-lucide="calendar-days"></i><span>Timetable</span></a>
        <a href="notice.jsp"><i data-lucide="bell"></i><span>Notice</span></a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>Delete Student Record</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <div class="profile-card">
            <% if (!message.isEmpty()) { %>
                <div class="alert alert-danger"><%= message %></div>
            <% } else { %>
                <h5 class="text-danger mb-3"><i class="bi bi-exclamation-triangle-fill me-2"></i>Are you sure you want to delete this student?</h5>
                <hr>

                <div class="row">
                    <div class="col-md-6">
                        <div class="data-item"><span class="data-label">Enrollment:</span> <span class="data-value"><%= enrollment %></span></div>
                        <div class="data-item"><span class="data-label">Name:</span> <span class="data-value"><%= name %></span></div>
                        <div class="data-item"><span class="data-label">Email:</span> <span class="data-value"><%= email %></span></div>
                        <div class="data-item"><span class="data-label">Phone:</span> <span class="data-value"><%= phone %></span></div>
                    </div>
                    <div class="col-md-6">
                        <div class="data-item"><span class="data-label">Course:</span> <span class="data-value"><%= course %></span></div>
                        <div class="data-item"><span class="data-label">Class:</span> <span class="data-value"><%= className %></span></div>
                        <div class="data-item"><span class="data-label">Semester:</span> <span class="data-value"><%= semester %></span></div>
                    </div>
                </div>

                <form action="removeStudent.jsp" method="post" class="text-end mt-4">
                    <input type="hidden" name="student_id" value="<%= studentId %>">
                    <button type="submit" class="btn-delete"><i class="bi bi-trash3-fill me-2"></i>Delete Student</button>
                    <a href="Students.jsp" class="btn-cancel"><i class="bi bi-arrow-left-circle me-2"></i>Cancel</a>
                </form>
            <% } %>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
