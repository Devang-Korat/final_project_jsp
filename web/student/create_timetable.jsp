<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Timetable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
        }
        .container {
            max-width: 800px;
            background: white;
            margin-top: 50px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #3246d3;
            margin-bottom: 25px;
        }
        .btn-primary {
            background-color: #3246d3;
            border: none;
        }
        .btn-primary:hover {
            background-color: #2236b5;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>📅 Create Timetable</h2>

    <form action="save_timetable.jsp" method="post">
        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Course:</label>
                <input type="text" name="course" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Class:</label>
                <input type="text" name="class" class="form-control" required>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Semester:</label>
                <select name="semester" class="form-select" required>
                    <option value="">Select Semester</option>
                    <%
                        for (int i = 1; i <= 8; i++) {
                    %>
                        <option value="<%= i %>"><%= i %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Day:</label>
                <select name="day" class="form-select" required>
                    <option value="">Select Day</option>
                    <option>Monday</option>
                    <option>Tuesday</option>
                    <option>Wednesday</option>
                    <option>Thursday</option>
                    <option>Friday</option>
                    <option>Saturday</option>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Subject Name:</label>
            <input type="text" name="subject_name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Faculty:</label>
            <select name="faculty_id" class="form-select" required>
                <option value="">Select Faculty</option>
                <%
                    // Fetch faculty list from DB
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
                        PreparedStatement ps = con.prepareStatement("SELECT faculty_id, name FROM faculty");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                            <option value="<%= rs.getInt("faculty_id") %>"><%= rs.getString("name") %></option>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading faculty</option>");
                    }
                %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Time Slot:</label>
            <input type="text" name="time_slot" class="form-control" placeholder="e.g., 10:00 AM - 11:00 AM" required>
        </div>

        <!-- ✅ Added Class Location Field -->
        <div class="mb-3">
            <label class="form-label">Class Location:</label>
            <input type="text" name="class_location" class="form-control" placeholder="e.g., Room 203, Lab 1" required>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary px-4">Save Timetable</button>
        </div>
    </form>
</div>

</body>
</html>
