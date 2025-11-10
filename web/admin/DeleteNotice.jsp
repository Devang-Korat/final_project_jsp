<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // --- Session Validation ---
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userid") == null) {
        response.sendRedirect("../login.html");
        return;
    }

    String idParam = request.getParameter("id");

    if (idParam != null && !idParam.trim().isEmpty()) {
        int noticeId = Integer.parseInt(idParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_campus", "root", "");

            PreparedStatement ps = con.prepareStatement("DELETE FROM notices WHERE notice_id = ?");
            ps.setInt(1, noticeId);
            ps.executeUpdate();

            ps.close();
            con.close();

            // ? Redirect instantly to notice.jsp after deletion
            response.sendRedirect("notice.jsp");
            return;

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='notice.jsp';</script>");
        }
    } else {
        out.println("<script>alert('Invalid notice ID.'); window.location='notice.jsp';</script>");
    }
%>
