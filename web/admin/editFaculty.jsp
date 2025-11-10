<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    int adminId = (Integer) sess.getAttribute("userid");
    int facultyId = Integer.parseInt(request.getParameter("id"));

    String adminName = "N/A";
    String message = "";

    // Faculty details
    String name = "", email = "", phone = "", department = "";

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

        // Fetch faculty details
        PreparedStatement ps = con.prepareStatement("SELECT * FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            department = rs.getString("department");
        } else {
            message = "Faculty record not found.";
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
    <title>Edit Faculty</title>
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

        .form-card {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .btn-save {
            background-color: #3b4fe4;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-save:hover {
            background-color: #2d3edb;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-back:hover {
            background-color: #5a6268;
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
        <a href="Students.jsp"><i data-lucide="user-round-cog"></i><span>Manage Student</span></a>
        <a href="Faculty.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;"><i data-lucide="users-round"></i><span>Manage Faculty</span></a>
        <a href="timetable.jsp"><i data-lucide="calendar-days"></i><span>Timetable</span></a>
        <a href="notice.jsp"><i data-lucide="bell"></i><span>Notice</span></a>
        <a href="logout.jsp"><i data-lucide="log-out"></i><span>Logout</span></a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>Edit Faculty Details</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <div class="form-card">
            <% if (!message.isEmpty()) { %>
                <div class="alert alert-danger"><%= message %></div>
            <% } %>

            <form action="updateFaculty.jsp" method="post">
                <input type="hidden" name="faculty_id" value="<%= facultyId %>">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" value="<%= name %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="<%= email %>" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone" value="<%= phone %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Department</label>
                        <input type="text" class="form-control" name="department" value="<%= department %>" required>
                    </div>
                </div>

                <div class="text-end mt-4">
                    <button type="submit" class="btn-save"><i class="bi bi-save me-2"></i>Save Changes</button>
                    <a href="Faculty.jsp" class="btn-back"><i class="bi bi-arrow-left-circle me-2"></i>Back</a>
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
