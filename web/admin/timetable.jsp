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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Timetable</title>
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

        /* Table Card */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            background: #fff;
        }

        thead th {
            background: linear-gradient(to right, #3b4fe4, #5563de);
            color: black !important;
            text-align: center;
            font-weight: 600;
        }

        .table-hover tbody tr:hover {
            background-color: #f2f5ff;
        }

        /* Buttons */
        .btn {
            border-radius: 6px;
            font-weight: 500;
            color: white !important;
        }

        .btn-view {
            background-color: #0d6efd;
        }

        .btn-edit {
            background-color: #198754;
        }

        .btn-delete {
            background-color: #dc3545;
        }

        .btn-view:hover {
            background-color: #0b5ed7;
        }

        .btn-edit:hover {
            background-color: #157347;
        }

        .btn-delete:hover {
            background-color: #bb2d3b;
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
            <h2>Manage Timetable</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <%
            Connection con2 = null;
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

                String sql = "SELECT timetable_id, course, semester, day, subject_name, time_slot, class FROM timetable ORDER BY timetable_id DESC";
                ps2 = con2.prepareStatement(sql);
                rs2 = ps2.executeQuery();
        %>

        <div class="card p-4 mt-3">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-dark m-0">Timetable List</h4>
                <a href="AddTimetable.jsp" class="btn btn-primary btn-sm">
                    <i class="bi bi-plus-circle"></i> Create Timetable
                </a>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Course</th>
                            <th>Semester</th>
                            <th>Day</th>
                            <th>Subject</th>
                            <th>Time Slot</th>
                            <th>Class</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int count = 1;
                            while (rs2.next()) {
                        %>
                        <tr>
                            <td class="text-center"><%= count++ %></td>
                            <td><%= rs2.getString("course") %></td>
                            <td><%= rs2.getString("semester") %></td>
                            <td><%= rs2.getString("day") %></td>
                            <td><%= rs2.getString("subject_name") %></td>
                            <td><%= rs2.getString("time_slot") %></td>
                            <td><%= rs2.getString("class") != null ? rs2.getString("class") : "-" %></td>
                            <td class="text-center">
                                <a href="ViewTimetable.jsp?id=<%= rs2.getInt("timetable_id") %>" class="btn btn-sm btn-view me-1">
                                    <i class="bi bi-eye"></i> View
                                </a>
                                <a href="EditTimetable.jsp?id=<%= rs2.getInt("timetable_id") %>" class="btn btn-sm btn-edit me-1">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="DeleteTimetable.jsp?id=<%= rs2.getInt("timetable_id") %>" class="btn btn-sm btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this timetable?');">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <%
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
            } finally {
                try { if (rs2 != null) rs2.close(); if (ps2 != null) ps2.close(); if (con2 != null) con2.close(); } 
                catch (Exception e) { e.printStackTrace(); }
            }
        %>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
