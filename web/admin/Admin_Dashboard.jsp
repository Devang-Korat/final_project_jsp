        <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>

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
                transition: width 0.3s ease;
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
                transition: background 0.3s, border-radius 0.3s, padding 0.3s;
                white-space: nowrap;
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

            /* Action Cards */
            .action-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .card-box {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                text-align: center;
                transition: transform 0.2s;
            }

            .card-box:hover {
                transform: translateY(-4px);
            }

            .card-box i {
                width: 35px;
                height: 35px;
                margin-bottom: 10px;
                color: #3b4fe4;
            }

            .card-box h5 {
                font-weight: 600;
                margin-bottom: 8px;
                color: #000;
            }

            .card-box p {
                font-size: 14px;
                color: #777;
                margin-bottom: 10px;
            }

            .card-box .btn {
                background-color: #3b4fe4;
                border: none;
                font-size: 14px;
                font-weight: 500;
                border-radius: 6px;
                transition: all 0.2s ease;
            }

            .card-box .btn:hover {
                background-color: #2d3edb;
                transform: translateY(-2px);
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

            .lucide {
                color: black !important;
                stroke: black !important;
                fill: none !important;
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

            <a href="Admin_Dashboard.jsp">
                <i data-lucide="layout-dashboard"></i>
                <span>Dashboard</span>
            </a>

            <a href="Profile.jsp">
                <i data-lucide="user"></i>
                <span>Profile</span>
            </a>

            <a href="Attandance.jsp">
                <i data-lucide="clipboard-list"></i>
                <span>Student Attendance</span>
            </a>

            <a href="Students.jsp">
                <i data-lucide="user-round-cog"></i>
                <span>Manage Student</span>
            </a>

            <a href="Faculty.jsp">
                <i data-lucide="users-round"></i>
                <span>Manage Faculty</span>
            </a>

            <a href="timetable.jsp">
                <i data-lucide="calendar-days"></i>
                <span>Timetable</span>
            </a>

            <a href="notice.jsp">
                <i data-lucide="bell"></i>
                <span>Notice</span>
            </a>

            <a href="logout.jsp">
                <i data-lucide="log-out"></i>
                <span>Logout</span>
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="dashboard-header">
                <h2>Admin Dashboard</h2>
                <span>Welcome, Admin</span>
            </div>

            <!-- Action Cards -->
            <div class="action-cards">
                <div class="card-box">
                    <i data-lucide="users"></i>
                    <h5>Manage Students</h5>
                    <p>Add or update student records.</p>
                    <a href="Students.jsp" class="btn btn-primary btn-sm mt-2">Manage Students</a>
                </div>

                <div class="card-box">
                    <i data-lucide="check-square"></i>
                    <h5>Attendance</h5>
                    <p>Monitor and update student attendance.</p>
                    <a href="Attandance.jsp" class="btn btn-primary btn-sm mt-2">Manage Attendance</a>
                </div>

                <div class="card-box">
                    <i data-lucide="users-round"></i>
                    <h5>Manage Faculty</h5>
                    <p>Add, update or remove faculty information.</p>
                    <a href="Faculty.jsp" class="btn btn-primary btn-sm mt-2">Manage Faculty</a>
                </div>

                <div class="card-box">
                    <i data-lucide="bell"></i>
                    <h5>Notices</h5>
                    <p>Publish important updates and announcements.</p>
                    <a href="notice.jsp" class="btn btn-primary btn-sm mt-2">Post Notice</a>
                </div>

                <div class="card-box">
                    <i data-lucide="calendar"></i>
                    <h5>Timetable</h5>
                    <p>View and update class schedules.</p>
                    <a href="timetable.jsp" class="btn btn-primary btn-sm mt-2">Edit Timetable</a>
                </div>
            </div>
        </div>

        <script>
            lucide.createIcons();
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
