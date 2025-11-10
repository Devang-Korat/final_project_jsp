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

    // --- Variables ---
    String message = "";
    int timetableId = 0;
    String course = "", semester = "", day = "", subject = "", timeSlot = "", className = "", classLocation = "";
    int facultyId = 0;

    // --- Fetch Timetable Data ---
    try {
        timetableId = Integer.parseInt(request.getParameter("id"));
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM timetable WHERE timetable_id=?");
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
            facultyId = rs.getInt("faculty_id");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        message = "Error fetching timetable: " + e.getMessage();
    } finally {
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    // --- Update Record ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newCourse = request.getParameter("course");
        String newSemester = request.getParameter("semester");
        String newDay = request.getParameter("day");
        String newSubject = request.getParameter("subject");
        String newTimeSlot = request.getParameter("timeSlot");
        String newClass = request.getParameter("class");
        String newClassLocation = request.getParameter("class_location");
        int newFacultyId = Integer.parseInt(request.getParameter("faculty_id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
            PreparedStatement ps = con.prepareStatement(
                "UPDATE timetable SET course=?, semester=?, day=?, subject_name=?, time_slot=?, class=?, class_location=?, faculty_id=? WHERE timetable_id=?"
            );
            ps.setString(1, newCourse);
            ps.setString(2, newSemester);
            ps.setString(3, newDay);
            ps.setString(4, newSubject);
            ps.setString(5, newTimeSlot);
            ps.setString(6, newClass);
            ps.setString(7, newClassLocation);
            ps.setInt(8, newFacultyId);
            ps.setInt(9, timetableId);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                message = "Timetable updated successfully!";
                course = newCourse;
                semester = newSemester;
                day = newDay;
                subject = newSubject;
                timeSlot = newTimeSlot;
                className = newClass;
                classLocation = newClassLocation;
                facultyId = newFacultyId;
            } else {
                message = "Error: Timetable not found or not updated.";
            }

            ps.close();
        } catch (Exception e) {
            message = "Database Error: " + e.getMessage();
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Timetable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6fa;
        }
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
            padding: 25px;
            max-width: 800px;
            margin: 0 auto;
        }
        label {
            font-weight: 600;
            color: #333;
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
            <h2>Edit Timetable</h2>
            <span>Welcome, <%= adminName %></span>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <div class="card">
            <form method="post" action="EditTimetable.jsp?id=<%= timetableId %>">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Course</label>
                        <input type="text" name="course" value="<%= course %>" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label>Semester</label>
                        <input type="text" name="semester" value="<%= semester %>" class="form-control" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Day</label>
                        <select name="day" class="form-select" required>
                            <option value="<%= day %>"><%= day %></option>
                            <option>Monday</option>
                            <option>Tuesday</option>
                            <option>Wednesday</option>
                            <option>Thursday</option>
                            <option>Friday</option>
                            <option>Saturday</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label>Subject Name</label>
                        <input type="text" name="subject" value="<%= subject %>" class="form-control" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Faculty</label>
                        <select name="faculty_id" class="form-select" required>
                            <option value="">Select Faculty</option>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
                                    PreparedStatement ps2 = con2.prepareStatement("SELECT faculty_id, name FROM faculty");
                                    ResultSet rs2 = ps2.executeQuery();
                                    while (rs2.next()) {
                                        int fid = rs2.getInt("faculty_id");
                                        String fname = rs2.getString("name");
                                        if (fid == facultyId) {
                            %>
                                            <option value="<%= fid %>" selected><%= fname %></option>
                            <%
                                        } else {
                            %>
                                            <option value="<%= fid %>"><%= fname %></option>
                            <%
                                        }
                                    }
                                    rs2.close();
                                    ps2.close();
                                    con2.close();
                                } catch (Exception e) {
                                    out.println("<option disabled>Error loading faculty</option>");
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label>Time Slot</label>
                        <input type="text" name="timeSlot" value="<%= timeSlot %>" class="form-control" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Class</label>
                        <input type="text" name="class" value="<%= className %>" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label>Class Location</label>
                        <input type="text" name="class_location" value="<%= classLocation %>" class="form-control" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="timetable.jsp" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Update Timetable
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>lucide.createIcons();</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
