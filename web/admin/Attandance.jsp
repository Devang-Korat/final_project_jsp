<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    int adminId = (Integer) sess.getAttribute("userid");

    String adminName = "N/A";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // Get admin name
        ps = con.prepareStatement("SELECT name FROM admin WHERE admin_id=?");
        ps.setInt(1, adminId);
        rs = ps.executeQuery();
        if (rs.next()) {
            adminName = rs.getString("name");
        }
        rs.close();
        ps.close();

        // Join attendance and student tables
        ps = con.prepareStatement(
            "SELECT s.Enrollment, s.name AS student_name, s.class, a.subject_name, a.date, a.status " +
            "FROM attendance a " +
            "JOIN students s ON a.student_id = s.student_id " +
            "ORDER BY a.date DESC"
        );
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Attendance</title>
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

        /* Main */
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

        /* Table Styling */
        .table-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.05);
        }

        table th {
            background: linear-gradient(90deg, #4455ee, #5f6bf0);
            color: white;
            text-align: center;
            font-size: 15px;
        }

        table td {
            text-align: center;
            vertical-align: middle;
            font-size: 14px;
        }

        /* Alternating colors */
        tbody tr:nth-child(odd) {
            background-color: #f9f9ff;
        }
        tbody tr:nth-child(even) {
            background-color: #edf1ff;
        }

        tbody tr:hover {
            background-color: #e1e4ff;
            transition: 0.3s ease;
        }

        /* Status badges */
        .badge-present {
            background-color: #28a745;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        .badge-absent {
            background-color: #dc3545;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        /* Icons black */
        .bi,
        .lucide {
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
        <a href="Attandance.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;"><i data-lucide="clipboard-list"></i><span>Student Attendance</span></a>
        <a href="Students.jsp"><i data-lucide="user-round-cog"></i><span>Manage Student</span></a>
        <a href="Faculty.jsp"><i data-lucide="users-round"></i><span>Manage Faculty</span></a>
        <a href="timetable.jsp"><i data-lucide="calendar-days"></i><span>Timetable</span></a>
        <a href="notice.jsp"><i data-lucide="bell"></i><span>Notice</span></a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>Student Attendance</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <div class="table-container">
            <h5 class="mb-3 text-primary">Attendance Records</h5>
            <table class="table table-bordered table-hover align-middle">
                <thead>
                    <tr>
                        <th>Enrollment No</th>
                        <th>Student Name</th>
                        <th>Class</th>
                        <th>Subject</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% while (rs.next()) { 
                        String status = rs.getString("status");
                    %>
                    <tr>
                        <td><%= rs.getString("Enrollment") %></td>
                        <td><%= rs.getString("student_name") %></td>
                        <td><%= rs.getString("class") %></td>
                        <td><%= rs.getString("subject_name") %></td>
                        <td><%= rs.getString("date") %></td>
                        <td>
                            <% if (status.equalsIgnoreCase("Present")) { %>
                                <span class="badge-present">Present</span>
                            <% } else { %>
                                <span class="badge-absent">Absent</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
