import java.sql.*;
import java.util.HashMap;

public class DB {
    private static Connection con;

    private static Connection getConnection() {
        if (con == null) {
            try {
                String host = "jdbc:mariadb://mariadb:3306/jeee";
                String user = "root";
                String pass = "mariadb";

                con = DriverManager.getConnection(host, user, pass);
            } catch (SQLException e) {
                e.printStackTrace();
                con = null;
            }
        }
        return con;
    }

    public static HashMap<String, String> getInfos() {
        Connection conn = getConnection();
        if (conn != null) {
            try {
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM info");
                ResultSet qry = stmt.executeQuery();

                if (qry.first()) {
                    return new HashMap<String, String>() {{
                        put("version", qry.getString("version"));
                        put("author", qry.getString("author"));
                        put("contact", qry.getString("contact"));
                    }};
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}
