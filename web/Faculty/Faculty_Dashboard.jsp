<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String facultyName = "N/A";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT name FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) facultyName = rs.getString("name");
        rs.close(); ps.close(); con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Faculty Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f6f8fc;
        font-family: 'Poppins', sans-serif;
    }
    .sidebar {
        width: 240px;
        height: 100vh;
        position: fixed;
        background: linear-gradient(180deg,#3b4fe4,#5563de);
        color: #fff;
        padding-top: 30px;
    }
    .sidebar a {
        display: flex;
        align-items: center;
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        gap: 10px;
    }
    .sidebar a:hover, .sidebar .active {
        background: rgba(255,255,255,0.2);
        border-radius: 8px;
    }

    /* Header */
    /* Header */
.topbar {
    margin-left: 240px;
    height: 90px; /* increased height */
    background: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 40px;
    box-shadow: 0 3px 14px rgba(0,0,0,0.08);
    position: sticky;
    top: 0;
    z-index: 100;
}

    .welcome-text {
    font-size: 2rem;
    font-family: 'Poppins', sans-serif;
    color: #3b4fe4;
    letter-spacing: 0.5px;
    font-weight: 600; /* default weight for 'Welcome,' part */
}

.welcome-text b {
    font-weight: 800; /* bolder 'Prof. Name' */
}


   .logout-btn {
    background: #f44336;
    color: white;
    border: none;
    padding: 10px 24px;
    border-radius: 30px;
    font-weight: 600;
    font-size: 1rem;
    transition: 0.3s;
}
.logout-btn:hover {
    background: #d32f2f;
    transform: translateY(-2px);
}


    /* Main Content */
    .main-content {
        margin-left: 240px;
        padding: 40px;
    }

    /* Card Grid */
    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 25px;
    }

    .dashboard-card {
        background: white;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        text-align: center;
        padding: 25px 20px;
        transition: 0.3s;
    }
    .dashboard-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .dashboard-card i {
        font-size: 35px;
        color: #3b4fe4;
        margin-bottom: 12px;
    }
    .dashboard-card h5 {
        font-weight: 600;
        color: #333;
        margin-bottom: 6px;
    }
    .dashboard-card p {
        font-size: 0.9rem;
        color: #666;
        margin-bottom: 15px;
    }
    .dashboard-card button {
        background: #3b4fe4;
        color: white;
        border: none;
        border-radius: 20px;
        padding: 6px 16px;
        font-weight: 500;
        transition: 0.3s;
    }
    .dashboard-card button:hover {
        background: #2e3ac7;
    }
</style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">
   <h4 class="text-center mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="white" viewBox="0 0 24 24" width="20" height="20">
                <path d="M12 2L2 7v6c0 5 4 9 10 9s10-4 10-9V7l-10-5z"/>
            </svg> Faculty Portal
        </h4>
    <a href="Faculty_Dashboard.jsp" class="active"><i class="bi bi-grid-fill"></i> Dashboard</a>
    <a href="Faculty_Students.jsp"><i class="bi bi-people-fill"></i> Students</a>
    <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i> Attendance</a>
    <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Materials</a>
    <a href="Faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
    <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
    <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
</div>

<!-- Header -->
<div class="topbar">
   <div class="welcome-text"> Welcome, <b><%= facultyName %></b></div>

    <form action="../login.jsp" method="post" style="margin:0;">
        <button class="logout-btn"><i class="bi bi-box-arrow-right"></i> Logout</button>
    </form>
</div>

<!-- Main -->
<div class="main-content">
    <h3 class="fw-semibold mb-4 text-dark">Faculty Dashboard</h3>
    <div class="card-grid">
        <div class="dashboard-card">
            <i class="bi bi-people-fill"></i>
            <h5>Students</h5>
            <p>View and manage student information.</p>
            <button onclick="location.href='Faculty_Students.jsp'">Manage Students</button>
        </div>

        <div class="dashboard-card">
            <i class="bi bi-clipboard-check"></i>
            <h5>Attendance</h5>
            <p>Monitor and update student attendance.</p>
            <button onclick="location.href='Faculty_Students_Attandance.jsp'">Manage Attendance</button>
        </div>

        <div class="dashboard-card">
            <i class="bi bi-journal-text"></i>
            <h5>Study Materials</h5>
            <p>Upload and manage class materials.</p>
            <button onclick="location.href='Faculty_Student_Materials.jsp'">View Materials</button>
        </div>

        <div class="dashboard-card">
            <i class="bi bi-clock-history"></i>
            <h5>Timetable</h5>
            <p>View or modify your class timetable.</p>
            <button onclick="location.href='manageTimetable.jsp'">View Timetable</button>
        </div>

        <div class="dashboard-card">
            <i class="bi bi-megaphone-fill"></i>
            <h5>Notices</h5>
            <p>Publish updates and announcements.</p>
            <button onclick="location.href='Faculty_Notice.jsp'">Post Notice</button>
        </div>

        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
