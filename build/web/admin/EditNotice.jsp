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
    String message = "";

    // Fetch notice ID from query parameter
    int noticeId = Integer.parseInt(request.getParameter("id"));

    // Define variables for existing notice data
    String title = "";
    String description = "";
    String postedBy = "";
    String date = "";

    // Connect and fetch existing notice details
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        PreparedStatement psAdmin = con.prepareStatement("SELECT name FROM admin WHERE admin_id=?");
        psAdmin.setInt(1, adminId);
        ResultSet rsAdmin = psAdmin.executeQuery();
        if (rsAdmin.next()) {
            adminName = rsAdmin.getString("name");
        }
        rsAdmin.close();
        psAdmin.close();

        PreparedStatement ps = con.prepareStatement("SELECT * FROM notices WHERE notice_id=?");
        ps.setInt(1, noticeId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
            postedBy = rs.getString("posted_by");
            date = rs.getString("date");
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }

    // --- Handle Update Submission ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newTitle = request.getParameter("title");
        String newDesc = request.getParameter("description");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
            PreparedStatement ps = con.prepareStatement(
                "UPDATE notices SET title=?, description=?, posted_by=?, date=NOW() WHERE notice_id=?"
            );
            ps.setString(1, newTitle);
            ps.setString(2, newDesc);
            ps.setString(3, adminName);
            ps.setInt(4, noticeId);

            int i = ps.executeUpdate();
            if (i > 0) {
                message = "Notice updated successfully!";
            } else {
                message = "Update failed.";
            }

            ps.close();
            con.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Notice</title>
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

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            background: #fff;
            max-width: 700px;
            margin: auto;
        }

        label {
            font-weight: 600;
            color: #333;
        }

        .form-control {
            border-radius: 8px;
            box-shadow: none;
            border: 1px solid #ccc;
        }

        .btn-update {
            background-color: #198754;
            color: white;
            border-radius: 6px;
        }

        .btn-update:hover {
            background-color: #157347;
            color: white;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
            border-radius: 6px;
        }

        .btn-back:hover {
            background-color: #5c636a;
            color: white;
        }

        .alert {
            max-width: 700px;
            margin: auto;
        }

        .bi, [data-lucide] {
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
        <a href="Students.jsp"><i data-lucide="user-round-cog"></i><span>Manage Student</span></a>
        <a href="Faculty.jsp"><i data-lucide="users-round"></i><span>Manage Faculty</span></a>
        <a href="timetable.jsp"><i data-lucide="calendar-days"></i><span>Timetable</span></a>
        <a href="notice.jsp"><i data-lucide="bell"></i><span>Notice</span></a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>Edit Notice</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info text-center"><%= message %></div>
        <% } %>

        <div class="card p-4 mt-4">
            <form action="EditNotice.jsp?id=<%= noticeId %>" method="post">
                <div class="mb-3">
                    <label for="title" class="form-label">Notice Title</label>
                    <input type="text" id="title" name="title" class="form-control" value="<%= title %>" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Notice Description</label>
                    <textarea id="description" name="description" class="form-control" rows="5" required><%= description %></textarea>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="notice.jsp" class="btn btn-back">
                        <i class="bi bi-arrow-left-circle"></i> Back
                    </a>
                    <button type="submit" class="btn btn-update">
                        <i class="bi bi-check-circle"></i> Update
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
