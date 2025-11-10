<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    String message = "";
    try {
        String course = request.getParameter("course");
        String className = request.getParameter("class");
        int semester = Integer.parseInt(request.getParameter("semester"));
        String day = request.getParameter("day");
        String subject_name = request.getParameter("subject_name");
        int faculty_id = Integer.parseInt(request.getParameter("faculty_id"));
        String time_slot = request.getParameter("time_slot");
        String classLocation = request.getParameter("class_location");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        String sql = "INSERT INTO timetable (course, semester, day, subject_name, faculty_id, time_slot, class_location, class) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, course);
        ps.setInt(2, semester);
        ps.setString(3, day);
        ps.setString(4, subject_name);
        ps.setInt(5, faculty_id);
        ps.setString(6, time_slot);
        ps.setString(7, classLocation);
        ps.setString(8, className);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            message = "Timetable created successfully!";
        } else {
            message = "Failed to create timetable.";
        }
        ps.close();
        con.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Save Timetable</title>
    <meta http-equiv="refresh" content="2; URL=timetable.jsp">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            max-width: 600px;
            margin-top: 120px;
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            text-align: center;
        }
        h3 {
            color: #3b4fe4;
            font-weight: bold;
        }
        .icon-box {
            background: #e8ecff;
            color: #3b4fe4;
            border-radius: 50%;
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .btn-primary {
            background-color: #3b4fe4;
            border: none;
        }
        .btn-primary:hover {
            background-color: #3246d3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon-box">
            <i class="bi bi-check-circle" style="font-size: 2rem;"></i>
        </div>
        <h3><%= message %></h3>
        <p class="mt-3 text-muted">Redirecting to Timetable page in 2 seconds...</p>
        <a href="timetable.jsp" class="btn btn-primary mt-3">
            <i class="bi bi-arrow-left"></i> Go Back Now
        </a>
    </div>
</body>
</html>
