<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.io.*" %>
<%
    // --- Session Validation ---
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
    } catch(Exception e) { e.printStackTrace(); }

    // ---------- Handle delete / update logic ----------
    String action = request.getParameter("action");
    if (action != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

            // --- Delete Material ---
            if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));

                // Get file path
                PreparedStatement ps = con.prepareStatement("SELECT file_path FROM materials WHERE material_id=? AND faculty_id=?");
                ps.setInt(1, id);
                ps.setInt(2, facultyId);
                ResultSet rs = ps.executeQuery();
                String filePath = null;
                if (rs.next()) filePath = rs.getString("file_path");
                rs.close(); ps.close();

                // Delete record
                ps = con.prepareStatement("DELETE FROM materials WHERE material_id=? AND faculty_id=?");
                ps.setInt(1, id);
                ps.setInt(2, facultyId);
                ps.executeUpdate();
                ps.close();

                // Delete physical file
                if (filePath != null) {
                    String fullPath = application.getRealPath("../" + filePath);
                    File f = new File(fullPath);
                    if (f.exists()) f.delete();
                }

                con.close();
                response.sendRedirect("Faculty_Student_Materials.jsp");
                return;
            }

            // --- Update Material ---
            if (action.equals("update")) {
                int id = Integer.parseInt(request.getParameter("material_id"));
                String subject = request.getParameter("subject_name");
                String title = request.getParameter("title");

                PreparedStatement ps = con.prepareStatement("UPDATE materials SET subject_name=?, title=? WHERE material_id=? AND faculty_id=?");
                ps.setString(1, subject);
                ps.setString(2, title);
                ps.setInt(3, id);
                ps.setInt(4, facultyId);
                ps.executeUpdate();
                ps.close();

                con.close();
                response.sendRedirect("Faculty_Student_Materials.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Faculty Materials | Smart Campus</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f7f9fc;
        font-family: 'Poppins', sans-serif;
        margin: 0;
    }
    .sidebar {
        width: 240px;
        height: 100vh;
        position: fixed;
        left: 0; top: 0;
        background: linear-gradient(180deg, #3b4fe4, #5563de);
        color: #fff;
        padding-top: 30px;
    }
    .sidebar h4 { text-align: center; margin-bottom: 30px; }
    .sidebar a {
        display: flex; align-items: center;
        color: white; padding: 12px 25px; text-decoration: none;
        margin: 5px 0; gap: 10px;
    }
    .sidebar a:hover, .sidebar .active {
        background: rgba(255,255,255,0.2); border-radius: 8px;
    }

    .main-content { margin-left: 250px; padding: 30px; }
    .header-section {
        display: flex; justify-content: space-between; align-items: flex-end;
        margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 10px;
    }
    .title { font-size: 1.8rem; font-weight: 600; color: #333; }
    .welcome-text { font-size: 1.4rem; color: #3b4fe4; font-weight: 700; }

    .upload-container {
        background: #fff; border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        padding: 30px; margin-bottom: 40px;
    }
    .upload-container h4 {
        color: #3b4fe4; font-weight: 600; margin-bottom: 20px; text-align: center;
    }
    input[type="text"], input[type="file"] {
        width: 100%; padding: 10px; border-radius: 8px;
        border: 1px solid #ccc; margin-bottom: 15px;
    }
    button {
        background: linear-gradient(135deg, #3b4fe4, #4c5de6);
        color: white; border: none; padding: 10px 25px;
        border-radius: 8px; font-size: 16px; cursor: pointer;
        transition: all 0.3s ease;
    }
    button:hover { background: linear-gradient(135deg, #2e3ce9, #5a67f0); }

    table { width: 100%; text-align: center; border-collapse: collapse; }
    th { background-color: #3b4fe4; color: white; padding: 12px; }
    td { border: 1px solid #ddd; padding: 10px; vertical-align: middle; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #eef2ff; }

    /* --- custom button styles --- */
    .btn-view {
        background: linear-gradient(135deg, #4b7bec, #3867d6);
        color: white !important;
        border: none;
        padding: 6px 12px;
        border-radius: 6px;
    }
    .btn-view:hover { background: linear-gradient(135deg, #3a5fd9, #274cbd); }

    .btn-edit {
        background-color: #ffa41b !important;
        color: white !important;
        border: none;
        padding: 6px 12px;
        border-radius: 6px;
    }
    .btn-edit:hover { background-color: #ff8c00 !important; }
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
    <a href="Faculty_Dashboard.jsp"><i class="bi bi-grid-fill"></i> Dashboard</a>
    <a href="Faculty_Students.jsp"><i class="bi bi-people-fill"></i> Students</a>
    <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i> Attendance</a>
    <a href="Faculty_Student_Materials.jsp" class="active"><i class="bi bi-journal-text"></i> Materials</a>
    <a href="Faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
    <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
    <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="header-section">
        <div class="title"><i class="bi bi-journal-text"></i> Study Materials</div>
        <div class="welcome-text">Prof. <%= facultyName %></div>
    </div>

    <!-- Upload Form -->
    <div class="upload-container">
        <h4> Upload New Material</h4>
        <form action="../UploadMaterialServlet" method="post" enctype="multipart/form-data">
            <label>Subject Name:</label>
            <input type="text" name="subject" placeholder="Enter Subject Name" required>

            <label>Material Title:</label>
            <input type="text" name="title" placeholder="Enter Material Title" required>

            <label>Choose File:</label>
            <input type="file" name="file" accept=".pdf,.ppt,.pptx,.doc,.docx" required>

            <button type="submit"><i class="bi bi-cloud-upload"></i> Upload Material</button>
        </form>
    </div>

    <!-- Manage Materials -->
    <div class="material-table">
        <h4> Manage Uploaded Materials</h4>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Subject</th>
                    <th>Title</th>
                    <th>File</th>
                    <th>Uploaded On</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM materials WHERE faculty_id=?");
                    ps.setInt(1, facultyId);
                    ResultSet rs = ps.executeQuery();
                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
            %>
                <tr>
                    <td><%= rs.getInt("material_id") %></td>
                    <td><%= rs.getString("subject_name") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td>
                      <a href="<%= request.getContextPath() + "/" + rs.getString("file_path") %>" 
                            target="_blank" 
                            class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-eye-fill"></i> View
</a>

                    <td><%= rs.getString("upload_date") %></td>
                    <td>
                        <button class="btn btn-edit" 
                                data-bs-toggle="modal" 
                                data-bs-target="#editModal"
                                data-id="<%= rs.getInt("material_id") %>"
                                data-subject="<%= rs.getString("subject_name") %>"
                                data-title="<%= rs.getString("title") %>">
                            <i class="bi bi-pencil-square"></i> Edit
                        </button>

                        <form action="Faculty_Student_Materials.jsp" method="post" style="display:inline-block;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= rs.getInt("material_id") %>">
                            <button type="submit" class="btn btn-sm btn-danger" 
                                    onclick="return confirm('Delete this material permanently?');">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                    if (!hasData) {
            %>
                <tr><td colspan="6" class="text-muted fst-italic">No materials uploaded yet.</td></tr>
            <%
                    }
                    con.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='6' class='text-danger'>Error: "+e.getMessage()+"</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="Faculty_Student_Materials.jsp" method="post">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Update Material</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="material_id" id="edit-id">

          <label>Subject Name:</label>
          <input type="text" class="form-control mb-2" id="edit-subject" name="subject_name" required>

          <label>Material Title:</label>
          <input type="text" class="form-control" id="edit-title" name="title" required>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Pass data to modal
  const editModal = document.getElementById('editModal');
  editModal.addEventListener('show.bs.modal', event => {
    const button = event.relatedTarget;
    document.getElementById('edit-id').value = button.getAttribute('data-id');
    document.getElementById('edit-subject').value = button.getAttribute('data-subject');
    document.getElementById('edit-title').value = button.getAttribute('data-title');
  });
</script>
</body>
</html>