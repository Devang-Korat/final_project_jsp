<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }
    int studentId = (Integer) sess.getAttribute("userid");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Filter handling
    String filterType = request.getParameter("filterType");
    if (filterType == null) {
        filterType = "day"; // default
    }
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Attendance</title>
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6fa;
                display: flex;
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

            /* Main content */
            .main-content {
                margin-left: 240px;
                padding: 20px;
                flex-grow: 1;
                transition: margin-left 0.3s ease;
            }

            .card {
                background: #fff;
                padding: 25px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                margin-bottom: 25px;
            }

            .overview {
                display: flex;
                justify-content: space-around;
                align-items: center;
                flex-wrap: wrap;
                text-align: center;
            }

            .overview-box h3 {
                font-size: 26px;
                margin: 10px 0;
                color: #3b4fe4;
            }

            .overview-box p {
                color: #777;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                background: #f1f3fa;
                color: #333;
            }

            .status-present {
                color: #fff;
                background: #28a745;
                padding: 6px 12px;
                border-radius: 5px;
                font-size: 13px;
            }

            .status-absent {
                color: #fff;
                background: #dc3545;
                padding: 6px 12px;
                border-radius: 5px;
                font-size: 13px;
            }

            .filter-container {
                margin-top: 15px;
                text-align: right;
            }

            .filter-container select, button {
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #ccc;
                margin-left: 8px;
                cursor: pointer;
            }

            /* ✅ Responsive Sidebar for Small Screens */
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
            <div class="card">
                <h2>Attendance Overview</h2>
                <div class="overview">
                    <%
                        int totalPresent = 0, totalAbsent = 0, totalCount = 0;
                        try {
                            PreparedStatement ps1 = con.prepareStatement("SELECT status, COUNT(*) as count FROM attendance WHERE student_id=? GROUP BY status");
                            ps1.setInt(1, studentId);
                            ResultSet rs1 = ps1.executeQuery();
                            while (rs1.next()) {
                                if (rs1.getString("status").equals("Present")) {
                                    totalPresent = rs1.getInt("count");
                                } else {
                                    totalAbsent = rs1.getInt("count");
                                }
                            }
                            totalCount = totalPresent + totalAbsent;
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                    <div class="overview-box">
                        <h3><%= totalCount > 0 ? (totalPresent * 100 / totalCount) + "%" : "0%"%></h3>
                        <p>Overall Attendance</p>
                    </div>
                    <div class="overview-box">
                        <h3><%= totalPresent%></h3>
                        <p>Days Present</p>
                    </div>
                    <div class="overview-box">
                        <h3><%= totalAbsent%></h3>
                        <p>Days Absent</p>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="card">
                <h2>Attendance Records</h2>
                <form method="GET" class="filter-container">
                    <label for="filterType">View Type:</label>
                    <select name="filterType" id="filterType" onchange="this.form.submit()">
                        <option value="day" <%= filterType.equals("day") ? "selected" : ""%>>Day-wise</option>
                        <option value="month" <%= filterType.equals("month") ? "selected" : ""%>>Month-wise</option>
                    </select>
                </form>

                <table>
                    <tr>
                        <% if (filterType.equals("month")) { %>
                        <th>Month</th>
                        <th>Total Classes</th>
                        <th>Present</th>
                        <th>Absent</th>
                        <th>Attendance %</th>
                            <% } else { %>
                        <th>Date</th>
                        <th>Subject</th>
                        <th>Status</th>
                            <% } %>
                    </tr>

                    <%
                        try {
                            if (filterType.equals("month")) {
                                ps = con.prepareStatement("SELECT MONTH(date) AS month, COUNT(*) AS total, SUM(status='Present') AS present FROM attendance WHERE student_id=? GROUP BY MONTH(date)");
                                ps.setInt(1, studentId);
                                rs = ps.executeQuery();
                                while (rs.next()) {
                                    int month = rs.getInt("month");
                                    int total = rs.getInt("total");
                                    int present = rs.getInt("present");
                                    int absent = total - present;
                                    int percent = (int) ((present * 100.0) / total);
                    %>
                    <tr>
                        <td><%= new java.text.DateFormatSymbols().getMonths()[month - 1]%></td>
                        <td><%= total%></td>
                        <td><%= present%></td>
                        <td><%= absent%></td>
                        <td><%= percent%>%</td>
                    </tr>
                    <%
                        }
                    } else {
                        ps = con.prepareStatement("SELECT date, subject_name, status FROM attendance WHERE student_id=? ORDER BY date DESC");
                        ps.setInt(1, studentId);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getDate("date")%></td>
                        <td><%= rs.getString("subject_name")%></td>
                        <td>
                            <span class="<%= rs.getString("status").equals("Present") ? "status-present" : "status-absent"%>">
                                <%= rs.getString("status")%>
                            </span>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </table>
            </div>
        </div>
    </body>
</html>
