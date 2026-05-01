import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.sql.*;

public class HardcodedCount implements HttpHandler {

    static final String url = "jdbc:mysql://localhost:3306/tutorsystem";
    static final String user = "root"; // or 'myuser' if you created a custom user
    private static String password = System.getenv("DB_PASSWORD");


    @Override
    public void handle(HttpExchange http) throws IOException {
            addCorsHeaders(http);
            String sql = "SELECT CountQualifiedTutors(?) AS tutorCount";
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, "C101"); // hardcoded input

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt("tutorCount");
                        sendJson(http, 200, "{\"qualified_tutor_count\" : \"" + count + "\"}");
                        System.out.println("Qualified tutors: " + count);
                        return;
                    }
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            } finally {
                sendJson(http, 500, "{\"error\":\"internal server error\"");
            }
        }



    private void sendJson(HttpExchange http, int statusCode, String response) throws IOException {
        byte[] bytes = response.getBytes(StandardCharsets.UTF_8);

//        http.getResponseHeaders().add("Content-Type", "application/json");
        http.sendResponseHeaders(statusCode, bytes.length);

        try (OutputStream out = http.getResponseBody()) {
            out.write(bytes);
        }
    }


    private void addCorsHeaders(HttpExchange http) {
        http.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        http.getResponseHeaders().add("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        http.getResponseHeaders().add("Access-Control-Allow-Headers", "Content-Type");
    }

}

