<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.io.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    int facultyId = (Integer) sess.getAttribute("userid");
    String action = request.getParameter("action");

    if (action == null) {
        out.println("Invalid action");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

        if (action.equals("delete")) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);

                PreparedStatement ps = con.prepareStatement("SELECT file_name FROM materials WHERE material_id=? AND faculty_id=?");
                ps.setInt(1, id);
                ps.setInt(2, facultyId);
                ResultSet rs = ps.executeQuery();
                String fileName = null;
                if (rs.next()) fileName = rs.getString("file_name");
                rs.close();
                ps.close();

                // delete db row
                ps = con.prepareStatement("DELETE FROM materials WHERE material_id=? AND faculty_id=?");
                ps.setInt(1, id);
                ps.setInt(2, facultyId);
                ps.executeUpdate();
                ps.close();

                // delete file from uploads folder
                if (fileName != null) {
                    String path = application.getRealPath("../uploads/" + fileName);
                    File f = new File(path);
                    if (f.exists()) f.delete();
                }

                response.sendRedirect("Faculty_Student_Materials.jsp");
            } else {
                out.println("Missing material ID");
            }
        }
        else if (action.equals("update")) {
            String idStr = request.getParameter("id");
            String subject = request.getParameter("subject");
            String title = request.getParameter("title");

            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);

                PreparedStatement ps = con.prepareStatement("UPDATE materials SET subject=?, title=? WHERE material_id=? AND faculty_id=?");
                ps.setString(1, subject);
                ps.setString(2, title);
                ps.setInt(3, id);
                ps.setInt(4, facultyId);
                ps.executeUpdate();
                ps.close();

                response.sendRedirect("Faculty_Student_Materials.jsp");
            } else {
                out.println("Missing material ID for update");
            }
        }
        con.close();
    } 
%>
