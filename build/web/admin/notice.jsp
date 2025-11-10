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
    <title>Manage Notice</title>
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

        /* Notice Table Card */
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

        .btn {
            border-radius: 6px;
            font-weight: 500;
        }

        .btn-edit {
            background-color: #198754;
            color: white;
        }
        .btn-edit:hover {
            background-color: #157347;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background-color: #bb2d3b;
            color: white;
        }

        .table-hover tbody tr:hover {
            background-color: #f2f5ff;
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
        <a href="timetable.jsp"><i data-lucide="calendar-days"></i><span>Timetable</span></a>
        <a href="notice.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;">
            <i data-lucide="bell"></i><span>Notice</span>
        </a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>Manage Notice</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <%
            Connection con2 = null;
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

                String sql = "SELECT notice_id, title, description, posted_by, date FROM notices ORDER BY notice_id DESC";
                ps2 = con2.prepareStatement(sql);
                rs2 = ps2.executeQuery();
        %>

        <div class="card p-4 mt-3">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-dark m-0">Notice List</h4>
                <a href="AddNotice.jsp" class="btn btn-primary btn-sm">
                    <i class="bi bi-plus-circle"></i> Add Notice
                </a>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Posted By</th>
                            <th>Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int count = 1;
                            while (rs2.next()) {
                                String fullDate = rs2.getString("date");
                                String shortDate = fullDate != null && fullDate.length() >= 10 ? fullDate.substring(0, 10) : "";
                        %>
                        <tr>
                            <td class="text-center"><%= count++ %></td>
                            <td><%= rs2.getString("title") %></td>
                            <td><%= rs2.getString("description") %></td>
                            <td><%= rs2.getString("posted_by") %></td>
                            <td><%= shortDate %></td>
                            <td class="text-center">
                                <a href="EditNotice.jsp?id=<%= rs2.getInt("notice_id") %>" class="btn btn-sm btn-edit">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="DeleteNotice.jsp?id=<%= rs2.getInt("notice_id") %>"
                                   class="btn btn-sm btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this notice?');">
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
