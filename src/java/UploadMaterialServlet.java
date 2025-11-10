import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/UploadMaterialServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
                 maxFileSize = 1024 * 1024 * 20,   // 20MB
                 maxRequestSize = 1024 * 1024 * 25) // 25MB
public class UploadMaterialServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sess = request.getSession(false);
        if (sess == null || sess.getAttribute("role") == null || !"faculty".equals(sess.getAttribute("role"))) {
            response.sendRedirect("../login.html");
            return;
        }

        int facultyId = (Integer) sess.getAttribute("userid");
        String subject = request.getParameter("subject");
        String title = request.getParameter("title");
        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("faculty/upload_material.jsp?msg=nofile");
            return;
        }

        String fileName = new File(filePart.getSubmittedFileName()).getName();
        String uploadDir = getServletContext().getRealPath("/") + "uploads/";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String filePath = "uploads/" + fileName;
        filePart.write(getServletContext().getRealPath("/") + filePath);

        Connection con = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");
            ps = con.prepareStatement(
                "INSERT INTO materials (faculty_id, subject_name, title, file_path) VALUES (?, ?, ?, ?)");
            ps.setInt(1, facultyId);
            ps.setString(2, subject);
            ps.setString(3, title);
            ps.setString(4, filePath);
            ps.executeUpdate();

            response.sendRedirect("student/upload_material.jsp?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student/upload_material.jsp?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
