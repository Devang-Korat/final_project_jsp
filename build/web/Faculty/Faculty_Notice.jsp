<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String facultyName = "N/A";
    String statusMessage = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        // Fetch Faculty Name
        ps = con.prepareStatement("SELECT name FROM faculty WHERE faculty_id=?");
        ps.setInt(1, facultyId);
        rs = ps.executeQuery();
        if (rs.next()) facultyName = rs.getString("name");
        rs.close();
        ps.close();

        // Handle Actions
        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null) {
            String action = request.getParameter("action");

            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                ps = con.prepareStatement("INSERT INTO notices (title, description, posted_by, role, date) VALUES (?, ?, ?, 'faculty', NOW())");
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, facultyName);
                ps.executeUpdate();
                statusMessage = "? Notice added successfully!";
            }

            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("notice_id"));
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                ps = con.prepareStatement("UPDATE notices SET title=?, description=? WHERE notice_id=?");
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setInt(3, id);
                ps.executeUpdate();
                statusMessage = " Notice updated!";
            }

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("notice_id"));
                ps = con.prepareStatement("DELETE FROM notices WHERE notice_id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
                statusMessage = " Notice deleted!";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        statusMessage = "Database Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Notices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #eef2f7; font-family: 'Poppins', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; left: 0; top: 0; background: linear-gradient(180deg, #3b4fe4, #5563de); color: #fff; padding-top: 30px; }
        .sidebar a { display: flex; align-items: center; color: white; padding: 12px 25px; text-decoration: none; margin: 5px 0; gap: 10px; }
        .sidebar a:hover, .sidebar .active { background: rgba(255,255,255,0.2); border-radius: 8px; }
        .main-content { margin-left: 250px; padding: 30px; }

        .header-section { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .header-section .title { font-size: 1.8rem; font-weight: 600; color: #333; }
        .header-section .welcome-text { font-size: 1.4rem; color: #3b4fe4; font-weight: 700; }

        .notices-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 20px; }
        .notice-card { background: white; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); padding: 20px; position: relative; transition: 0.3s; }
        .notice-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
        .notice-title { font-weight: 600; font-size: 1.2rem; color: #2d2f39; margin-bottom: 10px; }
        .notice-desc { color: #555; font-size: 0.95rem; margin-bottom: 15px; min-height: 60px; }
        .notice-footer { display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; color: #888; }
        .notice-actions button { border: none; background: none; cursor: pointer; }
        .btn-floating { position: fixed; bottom: 40px; right: 40px; background: #3b4fe4; color: #fff; border-radius: 50%; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; font-size: 1.8rem; box-shadow: 0 4px 12px rgba(0,0,0,0.2); border: none; }
        .btn-floating:hover { background: #2c3dd3; }

        .modal-header { background: #3b4fe4; color: white; }
        .modal-title { font-weight: 600; }
        .btn-primary { background: #3b4fe4; border: none; }
        .btn-primary:hover { background: #2c3dd3; }
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
        <a href="Faculty_Students_Attandance.jsp"><i class="bi bi-clipboard-check"></i> Manage Attendance</a>
        <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Study Materials</a>
        <a href="faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
        <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
        <a href="Faculty_Notice.jsp" class="active"><i class="bi bi-megaphone-fill"></i> Notices</a>
    </div>

    <!-- Main -->
    <div class="main-content">
        <div class="header-section">
            <div class="title"><i class="bi bi-megaphone-fill"></i>  Notices</div>
            <div class="welcome-text">Prof. <%= facultyName %></div>
        </div>

        <% if (!statusMessage.isEmpty()) { %>
            <div class="alert alert-info"><%= statusMessage %></div>
        <% } %>

        <div class="notices-grid">
            <%
                try {
                    ps = con.prepareStatement("SELECT * FROM notices WHERE role='faculty' ORDER BY date DESC");
                    rs = ps.executeQuery();
                    boolean found = false;
                    while (rs.next()) {
                        found = true;
            %>
                        <div class="notice-card">
                            <div class="notice-title"><%= rs.getString("title") %></div>
                            <div class="notice-desc"><%= rs.getString("description") %></div>
                            <div class="notice-footer">
                                <div>
                                    <i class="bi bi-person-circle"></i> <%= rs.getString("posted_by") %><br>
                                    <i class="bi bi-calendar-event"></i> <%= rs.getTimestamp("date") %>
                                </div>
                                <div class="notice-actions">
                                    <button onclick="openEditModal('<%= rs.getInt("notice_id") %>', '<%= rs.getString("title").replace("'", "\\'") %>', '<%= rs.getString("description").replace("'", "\\'") %>')">
                                        <i class="bi bi-pencil-square text-warning fs-5"></i>
                                    </button>
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="notice_id" value="<%= rs.getInt("notice_id") %>">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit"><i class="bi bi-trash3-fill text-danger fs-5"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
            <%
                    }
                    if (!found) {
            %>
                        <p class="text-muted text-center mt-5">No notices available yet.</p>
            <%
                    }
                } catch (Exception e) {
                    out.print("<p class='text-danger'>Error loading notices.</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </div>
    </div>

    <!-- Floating Add Button -->
    <button class="btn-floating" data-bs-toggle="modal" data-bs-target="#addNoticeModal">
        <i class="bi bi-plus-lg"></i>
    </button>

    <!-- Add Modal -->
    <div class="modal fade" id="addNoticeModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" class="modal-content">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Notice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="4" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Add Notice</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editNoticeModal" tabindex="-1">
        <div class="modal-dialog">
            <form method="post" class="modal-content">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="notice_id" id="editNoticeId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Notice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" id="editNoticeTitle" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" id="editNoticeDescription" class="form-control" rows="4" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-warning">Update Notice</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(id, title, description) {
            document.getElementById("editNoticeId").value = id;
            document.getElementById("editNoticeTitle").value = title;
            document.getElementById("editNoticeDescription").value = description;
            new bootstrap.Modal(document.getElementById('editNoticeModal')).show();
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
