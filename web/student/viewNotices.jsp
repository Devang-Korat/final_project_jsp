<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Notices</title>
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

        /* Main content */
        .main-content {
            margin-left: 240px;
            padding: 30px;
            background: #f4f6ff;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        .main-content h2 {
            color: #333;
            margin-bottom: 25px;
            text-align: center;
        }

        .notice-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .notice-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            border-left: 5px solid #4455EE;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .notice-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 14px rgba(0,0,0,0.15);
        }

        .notice-title {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .notice-desc {
            font-size: 14px;
            color: #555;
            margin-bottom: 10px;
        }

        .notice-footer {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #777;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
                padding-top: 20px;
            }
            .sidebar span {
                display: none;
            }
            .main-content {
                margin-left: 70px;
            }
            .sidebar a {
                justify-content: center;
                padding: 12px 0;
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

        <a href="student_dashboard.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M3 13h2v-2H3v2zm4 0h2v-6H7v6zm4 0h2V4h-2v9zm4 0h2V8h-2v5zm4 0h2V2h-2v11zm0 6H3v-2h18v2z"/></svg>
            <span>Dashboard</span>
        </a>

        <a href="viewprofile.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M12 12c2.67 0 8 1.34 8 4v4H4v-4c0-2.66 5.33-4 8-4zm0-2a4 4 0 110-8 4 4 0 010 8z"/></svg>
            <span>View Profile</span>
        </a>

        <a href="viewattendance.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M19 3H5v18h14V3zM7 5h10v2H7V5zM7 9h10v2H7V9zM7 13h10v2H7v-2zM7 17h10v2H7v-2z"/></svg>
            <span>View Attendance</span>
        </a>

        <a href="studyMaterials.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M18 2H6v20l6-3 6 3V2z"/></svg>
            <span>Study Materials</span>
        </a>

        <a href="viewNotices.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M3 3h18v2H3V3zm0 6h18v12H3V9zm5 3h2v6H8v-6zm6 0h2v6h-2v-6z"/></svg>
            <span>View Notices</span>
        </a>

        <a href="view_timetable.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M19 4h-1V2h-2v2H8V2H6v2H5v16h14V4zM7 10h10v8H7v-8z"/></svg>
            <span>View Timetable</span>
        </a>

        <a href="logout.jsp">
            <svg xmlns="http://www.w3.org/2000/svg" fill="black" viewBox="0 0 24 24"><path d="M16 13v-2H7V8l-5 4 5 4v-3h9zm3-10H5a2 2 0 00-2 2v6h2V5h14v14H5v-6H3v6a2 2 0 002 2h14a2 2 0 002-2V5a2 2 0 00-2-2z"/></svg>
            <span>Logout</span>
        </a>
    </div>

    <!-- Main content -->
    <div class="main-content">
        <h2>📢 Announcements</h2>
        <div class="notice-container">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
                    ps = con.prepareStatement("SELECT * FROM notices ORDER BY date DESC");
                    rs = ps.executeQuery();
                    while (rs.next()) {
            %>
                        <div class="notice-card">
                            <div class="notice-title"><%= rs.getString("title") %></div>
                            <div class="notice-desc"><%= rs.getString("description") %></div>
                            <div class="notice-footer">
                                <span>Posted by: <%= rs.getString("posted_by") %> (<%= rs.getString("role") %>)</span>
                                <span><%= rs.getTimestamp("date") %></span>
                            </div>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;text-align:center;'>Error loading notices: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>
