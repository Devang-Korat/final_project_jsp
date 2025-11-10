<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int studentId = (Integer) sess.getAttribute("userid");
    String studentName = "";

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT name FROM students WHERE student_id=?");
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            studentName = rs.getString("name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Student Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                background-color: #f7f9fc;
                font-family: 'Segoe UI', sans-serif;
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
            /* Main Content */
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

            /* Dashboard Cards */
            .card-box {
                border-radius: 15px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: 0.3s;
                background: white;
                text-align: center;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                width: 220px;
                height: 230px;
            }
            .card-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .card-box svg {
                width: 50px;
                height: 50px;
                fill: #3b4fe4;
                margin-bottom: 12px;
                transition: transform 0.3s ease;
                margin-left: auto;
                margin-right: auto;
            }
            .card-box:hover svg {
                transform: scale(1.1);
            }
            .card-title {
                font-weight: 600;
                margin-bottom: 8px;
            }
            .btn {
                margin-top: auto;
            }

            /* Responsive Grid Fix */
            .dashboard-row {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                justify-content: center;
            }
            .dashboard-row .col {
                flex: 1 1 200px;
                max-width: 260px;
            }

            .summary-section {
                margin-top: 40px;
                display: flex;
                flex-wrap: wrap;
                gap: 25px;
                justify-content: center;
            }


            .summary-card {
                background: #ffffff;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 25px 20px;
                transition: 0.3s ease;
                width: 100%;
                min-height: 320px;
            }

            .summary-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
            }

            /* ? Card Header */
            .summary-card .card-title {
                font-size: 18px;
                font-weight: 600;
                color: #3b4fe4;
                border-bottom: 2px solid #3b4fe4;
                display: inline-block;
                margin-bottom: 15px;
                padding-bottom: 5px;
            }


            .summary-card ul.list-group {
                border-radius: 10px;
                overflow: hidden;
            }

            .summary-card .list-group-item {
                border: none;
                border-bottom: 1px solid #f0f0f0;
                padding: 10px 15px;
                font-size: 14px;
            }

            .summary-card .list-group-item:last-child {
                border-bottom: none;
            }

            .summary-card .list-group-item strong {
                color: #333;
            }

            .summary-card .list-group-item small {
                color: #777;
            }


            .summary-card table {
                border-radius: 10px;
                overflow: hidden;
                font-size: 14px;
            }

            .summary-card th {
                background: #3b4fe4;
                color: white;
                text-align: center;
            }

            .summary-card td {
                text-align: center;
                vertical-align: middle;
            }

            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                    padding: 15px;
                }
                .summary-card {
                    width: 100%;
                    min-height: auto;
                }
            }
            @media (max-width: 768px) {
                .sidebar {
                    width: 70px;
                    padding-top: 20px;
                }

                .sidebar h4 {
                    font-size: 0;
                }

                .sidebar span {
                    display: none; /* Hide text, keep icons only */
                }

                .main-content {
                    margin-left: 70px;
                }

                .sidebar a {
                    justify-content: center;
                    padding: 12px 0;
                }

                .sidebar svg {
                    margin: 0;
                }
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <div class="sidebar">
           <div class="portal-title">
                <i data-lucide="graduation-cap" style="width:22px;height:22px;"></i>
                <span style="font-weight: bold;">Student Portal</span>
            </div>

            <script>
                lucide.createIcons();
            </script>

            <a href="student_dashboard.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M3 13h2v-2H3v2zm4 0h2v-6H7v6zm4 0h2V4h-2v9zm4 0h2V8h-2v5zm4 0h2V2h-2v11zm0 6H3v-2h18v2z"/>
                </svg>
                <span>Dashboard</span>
            </a>

            <a href="viewprofile.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M12 12c2.67 0 8 1.34 8 4v4H4v-4c0-2.66 5.33-4 8-4zm0-2a4 4 0 110-8 4 4 0 010 8z"/>
                </svg>
                <span>View Profile</span>
            </a>

            <a href="viewattendance.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M19 3H5v18h14V3zM7 5h10v2H7V5zM7 9h10v2H7V9zM7 13h10v2H7v-2zM7 17h10v2H7v-2z"/>
                </svg>
                <span>View Attendance</span>
            </a>

            <a href="studyMaterials.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M18 2H6v20l6-3 6 3V2z"/>
                </svg>
                <span>Study Materials</span>
            </a>

            <a href="viewNotices.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M3 3h18v2H3V3zm0 6h18v12H3V9zm5 3h2v6H8v-6zm6 0h2v6h-2v-6z"/>
                </svg>
                <span>View Notices</span>
            </a>

            <a href="view_timetable.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M19 4h-1V2h-2v2H8V2H6v2H5v16h14V4zM7 10h10v8H7v-8z"/>
                </svg>
                <span>View Timetable</span>
            </a>

            <a href="logout.jsp">
                <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24" width="22" height="22">
                <path d="M16 13v-2H7V8l-5 4 5 4v-3h9zm3-10H5a2 2 0 00-2 2v6h2V5h14v14H5v-6H3v6a2 2 0 002 2h14a2 2 0 002-2V5a2 2 0 00-2-2z"/>
                </svg>
                <span>Logout</span>
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Student Dashboard</h3>
                <div class="text-end">
                    <span class="fw-bold">Hello, <%= studentName%></span>
                </div>
            </div>

            <!-- Dashboard Cards -->
            <div class="dashboard-row">
                <!-- Profile -->
                <div class="col">
                    <div class="card-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12c2.67 0 8 1.34 8 4v4H4v-4c0-2.66 5.33-4 8-4z"/><circle cx="12" cy="6" r="4"/></svg>
                        <h5 class="card-title">View Profile</h5>
                        <p>Access your personal and academic info.</p>
                        <a href="viewprofile.jsp" class="btn btn-primary btn-sm w-100">View Profile</a>
                    </div>
                </div>

                <!-- Attendance -->
                <div class="col">
                    <div class="card-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3H5v18h14V3zM7 5h10v2H7V5zM7 9h10v2H7V9zM7 13h10v2H7v-2zM7 17h10v2H7v-2z"/></svg>
                        <h5 class="card-title">View Attendance</h5>
                        <p>Check your attendance records.</p>
                        <a href="viewattendance.jsp" class="btn btn-primary btn-sm w-100">View Attendance</a>
                    </div>
                </div>

                <!-- Materials -->
                <div class="col">
                    <div class="card-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M18 2H6v20l6-3 6 3V2z"/></svg>
                        <h5 class="card-title">Study Materials</h5>
                        <p>Access uploaded notes and lectures.</p>
                        <a href="studyMaterials.jsp" class="btn btn-primary btn-sm w-100">View Materials</a>
                    </div>
                </div>

                <!-- Notices -->
                <div class="col">
                    <div class="card-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 3h18v2H3V3zm0 6h18v12H3V9zm5 3h2v6H8v-6zm6 0h2v6h-2v-6z"/></svg>
                        <h5 class="card-title">View Notices</h5>
                        <p>Check college announcements.</p>
                        <a href="viewNotices.jsp" class="btn btn-primary btn-sm w-100">View Notices</a>
                    </div>
                </div>

                <!-- Timetable -->
                <div class="col">
                    <div class="card-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 4h-1V2h-2v2H8V2H6v2H5v16h14V4zM7 10h10v8H7v-8z"/></svg>
                        <h5 class="card-title">View Timetable</h5>
                        <p>Check your daily class schedule.</p>
                        <a href="view_timetable.jsp" class="btn btn-primary btn-sm w-100">View Timetable</a>
                    </div>
                </div>
            </div>

            <!-- Materials + Attendance Summary -->
            <div class="row g-4 mt-4">
                <div class="col-md-6">
                    <div class="card p-3 summary-card">
                        <h5 class="card-title">Latest Uploaded Materials</h5>
                        <ul class="list-group list-group-flush">
                            <%
                                try {
                                    PreparedStatement psMat = con.prepareStatement(
                                            "SELECT title, subject_name, upload_date FROM materials ORDER BY upload_date DESC LIMIT 5");
                                    ResultSet rsMat = psMat.executeQuery();
                                    boolean hasData = false;
                                    while (rsMat.next()) {
                                        hasData = true;
                            %>
                            <li class="list-group-item">
                                <strong><%= rsMat.getString("title")%></strong><br>
                                <small><%= rsMat.getString("subject_name")%> | Uploaded on: <%= rsMat.getString("upload_date")%></small>
                            </li>
                            <%
                                }
                                if (!hasData) {
                            %>
                            <li class="list-group-item text-muted">No materials uploaded yet.</li>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<li class='list-group-item text-danger'>Error loading materials</li>");
                                    }
                                %>
                        </ul>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card p-3 summary-card">
                        <h5 class="card-title">Attendance Summary</h5>
                        <%
                            try {
                                PreparedStatement psAtt = con.prepareStatement(
                                        "SELECT subject_name, SUM(status='Present') AS presents, COUNT(*) AS total "
                                        + "FROM attendance WHERE student_id=? GROUP BY subject_name");
                                psAtt.setInt(1, studentId);
                                ResultSet rsAtt = psAtt.executeQuery();
                        %>
                        <table class="table table-sm table-bordered mt-2">
                            <tr class="table-secondary">
                                <th>Subject</th><th>Present</th><th>Total</th><th>%</th>
                            </tr>
                            <%
                                boolean hasRows = false;
                                while (rsAtt.next()) {
                                    hasRows = true;
                                    int present = rsAtt.getInt("presents");
                                    int total = rsAtt.getInt("total");
                                    int percent = (int) ((present * 100.0) / total);
                            %>
                            <tr>
                                <td><%= rsAtt.getString("subject_name")%></td>
                                <td><%= present%></td>
                                <td><%= total%></td>
                                <td><%= percent%> %</td>
                            </tr>
                            <%
                                }
                                if (!hasRows) {
                            %>
                            <tr><td colspan="4" class="text-muted text-center">No attendance data available</td></tr>
                            <%
                                }
                            %>
                        </table>
                        <%
                            } catch (Exception e) {
                                out.println("<p class='text-danger'>Error loading attendance</p>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<%
    if (con != null)
        con.close();
%>
