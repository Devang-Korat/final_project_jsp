<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    String message = "";
    int id = 0;

    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        message = "Invalid timetable ID.";
    }

    if (id > 0) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
            ps = con.prepareStatement("DELETE FROM timetable WHERE timetable_id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                message = "Timetable deleted successfully!";
            } else {
                message = "Error: Timetable not found.";
            }
        } catch (Exception e) {
            message = "Database Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Timetable</title>
    <!-- ? Redirect after exactly 2 seconds -->
    <meta http-equiv="refresh" content="2;URL=timetable.jsp">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f6fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            max-width: 600px;
            margin-top: 120px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            padding: 40px;
            text-align: center;
        }

        h3 {
            color: #3b4fe4;
            font-weight: 700;
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

        p {
            color: #555;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="icon-box">
            <i class="bi bi-trash" style="font-size: 2rem;"></i>
        </div>
        <h3><%= message %></h3>
        <p class="mt-3">You will be redirected to the timetable page in 2 seconds...</p>
        <a href="timetable.jsp" class="btn btn-primary mt-3">
            <i class="bi bi-arrow-left"></i> Go Back Now
        </a>
    </div>

    <script>
        lucide.createIcons();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
