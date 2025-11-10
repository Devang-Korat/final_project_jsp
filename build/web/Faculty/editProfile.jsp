<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String facultyName = "";
    String facultyPhone = "";
    String message = "";

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newName = request.getParameter("facultyName");
            String newPhone = request.getParameter("facultyPhone");

            PreparedStatement ps = con.prepareStatement("UPDATE faculty SET name=?, phone=? WHERE faculty_id=?");
            ps.setString(1, newName);
            ps.setString(2, newPhone);
            ps.setInt(3, facultyId);

            int rows = ps.executeUpdate();
           if (rows > 0) {
    message = "<div class='alert alert-success shadow-sm text-center fw-semibold' role='alert' "
            + "style='border-radius:12px;background:#e7f9ef;border:1px solid #b6e2c3;color:#146c43;'>"
            + "? Profile Updated Successfully!</div>";
} else {
    message = "<div class='alert alert-danger text-center' role='alert'>? Update Failed. Try Again!</div>";
}

            ps.close();
        }

        PreparedStatement ps2 = con.prepareStatement("SELECT name, phone FROM faculty WHERE faculty_id=?");
        ps2.setInt(1, facultyId);
        ResultSet rs = ps2.executeQuery();
        if (rs.next()) {
            facultyName = rs.getString("name");
            facultyPhone = rs.getString("phone");
        }
        rs.close();
        ps2.close();

    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='alert alert-danger text-center'>Database Connection Error!</div>";
    } finally {
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f7f9fc; font-family: 'Poppins', sans-serif; }
        .main-content { margin-left: 250px; padding: 40px; }

        .profile-card {
            max-width: 850px;
            margin: 50px auto;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }
        .profile-header-strip {
            background-color: #3b4fe4;
            color: white;
            padding: 20px 30px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.6rem;
            font-weight: 700;
        }
        .form-label { font-weight: 600; color: #333; }
        .form-control {
            border-radius: 10px;
            border: 1px solid #ccc;
            padding: 10px 12px;
        }
        .btn-primary-custom {
            background: linear-gradient(90deg, #3b4fe4, #5a68eb);
            border: none;
            color: #fff;
            border-radius: 8px;
            font-weight: 600;
            padding: 10px 22px;
            transition: 0.3s;
        }
        .btn-primary-custom:hover {
            background: linear-gradient(90deg, #5a68eb, #3b4fe4);
            transform: translateY(-2px);
        }
    </style>
</head>

<body>
    <div class="main-content">
        <div class="card profile-card">
            <div class="profile-header-strip">
                <i class="bi bi-pencil-square"></i> Edit Profile Information
            </div>

            <div class="card-body p-4">
                <%= message %>
                <form method="post">
                    <div class="mb-4">
                        <label class="form-label"><i class="bi bi-person-fill me-2"></i>Full Name</label>
                        <input type="text" name="facultyName" class="form-control" value="<%= facultyName %>" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label"><i class="bi bi-telephone-fill me-2"></i>Phone Number</label>
                        <input type="text" name="facultyPhone" class="form-control" value="<%= facultyPhone %>" pattern="[0-9]{10}" required>
                    </div>
                    <div class="d-flex justify-content-between">
                        <a href="Faculty_Profile.jsp" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left-circle me-2"></i>Back
                        </a>
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="bi bi-check-circle me-2"></i>Update Profile
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
