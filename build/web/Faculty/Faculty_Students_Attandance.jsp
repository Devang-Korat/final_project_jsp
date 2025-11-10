<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*, javax.servlet.*, java.time.LocalDate" %>
<%
    // Set content type and encoding
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");

    // --- Session Check ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Safely retrieve facultyId
    Integer facultyIdObj = (Integer) sess.getAttribute("userid");
    if (facultyIdObj == null) {
        response.sendRedirect("login.html");
        return;
    }
    int facultyId = facultyIdObj.intValue();
    
    String facultyName = "Professor";

    // SQL Resources
    Connection con = null;
    PreparedStatement psF = null;
    PreparedStatement psSub = null;
    Statement st = null;
    ResultSet rsF = null;
    ResultSet rsSub = null;
    ResultSet rsStu = null;
    
    // Data Containers
    StringBuilder attendanceRows = new StringBuilder();
    List<String> subjects = new ArrayList<>();
    
    try {
        // 1. Establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus?useSSL=false", "root", "");

        // 2. Fetch faculty name
        psF = con.prepareStatement("SELECT name FROM faculty WHERE faculty_id=?");
        psF.setInt(1, facultyId);
        rsF = psF.executeQuery();
        if (rsF.next()) {
            facultyName = rsF.getString("name");
        }

        // 3. Fetch subjects assigned to this faculty
        psSub = con.prepareStatement(
            "SELECT subject_name FROM faculty_subjects WHERE faculty_id=?");
        psSub.setInt(1, facultyId);
        rsSub = psSub.executeQuery();
        while (rsSub.next()) {
            subjects.add(rsSub.getString("subject_name"));
        }

        // 4. Fetch all students (INCLUDING the course field)
        st = con.createStatement();
        rsStu = st.executeQuery("SELECT student_id, Enrollment, name, course, semester FROM students ORDER BY name ASC");

        // 5. Build HTML table rows
        String currentDate = java.time.LocalDate.now().toString();

        while (rsStu.next()) {
            int studentId = rsStu.getInt("student_id");
            String enrollment = rsStu.getString("Enrollment");
            String studentName = rsStu.getString("name");
            String studentCourse = rsStu.getString("course"); 
            int semester = rsStu.getInt("semester");

            attendanceRows.append("<tr data-student-id='").append(studentId).append("'>");
            attendanceRows.append("<td>").append(enrollment).append("</td>");
            attendanceRows.append("<td>").append(studentName).append("</td>");

            // Course Name (Static display)
            attendanceRows.append("<td>").append(studentCourse).append("</td>");

            // Subject dropdown - ADDED 'required' and a helpful class
            attendanceRows.append("<td><select class='form-select form-select-sm subject-select' name='subject_")
                          .append(studentId).append("' >");
            attendanceRows.append("<option value='' disabled selected>Select Subject</option>");
            for (String subj : subjects) {
                attendanceRows.append("<option value='").append(subj).append("'>")
                              .append(subj).append("</option>");
            }
            attendanceRows.append("</select></td>");

            // Date picker - ADDED 'required' and a helpful class
            attendanceRows.append("<td><input type='date' class='form-control form-control-sm date-input' name='date_")
                          .append(studentId).append("' value='").append(currentDate).append("' required></td>");

            // Status outline-button group - REMOVED 'Late'
            attendanceRows.append("<td>");
            attendanceRows.append("<div class='btn-group btn-group-sm status-outline-group' role='group' aria-label='Attendance status'>");
            attendanceRows.append("<button type='button' class='btn btn-outline-success status-btn' data-value='Present'>")
                          .append("<i class='bi bi-check2 me-1'></i> Present</button>");
            attendanceRows.append("<button type='button' class='btn btn-outline-danger status-btn' data-value='Absent'>")
                          .append("<i class='bi bi-x2 me-1'></i> Absent</button>");
            // Hidden input for status - ADDED 'required' and a class
            attendanceRows.append("<input type='hidden' name='status_").append(studentId).append("' class='status-val status-input' value='' required>");
            attendanceRows.append("</div>");
            attendanceRows.append("</td>");

            // Semester
            attendanceRows.append("<td>").append(semester).append("</td>");
            attendanceRows.append("</tr>");
        }

        if (attendanceRows.length() == 0) {
            attendanceRows.append("<tr><td colspan='7' class='text-center text-muted'>No students found.</td></tr>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        attendanceRows.setLength(0);
        attendanceRows.append("<tr><td colspan='7' style='color:red;'>**Error:** Database error: ").append(e.getMessage()).append("</td></tr>");
    } finally {
        // --- Close resources reliably ---
        try { if (rsF != null) rsF.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (psF != null) psF.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (rsSub != null) rsSub.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (psSub != null) psSub.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (rsStu != null) rsStu.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (st != null) st.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f7f9fc; font-family: 'Poppins', sans-serif; }
        .sidebar {
            width: 240px; height: 100vh; position: fixed; left: 0; top: 0;
            background: linear-gradient(180deg, #3b4fe4, #5563de); color: #fff;
            padding-top: 30px;
        }
        .sidebar h4 { text-align: center; margin-bottom: 30px; }
        .sidebar a {
            display: flex; align-items: center; color: white;
            padding: 12px 25px; text-decoration: none; margin: 5px 0; gap: 10px;
        }
        .sidebar a:hover, .sidebar a.active {
            background: rgba(255,255,255,0.2); border-radius: 8px;
        }
        .main-content { margin-left: 250px; padding: 30px; }
        .header-section {
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 10px;
        }
        .header-section .title {
            font-size: 1.8rem; font-weight: 600; color: #333;
        }
        .header-section .welcome-text {
            font-size: 1.5rem; color: #3b4fe4; font-weight: 700;
        }
        .student-table th {
            background-color: #3b4fe4; color: white; text-align: center;
        }
        .student-table td {
            text-align: center; vertical-align: middle;
        }
        /* Additional styles for outline button group */
        .status-outline-group .status-btn.active {
            color: #fff;
        }
        .status-outline-group .status-btn.active.btn-outline-success {
            background-color: #28a745; border-color: #28a745;
        }
        .status-outline-group .status-btn.active.btn-outline-danger {
            background-color: #dc3545; border-color: #dc3545;
        }
        /* REMOVED .status-outline-group .status-btn.active.btn-outline-warning style */
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
        <a href="Faculty_Students_Attandance.jsp" class="active"><i class="bi bi-clipboard-check"></i> Manage Attendance</a>
        <a href="Faculty_Student_Materials.jsp"><i class="bi bi-journal-text"></i> Study Materials</a>
        <a href="Faculty_Timetable.jsp"><i class="bi bi-clock-history"></i> Timetable</a>
        <a href="Faculty_Profile.jsp"><i class="bi bi-person-fill"></i> Profile</a>
        <a href="Faculty_Notice.jsp"><i class="bi bi-megaphone-fill"></i> Notices</a>
    </div>

    <div class="main-content">
        <div class="header-section">
            <div class="title"><i class="bi bi-clipboard-check me-2"></i> Student Attendance Details</div>
            <div class="welcome-text">Prof. <%= facultyName %></div>
        </div>
        
        <%
            String status = request.getParameter("status");
            String msg = request.getParameter("msg");
            if (status != null && msg != null) {
                String alertClass = "";
                String iconClass = "";
                if (status.equals("success")) {
                    alertClass = "alert-success";
                    iconClass = "bi-check-circle-fill";
                } else if (status.equals("error")) {
                    alertClass = "alert-danger";
                    iconClass = "bi-exclamation-triangle-fill";
                } else { // warning/info
                    alertClass = "alert-warning";
                    iconClass = "bi-info-circle-fill";
                }
        %>
                <div class="alert <%= alertClass %> alert-dismissible fade show" role="alert">
                    <i class="bi <%= iconClass %> me-2"></i>
                    **Submission Status:** <%= msg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
        <%
            }
        %>
        <div class="card shadow-sm">
            <div class="card-body">
                <form action="SubmitAttendance.jsp" method="post" id="attendanceForm">
                    <table class="table table-striped table-hover student-table">
                        <thead>
                            <tr>
                                <th>Enrollment No.</th>
                                <th>Name</th>
                                <th>Course Name</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Semester</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%= attendanceRows.toString() %>
                        </tbody>
                    </table>
                    <div class="text-end mt-3">
                        <button type="submit" class="btn btn-primary">Submit Attendance</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    const form = document.getElementById('attendanceForm');

    // 1. Handle Status Button Clicks (Now only Present/Absent)
    document.querySelectorAll('.status-outline-group').forEach(group => {
      group.addEventListener('click', e => {
        const btn = e.target.closest('.status-btn');
        if (!btn) return;
        
        // Remove 'active' from all buttons in this group
        group.querySelectorAll('.status-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        
        const statusInput = group.querySelector('.status-val');
        statusInput.value = btn.getAttribute('data-value');
      });
    });
    
    // 2. CRITICAL FIX: Dynamically manage 'required' attributes on form submission (This ensures single-row submission works)
    form.addEventListener('submit', function(event) {
        
        document.querySelectorAll('tr[data-student-id]').forEach(row => {
            const statusInput = row.querySelector('.status-val');
            const subjectSelect = row.querySelector('.subject-select');
            const dateInput = row.querySelector('.date-input');

            // Check if status is NOT selected (i.e., this row is being ignored)
            if (statusInput && statusInput.value === '') {
                // If the row is incomplete/ignored, remove the required attributes
                if (subjectSelect) subjectSelect.removeAttribute('required');
                if (dateInput) dateInput.removeAttribute('required');
                if (statusInput) statusInput.removeAttribute('required');
            } else {
                 // Status IS selected. We must ensure the other fields are required 
                 if (subjectSelect) subjectSelect.setAttribute('required', 'required');
                 if (dateInput) dateInput.setAttribute('required', 'required');
                 if (statusInput) statusInput.setAttribute('required', 'required');
            }
        });
        
        // The form will now validate only the selected rows and proceed to the server handler.
    });

    </script>
</body>
</html>