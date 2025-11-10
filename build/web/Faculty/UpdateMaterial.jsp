<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    int materialId = Integer.parseInt(request.getParameter("id"));
    String subject = "", title = "", filePath = "";

    // Fetch existing material details
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM materials WHERE material_id=? AND faculty_id=?");
        ps.setInt(1, materialId);
        ps.setInt(2, facultyId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            subject = rs.getString("subject_name");
            title = rs.getString("title");
            filePath = rs.getString("file_path");
        }
        rs.close(); ps.close(); con.close();
    } catch(Exception e) {
        out.println("<script>alert('Error loading material: " + e.getMessage() + "');</script>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Update Material | Smart Campus</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<style>
    body {
        background-color: #f7f9fc;
        font-family: 'Poppins', sans-serif;
    }
    .container {
        max-width: 650px;
        margin-top: 60px;
        background: #fff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    h3 {
        color: #3b4fe4;
        font-weight: 600;
        text-align: center;
        margin-bottom: 25px;
    }
    label { font-weight: 600; margin-top: 10px; }
    input[type="text"], input[type="file"] {
        width: 100%; padding: 10px; border-radius: 8px;
        border: 1px solid #ccc; margin-bottom: 15px;
    }
    button {
        background: linear-gradient(135deg, #3b4fe4, #4c5de6);
        color: white; border: none;
        padding: 10px 25px; border-radius: 8px;
        font-size: 16px; cursor: pointer;
        transition: all 0.3s ease;
    }
    button:hover {
        background: linear-gradient(135deg, #2e3ce9, #5a67f0);
    }
</style>
</head>

<body>
<div class="container">
    <h3><i class="bi bi-pencil-square"></i> Update Material</h3>
    <!-- UPDATE FORM -->
<form action="ManageMaterialAction.jsp?action=update" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%= materialId %>">
    
    <div class="mb-3">
        <label>Subject</label>
        <input type="text" name="subject" value="<%= subject %>" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Title</label>
        <input type="text" name="title" value="<%= title %>" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Upload New File</label>
        <input type="file" name="file" class="form-control">
    </div>

    <button type="submit" class="btn btn-primary">Update</button>
</form>




</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
