<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- Session Check ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    int adminId = (Integer) sess.getAttribute("userid");

    // Default Values
    String adminName = "N/A";
    String adminEmail = "N/A";
    String adminPhone = "N/A";
    String adminDate = "N/A";
    String adminAddress = "N/A";
    String statusMessage = "";

    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        PreparedStatement ps = con.prepareStatement(
            "SELECT name, email, phone_number, date, address FROM admin WHERE admin_id=?");
        ps.setInt(1, adminId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            adminName = rs.getString("name");
            adminEmail = rs.getString("email");
            adminPhone = rs.getString("phone_number");
            adminDate = rs.getString("date");
            adminAddress = rs.getString("address");
        } else {
            statusMessage = "Error: Admin ID not found in the database.";
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        statusMessage = "Database Error: Could not connect or query the database.";
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Profile</title>
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
            overflow: hidden;
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

        /* Profile Card */
        .profile-card {
            max-width: 900px;
            margin: 30px auto;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .profile-header-strip {
            background-color: #3b4fe4;
            color: white;
            padding: 20px 30px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }

        .profile-title {
            font-weight: 700;
            display: flex;
            align-items: center;
            font-size: 1.8rem;
        }

        .profile-body-content {
            padding: 30px;
        }

        .data-item {
            padding: 15px 0;
            border-bottom: 1px dashed #eee;
        }

        .data-label {
            font-weight: 600;
            color: #555;
        }

        .data-value {
            color: #1a237e;
            font-weight: 500;
        }

        /* ? Black Icon Styling */
        .bi,
        .lucide {
            color: black !important;
            stroke: black !important;
            fill: none !important;
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
        <a href="Profile.jsp" style="background: rgba(255,255,255,0.2); border-radius: 8px;">
            <i data-lucide="user"></i><span>Profile</span>
        </a>
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
            <h2>Admin Profile</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <div class="card profile-card">
            <div class="profile-header-strip">
                <h2 class="profile-title">
                    <i class="bi bi-person-badge-fill me-3" style="font-size: 2.5rem;"></i>
                    Profile Details
                </h2>
            </div>

            <div class="card-body profile-body-content">
                <% if (!statusMessage.isEmpty()) { %>
                    <div class="alert alert-danger" role="alert"><%= statusMessage %></div>
                <% } %>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-hash me-2"></i> Admin ID</div>
                            <div class="data-value"><%= adminId %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-person-fill me-2"></i> Full Name</div>
                            <div class="data-value"><%= adminName %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-telephone-fill me-2"></i> Phone Number</div>
                            <div class="data-value"><%= adminPhone %></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-envelope-fill me-2"></i> Email Address</div>
                            <div class="data-value"><%= adminEmail %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-calendar-event me-2"></i> Joining Date</div>
                            <div class="data-value"><%= adminDate %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-geo-alt-fill me-2"></i> Address</div>
                            <div class="data-value"><%= adminAddress %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
