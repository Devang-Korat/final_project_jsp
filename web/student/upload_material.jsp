<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("role") == null || !"faculty".equals(sess.getAttribute("role"))) {
        response.sendRedirect("../login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload Study Material - Faculty Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
            background-color: #f7f8fc;
        }
        .sidebar {
            width: 240px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: linear-gradient(180deg, #3b4fe4, #5563de);
            color: #fff;
            padding-top: 30px;
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
            transition: background 0.3s;
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
        form {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            max-width: 600px;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
        }
        input[type="text"], select, input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        button {
            background: linear-gradient(135deg, #4455EE, #5A67F0);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }
        button:hover {
            background: linear-gradient(135deg, #2e3ce9, #4e5af5);
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="portal-title">
            <i data-lucide="book" style="width:22px;height:22px;"></i>
            <span style="font-weight: bold;">Faculty Portal</span>
        </div>

        <a href="faculty_dashboard.jsp">
            <i data-lucide="layout-dashboard"></i>
            <span>Dashboard</span>
        </a>

        <a href="upload_material.jsp" style="background: rgba(255,255,255,0.2); border-radius:8px;">
            <i data-lucide="upload"></i>
            <span>Upload Material</span>
        </a>

        <a href="view_uploaded_materials.jsp">
            <i data-lucide="folder"></i>
            <span>View Materials</span>
        </a>

        <a href="logout.jsp">
            <i data-lucide="log-out"></i>
            <span>Logout</span>
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <h2>📤 Upload Study Material</h2>

        <% 
            String msg = request.getParameter("msg");
            if (msg != null) {
                if (msg.equals("success")) out.print("<p style='color:green;'>✅ Material uploaded successfully!</p>");
                else if (msg.equals("error")) out.print("<p style='color:red;'>❌ Error uploading file.</p>");
                else if (msg.equals("nofile")) out.print("<p style='color:red;'>⚠️ Please select a file to upload.</p>");
            }
        %>

        <form action="../UploadMaterialServlet" method="post" enctype="multipart/form-data">
            <label>Subject Name:</label>
            <input type="text" name="subject" placeholder="Enter Subject Name" required>

            <label>Material Title:</label>
            <input type="text" name="title" placeholder="Enter Title" required>

            <label>Choose File:</label>
            <input type="file" name="file" accept=".pdf,.ppt,.pptx,.doc,.docx" required>

            <button type="submit">Upload</button>
        </form>
    </div>

    <script> lucide.createIcons(); </script>
</body>
</html>
