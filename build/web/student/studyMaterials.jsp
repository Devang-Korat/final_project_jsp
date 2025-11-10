<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Study Materials - Student Portal</title>
        <link href="https://unpkg.com/lucide@latest/dist/umd/lucide.js" rel="script">
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                display: flex;
                background-color: #f7f8fc;
            }

            /* Sidebar (your design) */
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

            .main-content {
                margin-left: 260px;
                padding: 30px;
                flex: 1;
            }

            h2 {
                color: #333;
                margin-bottom: 20px;
            }

            .material-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 3px 6px rgba(0,0,0,0.1);
                padding: 15px 20px;
                margin-bottom: 15px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .material-info {
                display: flex;
                flex-direction: column;
            }

            .material-title {
                font-size: 18px;
                color: #222;
                font-weight: bold;
            }

            .material-subject {
                color: #666;
                font-size: 14px;
            }

            .material-date {
                font-size: 12px;
                color: #999;
            }

            .open-btn {
                background: #4455EE;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 6px;
                cursor: pointer;
                transition: background 0.3s;
            }

            .open-btn:hover {
                background: #2c3ee6;
            }
            /* Stylish Open Button */
            .btn-primary {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: linear-gradient(135deg, #4455EE, #5A67F0);
                color: white;
                text-decoration: none;
                font-weight: 500;
                padding: 8px 14px;
                border-radius: 8px;
                transition: all 0.3s ease;
                font-size: 14px;
                box-shadow: 0 3px 6px rgba(0,0,0,0.15);
                border: none;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #2e3ce9, #4e5af5);
                transform: translateY(-2px);
                box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            }

            .btn-primary svg {
                width: 18px;
                height: 18px;
                fill: white;
            }


            @media (max-width: 768px) {
                .sidebar {
                    width: 70px;
                }

                .sidebar span {
                    display: none;
                }

                .main-content {
                    margin-left: 80px;
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

            <a href="studyMaterials.jsp" style="background: rgba(255,255,255,0.2); border-radius:8px;">
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

        <!-- Main Content -->
        <div class="main-content">
            <h2>📚 Study Materials</h2>

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

                    String query = "SELECT * FROM materials ORDER BY upload_date DESC";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String title = rs.getString("title");
                        String subject = rs.getString("subject_name");
                        String filePath = rs.getString("file_path");
                        String uploadDate = rs.getString("upload_date");
            %>

            <div class="material-card">
                <div class="material-info">
                    <span class="material-title"><%= title%></span>
                    <span class="material-subject">Subject: <%= subject%></span>
                    <span class="material-date">Uploaded on: <%= uploadDate%></span>
                </div>
                <a class="btn-primary" 
                   href="<%= request.getContextPath() + "/" + rs.getString("file_path")%>" 
                   target="_blank">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M14 3v2h3.59L10 12.59 11.41 14 19 6.41V10h2V3h-7zM5 5h6V3H5a2 2 0 
                          00-2 2v14c0 1.1.9 2 2 2h14a2 2 0 
                          002-2v-6h-2v6H5V5z"/>
                    </svg>
                    Open
                </a>

            </div>

            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) {
                        rs.close();
                    }
                    if (ps != null) {
                        ps.close();
                    }
                    if (con != null) {
                        con.close();
                    }
                }
            %>
        </div>

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();
        </script>

    </body>
</html>

