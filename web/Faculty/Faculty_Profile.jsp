<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // --- 1. Session Check and Faculty Info Retrieval ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    
    // Default values in case fetching fails
    String facultyName = "N/A";
    String facultyEmail = "N/A";
    String facultyDepartment = "N/A";
    String facultyPhone = "N/A";
    String statusMessage = "";

    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // --- 2. Fetch Logged-in Faculty Details ---
        PreparedStatement ps = con.prepareStatement(
            "SELECT name, email, department, phone FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            facultyName = rs.getString("name");
            facultyEmail = rs.getString("email");
            facultyDepartment = rs.getString("department");
            facultyPhone = rs.getString("phone");
        } else {
            statusMessage = "Error: Faculty ID not found in the database.";
        }
        
        rs.close();
        ps.close();

    } catch (Exception e) {
        e.printStackTrace();
        statusMessage = "Database Error: Could not connect or query the database.";
    } finally {
        try {
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        /* Shared styles */
        body { background-color: #f7f9fc; font-family: 'Poppins', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; left: 0; top: 0; background: linear-gradient(180deg, #3b4fe4, #5563de); color: #fff; padding-top: 30px; }
        .sidebar h4 { text-align: center; margin-bottom: 30px; }
        .sidebar a { display: flex; align-items: center; color: white; padding: 12px 25px; text-decoration: none; margin: 5px 0; gap: 10px; }
        .sidebar a:hover { background: rgba(255,255,255,0.2); border-radius: 8px; }
        .sidebar svg { width: 18px; height: 18px; fill: white; }
        .header-section { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .header-section .title { font-size: 1.8rem; font-weight: 600; color: #333; }
        .header-section .welcome-text { font-size: 1.5rem; color: #3b4fe4; font-weight: 700; }
        .main-content { margin-left: 250px; padding: 30px; }

        /* Profile Specific Styles */
        .profile-card {
            max-width: 900px;
            margin: 30px auto;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .profile-header-strip {
            background-color: #3b4fe4;
            color: white;
            padding: 20px 30px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }
        .profile-title {
            font-weight: 700;
            display: flex;
            align-items: center;
            font-size: 1.8rem;
        }
        .profile-body-content {
            padding: 30px;
        }
        .data-item {
            padding: 15px 0;
            border-bottom: 1px dashed #eee;
        }
        .data-label {
            font-weight: 600;
            color: #555;
        }
        .data-value {
            color: #1a237e;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <h4 class="text-center mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="white" viewBox="0 0 24 24" width="20" height="20">
                <path d="M12 2L2 7v6c0 5 4 9 10 9s10-4 10-9V7l-10-5z"/>
            </svg> Faculty Portal
        </h4>

        <a href="Faculty_Dashboard.jsp"><i class="bi bi-grid-fill"></i> Dashboard</a>
         <a href="Faculty_Students.jsp"><i class="bi bi-people-fill"></i> Students</a>
         <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i> Manage Attendance</a>
         <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Study Materials</a>
         <a href="Faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
        <a href="Faculty_Profile.jsp"  class="active"><i class="bi bi-person-fill"></i> Profile</a>
         <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
    </div>
   

    <div class="main-content">
        <div class="header-section">
            <div class="title"><i class="bi bi-person-fill"></i> Profile Details</div>
            <div class="welcome-text">Prof. <%= facultyName %></div>
        </div>
        <div class="card profile-card">
            
            <div class="profile-header-strip">
                <h2 class="profile-title">
                    <i class="bi bi-person-badge-fill me-3" style="font-size: 2.5rem;"></i>
                    Faculty Profile: **Prof. <%= facultyName %>**
                </h2>
            </div>
            
            <div class="card-body profile-body-content">
                <% if (!statusMessage.isEmpty()) { %>
                    <div class="alert alert-danger" role="alert"><%= statusMessage %></div>
                <% } %>
                
                <div class="row g-4">
                    
                    <div class="col-md-6">
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-hash me-2"></i> Faculty ID</div>
                            <div class="data-value"><%= facultyId %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-person-fill me-2"></i> Full Name</div>
                            <div class="data-value"><%= facultyName %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-building-fill me-2"></i> Department</div>
                            <div class="data-value"><%= facultyDepartment %></div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-envelope-fill me-2"></i> Email Address</div>
                            <div class="data-value"><%= facultyEmail %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-telephone-fill me-2"></i> Phone Number</div>
                            <div class="data-value"><%= facultyPhone %></div>
                        </div>
                        <div class="data-item">
                            <div class="data-label"><i class="bi bi-shield-lock-fill me-2"></i> Role Status</div>
                            <div class="data-value text-success">Active Faculty Member</div>
                        </div>
                    </div>
                    
                </div>
                
                <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                    <a href="editProfile.jsp" class="btn btn-primary"><i class="bi bi-pencil-square me-2"></i>Edit Profile Information</a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 