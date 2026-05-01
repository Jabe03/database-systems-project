import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseApi implements HttpHandler {

    @Override
    public void handle(HttpExchange http) {
        http.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        http.getResponseHeaders().add("Content-Type", "application/json");


        String path = http.getRequestURI().getPath();
        String jsonResponse = "";

        String url = "jdbc:mysql://localhost:3306/TutorSystem";
        String user = "root";
        String password = System.getenv("DB_PASSWORD");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "";


            if (path.equals("/tutors")) {
                sql = "SELECT TutorID, FirstName, LastName, HourlyRate FROM Tutors";
            } else if (path.equals("/performance")) {
                sql = "SELECT * FROM tutorPerformance";
            } else {
                jsonResponse = "{\"error\": \"Endpoint not found\"}";
            }


            if (!sql.isEmpty()) {
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();


                List<Map<String, Object>> resultsList = new ArrayList<>();


                while (rs.next()) {

                    Map<String, Object> row = new HashMap<>();

                    if (path.equals("/tutors")) {
                        row.put("id", rs.getString("TutorID"));
                        row.put("name", rs.getString("FirstName") + " " + rs.getString("LastName"));
                        row.put("rate", rs.getInt("HourlyRate"));
                    } else if (path.equals("/performance")) {
                        row.put("id", rs.getString("TutorID"));
                        row.put("name", rs.getString("FirstName") + " " + rs.getString("LastName"));
                        row.put("avgRating", rs.getDouble("AverageRating"));
                        row.put("totalReviews", rs.getInt("TotalReviews"));
                    }


                    resultsList.add(row);
                }


                Gson gson = new Gson();
                jsonResponse = gson.toJson(resultsList);
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse = "{\"error\": \"Database query failed.\"}";
        }

        // Send response
        try {
            byte[] responseBytes = jsonResponse.getBytes();
            http.sendResponseHeaders(200, responseBytes.length);
            OutputStream out = http.getResponseBody();
            out.write(responseBytes);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}