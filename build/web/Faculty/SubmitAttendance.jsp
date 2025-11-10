<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*, java.time.LocalDate, java.net.URLEncoder" %>
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

    Integer facultyIdObj = (Integer) sess.getAttribute("userid");
    if (facultyIdObj == null) {
        response.sendRedirect("login.html");
        return;
    }
    int facultyId = facultyIdObj.intValue();

    Connection con = null;
    PreparedStatement ps = null;
    
    String message = "Attendance submitted successfully!";
    String messageType = "success"; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus?useSSL=false", "root", "");
        
        // Use transaction management
        con.setAutoCommit(false);
        
        // SQL statement for insertion
        String sql = "INSERT INTO attendance (student_id, faculty_id, subject_name, date, status) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        
        // Logic to find all unique student IDs submitted (by checking for status_ parameters)
        Enumeration<String> paramNames = request.getParameterNames();
        Set<Integer> studentIds = new HashSet<>();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("status_")) {
                try {
                    int studentId = Integer.parseInt(paramName.substring(7));
                    studentIds.add(studentId);
                } catch (NumberFormatException e) {
                    // Ignore invalid parameter names
                }
            }
        }
        
        int rowsProcessed = 0;
        
        // Iterate through each student ID found
        for (int studentId : studentIds) {
            String status = request.getParameter("status_" + studentId);
            String subject = request.getParameter("subject_" + studentId);
            String dateStr = request.getParameter("date_" + studentId);

            // CRITICAL SERVER-SIDE CHECK: Only process if ALL three fields are present and not empty.
            if (status != null && !status.isEmpty() && 
                subject != null && !subject.isEmpty() && 
                dateStr != null && !dateStr.isEmpty()) {
                
                // Fields are complete, proceed with database preparation
                ps.setInt(1, studentId);
                ps.setInt(2, facultyId);
                ps.setString(3, subject);
                ps.setDate(4, java.sql.Date.valueOf(dateStr));
                ps.setString(5, status); 

                ps.addBatch(); // Add to batch
                rowsProcessed++;
            }
            // If the row is incomplete, it is safely skipped.
        }

        if (rowsProcessed > 0) {
            ps.executeBatch(); // Execute batch insert
            con.commit(); // Commit transaction
            message = rowsProcessed + " attendance record(s) submitted successfully!";
        } else {
            // This happens if the user submitted the form but left every row incomplete.
            message = "No complete attendance data was submitted. Please ensure status, subject, and date are chosen for the student(s) you wish to record.";
            messageType = "warning";
        }

    } catch (SQLIntegrityConstraintViolationException e) {
        messageType = "error";
        // Specific error message for duplicates (most common issue)
        message = "Submission Error: Attendance record already exists for one or more students for the selected date/subject.";
        try { if (con != null) con.rollback(); } catch (SQLException ex) { /* ignored */ }
    } catch (SQLException e) {
        messageType = "error";
        // Generic SQL error message (the one seen in your screenshot)
        message = "Database Error: Failed to submit attendance. Check table schema and console for details.";
        try { if (con != null) con.rollback(); } catch (SQLException ex) { /* ignored */ }
        e.printStackTrace(); // <-- Check your server console for the full stack trace!
    } catch (Exception e) {
        messageType = "error";
        message = "An unexpected error occurred: " + e.getMessage();
        e.printStackTrace();
    } finally {
        // Close resources
        try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
        try { if (con != null) con.close(); } catch (Exception e) { /* ignored */ }
    }
    
    // Redirect back to the attendance page with a status message (URL encoded)
    String redirectURL = "Faculty_Students_Attandance.jsp?status=" + messageType + "&msg=" + URLEncoder.encode(message, "UTF-8");
    response.sendRedirect(redirectURL);
%>