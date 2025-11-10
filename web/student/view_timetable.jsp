<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // ? Check if student is logged in
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null || !"student".equals(sess.getAttribute("role"))) {
        response.sendRedirect("../login.html");
        return;
    }

    int studentId = (Integer) sess.getAttribute("userid");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String course = "";
    int semester = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Timetable - Student Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
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
            transition: width 0.3s ease;
            overflow: hidden;
        }

        .sidebar h4 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 18px;
            white-space: nowrap;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            margin: 5px 0;
            gap: 10px;
            transition: background 0.3s, border-radius 0.3s, padding 0.3s;
            white-space: nowrap;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
        }

        .sidebar svg {
            width: 22px;
            height: 22px;
            flex-shrink: 0;
        }

        .sidebar span {
            display: inline;
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

        /* Responsive Sidebar */
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
                padding-top: 20px;
            }

            .sidebar h4 {
                font-size: 0;
            }

            .sidebar span {
                display: none;
            }

            .main-content {
                margin-left: 70px !important;
            }

            .sidebar a {
                justify-content: center;
                padding: 12px 0;
            }

            .sidebar svg {
                margin: 0;
            }
        }

        /* Main Content */
        .main-content {
            margin-left: 240px;
            padding: 30px;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
            }
        }

        .table-container {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .table thead {
            background: #4455EE;
            color: white;
        }
    </style>
</head>
<body>

    <!-- ? Sidebar -->
    <div class="sidebar">
        <div class="portal-title">
            <i data-lucide="graduation-cap" style="width:22px;height:22px;"></i>
            <span style="font-weight: bold;">Student Portal</span>
        </div>

        <script>lucide.createIcons();</script>

        <a href="student_dashboard.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M3 13h2v-2H3v2zm4 0h2v-6H7v6zm4 0h2V4h-2v9zm4 0h2V8h-2v5zm4 0h2V2h-2v11zm0 6H3v-2h18v2z"/>
            </svg>
            <span>Dashboard</span>
        </a>

        <a href="viewprofile.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M12 12c2.67 0 8 1.34 8 4v4H4v-4c0-2.66 5.33-4 8-4zm0-2a4 4 0 110-8 4 4 0 010 8z"/>
            </svg>
            <span>View Profile</span>
        </a>

        <a href="viewattendance.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M19 3H5v18h14V3zM7 5h10v2H7V5zM7 9h10v2H7V9zM7 13h10v2H7v-2zM7 17h10v2H7v-2z"/>
            </svg>
            <span>View Attendance</span>
        </a>

        <a href="studyMaterials.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M18 2H6v20l6-3 6 3V2z"/>
            </svg>
            <span>Study Materials</span>
        </a>

        <a href="viewNotices.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M3 3h18v2H3V3zm0 6h18v12H3V9zm5 3h2v6H8v-6zm6 0h2v6h-2v-6z"/>
            </svg>
            <span>View Notices</span>
        </a>

        <a href="view_timetable.jsp" class="active">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M19 4h-1V2h-2v2H8V2H6v2H5v16h14V4zM7 10h10v8H7v-8z"/>
            </svg>
            <span>View Timetable</span>
        </a>

        <a href="../logout.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24">
                <path d="M16 13v-2H7V8l-5 4 5 4v-3h9zm3-10H5a2 2 0 00-2 2v6h2V5h14v14H5v-6H3v6a2 2 0 002 2h14a2 2 0 002-2V5a2 2 0 00-2-2z"/>
            </svg>
            <span>Logout</span>
        </a>
    </div>

    <!-- ? Main Content -->
    <div class="main-content">
        <div class="table-container">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

                    // Fetch student's course and semester
                    ps = con.prepareStatement("SELECT course, semester FROM students WHERE student_id = ?");
                    ps.setInt(1, studentId);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        course = rs.getString("course");
                        semester = rs.getInt("semester");
                    }

                    if (semester == 0 || course == null || course.trim().isEmpty()) {
                        out.println("<h5 class='text-danger text-center'>Unable to find your course or semester details.</h5>");
                    } else {
                        out.println("<h3 class='fw-bold text-center mb-4'>" + course + " - Semester " + semester + " Timetable</h3>");

                        ps = con.prepareStatement(
                            "SELECT t.day, t.time_slot, t.subject_name, t.class_location, f.name AS faculty_name " +
                            "FROM timetable t " +
                            "LEFT JOIN faculty f ON t.faculty_id = f.faculty_id " +
                            "WHERE t.course = ? AND t.semester = ? " +
                            "ORDER BY FIELD(t.day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), t.time_slot"
                        );
                        ps.setString(1, course);
                        ps.setInt(2, semester);
                        rs = ps.executeQuery();

                        boolean hasData = false;
            %>
                        <table class="table table-bordered table-striped text-center align-middle">
                            <thead>
                                <tr>
                                    <th>Day</th>
                                    <th>Time Slot</th>
                                    <th>Subject</th>
                                    <th>Faculty</th>
                                    <th>Class Location</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                        while (rs.next()) {
                            hasData = true;
            %>
                            <tr>
                                <td><%= rs.getString("day") %></td>
                                <td><%= rs.getString("time_slot") %></td>
                                <td><%= rs.getString("subject_name") %></td>
                                <td><%= (rs.getString("faculty_name") != null ? rs.getString("faculty_name") : "Not Assigned") %></td>
                                <td><%= (rs.getString("class_location") != null ? rs.getString("class_location") : "-") %></td>
                            </tr>
            <%
                        }
                        if (!hasData) {
            %>
                            <tr>
                                <td colspan="5" class="text-danger text-center">No timetable available for your semester.</td>
                            </tr>
            <%
                        }
            %>
                            </tbody>
                        </table>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='text-danger'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </div>
    </div>
</body>
</html>
