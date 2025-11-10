package db;
import java.sql.*;
public class DBConnection {
    private static Connection conn = null;

    public static Connection getConnection() {
        try {
            if (conn == null) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/smart_campus", 
                    "root", 
                    ""
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
