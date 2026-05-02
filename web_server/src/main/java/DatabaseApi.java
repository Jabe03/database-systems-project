import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

public class DatabaseApi implements HttpHandler {
    static final String url = "jdbc:mysql://localhost:3306/tutorsystem";
    static final String user = "root"; // or 'myuser' if you created a custom user
    private static String password = System.getenv("DB_PASSWORD");


    @Override
    public void handle(HttpExchange http) {
        addHeaders(http);

        if(http.getRequestMethod().equals("GET")){
            handleGet(http);
        }
    }
    private void addHeaders(HttpExchange http) {
        http.getResponseHeaders().add("Content-Type", "application/json");
        http.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        http.getResponseHeaders().add("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        http.getResponseHeaders().add("Access-Control-Allow-Headers", "Content-Type");
    }
    private void handleGet(HttpExchange http){
        String path = http.getRequestURI().getPath();
        String jsonResponse = "";
        String url = "jdbc:mysql://localhost:3306/TutorSystem";
        String user = "root";
        String password = System.getenv("DB_PASSWORD");
        String sql = "";
        String[] parts = path.split("/");
        if (parts.length < 2 || parts[1].isEmpty()) {
            sendJson(http, 400, "{\"error\" : \"Invalid path\", \"value\" : \"" + path + "\"}");
            return;
        }
        TableName tableName = TableName.fromPath(parts[1]);
        System.out.println(tableName + ", from: " + parts[1] + " (full array: " + path + ")");
        if (tableName != null) {
            List<String> requestedColumns = getRequestedColumns(http);

            String selectedColumns;

            if (requestedColumns.size() == 1 && requestedColumns.get(0).equals("*")) {
                selectedColumns = "*";
            } else {
                selectedColumns = String.join(", ", requestedColumns);
            }

            sql = "SELECT " + selectedColumns + " FROM " + tableName;
        } else {
            sendJson(http, 404, "{\"error\": \"Endpoint not found\"}");
        }

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            if (!sql.isEmpty()) {
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();

                ResultSetMetaData meta = rs.getMetaData();
                int columnCount = meta.getColumnCount();

                Map<String, Object> responseMap = new HashMap<>();

                // columns
                List<String> columns = new ArrayList<>();
                for (int i = 1; i <= columnCount; i++) {
                    columns.add(meta.getColumnLabel(i));
                }

                // rows
                List<List<Object>> rows = new ArrayList<>();

                while (rs.next()) {
                    List<Object> row = new ArrayList<>();

                    for (int i = 1; i <= columnCount; i++) {
                        row.add(rs.getObject(i));
                    }

                    rows.add(row);
                }


                responseMap.put("columns", columns);
                responseMap.put("rows", rows);

                Gson gson = new GsonBuilder()
                        .setPrettyPrinting()
                        .create();
                jsonResponse = gson.toJson(responseMap);
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse = "{\"error\": \"Database query failed.\"}";
        }

        sendJson(http, 200, jsonResponse);
    }
    private List<String> getRequestedColumns(HttpExchange http) {
        String query = http.getRequestURI().getQuery(); // e.g. columns=TutorID,FirstName

        if (query == null || query.isEmpty()) {
            return List.of("*");
        }

        for (String param : query.split("&")) {
            String[] pair = param.split("=", 2);

            if (pair.length == 2 && pair[0].equalsIgnoreCase("columns")) {
                return Arrays.stream(pair[1].split(","))
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .toList();
            }
        }

        return List.of("*");
    }

    private void sendJson(HttpExchange http, int statusCode, String response) {
        byte[] bytes = response.getBytes(StandardCharsets.UTF_8);

//        http.getResponseHeaders().add("Content-Type", "application/json");
        try {
            http.sendResponseHeaders(statusCode, bytes.length);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (OutputStream out = http.getResponseBody()) {
            out.write(bytes);
        } catch (IOException e){
            e.printStackTrace();
        }
    }



}
