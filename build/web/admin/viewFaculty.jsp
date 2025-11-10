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
    String statusMessage = "";

    // Faculty details
    String name = "", email = "", department = "", phone = "", subjects = "";

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

        // ? Fixed table name: faculty_subjects (not faculty_subject)
        PreparedStatement ps = con.prepareStatement(
            "SELECT f.faculty_id, f.name, f.email, f.department, f.phone, " +
            "GROUP_CONCAT(fs.subject_name SEPARATOR ', ') AS subjects " +
            "FROM faculty f " +
            "LEFT JOIN faculty_subjects fs ON f.faculty_id = fs.faculty_id " +
            "WHERE f.faculty_id=? " +
            "GROUP BY f.faculty_id, f.name, f.email, f.department, f.phone"
        );

        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            department = rs.getString("department");
            phone = rs.getString("phone");
            subjects = rs.getString("subjects") != null ? rs.getString("subjects") : "No subjects assigned.";
        } else {
            statusMessage = "Faculty record not found.";
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        statusMessage = "Database Error: " + e.getMessage();
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Faculty</title>
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

        /* Profile Card */
        .profile-card {
            max-width: 900px;
            margin: 0 auto;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .profile-header {
            background: linear-gradient(90deg, #3b4fe4, #5f6bf0);
            color: white;
            padding: 25px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }

        .profile-header h3 {
            margin: 0;
            font-weight: 700;
        }

        .profile-body {
            padding: 30px;
            background: white;
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

        .btn-back {
            background-color: #3b4fe4;
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .btn-back:hover {
            background-color: #2d3edb;
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

    <!-- Main -->
    <div class="main-content">
        <div class="dashboard-header">
            <h2>View Faculty Profile</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <div class="profile-card">
            <div class="profile-header">
                <h3><i class="bi bi-person-badge-fill me-2"></i> <%= name %></h3>
            </div>

            <div class="profile-body">
                <% if (!statusMessage.isEmpty()) { %>
                    <div class="alert alert-danger"><%= statusMessage %></div>
                <% } else { %>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="data-item">
                                <span class="data-label"><i class="bi bi-hash me-2"></i>Faculty ID:</span>
                                <span class="data-value"><%= facultyId %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label"><i class="bi bi-envelope-fill me-2"></i>Email:</span>
                                <span class="data-value"><%= email %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label"><i class="bi bi-telephone-fill me-2"></i>Phone:</span>
                                <span class="data-value"><%= phone %></span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="data-item">
                                <span class="data-label"><i class="bi bi-building me-2"></i>Department:</span>
                                <span class="data-value"><%= department %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label"><i class="bi bi-journal-bookmark-fill me-2"></i>Subjects:</span>
                                <span class="data-value"><%= subjects.replaceAll(", ", "<br>") %></span>
                            </div>
                        </div>
                    </div>
                <% } %>

                <div class="text-end mt-4">
                    <button class="btn-back" onclick="window.location.href='Faculty.jsp'">
                        <i class="bi bi-arrow-left-circle me-2"></i> Back to Manage Faculty
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script> lucide.createIcons(); </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
