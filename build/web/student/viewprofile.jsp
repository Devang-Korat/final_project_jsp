<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int studentId = (Integer) sess.getAttribute("userid");
    String name = "", email = "", course = "", phone = "", password = "", class1 = "";
    int enrollment = 0, semester = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM students WHERE student_id=?");
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            password = rs.getString("password");
            phone = rs.getString("phone");
            course = rs.getString("course");
            class1 = rs.getString("Class");
            semester = rs.getInt("semester");
            enrollment = rs.getInt("Enrollment");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                background-color: #f8f9fc;
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
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

            /* Main layout */
            .main-content {
                margin-left: 260px;
                padding: 30px;
            }

            .profile-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                background: #3b4fe4;
                color: white;
                font-size: 36px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 10px;
            }

            .edit-btn, .save-btn {
                background: #3b4fe4;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                text-decoration: none;
            }
            .edit-btn:hover, .save-btn:hover {
                background: #2e3fc2;
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
            <h3 class="mb-4">View Profile</h3>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="profile-card text-center">
                        <div class="profile-avatar"><%= name.isEmpty() ? "?" : name.substring(0, 1).toUpperCase()%></div>
                        <form method="post">
                            <input type="text" name="newName" id="nameField" class="form-control text-center" value="<%= name%>" readonly style="margin-bottom:10px;">
                            <p style="color:gray;"><%= course%></p>
                            <p>Roll No: <%= enrollment%></p>
                            <button type="button" class="edit-btn" id="editBtn" onclick="enableEdit()">Edit Name</button>
                            <button type="submit" class="save-btn" id="saveBtn" style="display:none;">Save</button>
                        </form>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="profile-card">
                        <h5>Personal Information</h5>
                        <hr>
                        <p><strong>University Name:</strong> Marwadi University</p>
                        <p><strong>Full Name:</strong> <%= name%></p>
                        <p><strong>Email:</strong> <%= email%></p>
                        <p><strong>Email Passowrd:</strong> <%= password%></p>
                        <p><strong>Phone:</strong> <%= phone%></p>
                        <p><strong>Course:</strong> <%= course%></p>
                        <p><strong>Class:</strong> <%= class1%></p>
                        <p><strong>Semester:</strong> <%= semester%></p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function enableEdit() {
                document.getElementById("nameField").removeAttribute("readonly");
                document.getElementById("nameField").focus();
                document.getElementById("editBtn").style.display = "none";
                document.getElementById("saveBtn").style.display = "inline-block";
            }
        </script>

    </body>
</html>