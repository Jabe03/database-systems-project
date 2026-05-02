import com.google.gson.*;
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

        if (http.getRequestMethod().equalsIgnoreCase("GET")) {
            handleGet(http);
        } else if (http.getRequestMethod().equalsIgnoreCase("POST")) {
            handlePost(http);
        } else if (http.getRequestMethod().equalsIgnoreCase("DELETE")) {
            handleDelete(http);
        } else {
            sendJson(http, 405, "{\"error\":\"Method not allowed\"}");
        }
    }


    private void addHeaders(HttpExchange http) {
        http.getResponseHeaders().add("Content-Type", "application/json");
        http.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        http.getResponseHeaders().add("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        http.getResponseHeaders().add("Access-Control-Allow-Headers", "Content-Type");
    }
    private void handleDelete(HttpExchange http) {
        String path = http.getRequestURI().getPath();
        String[] parts = path.split("/");

        if (parts.length < 3 || parts[1].isEmpty() || parts[2].isEmpty()) {
            sendJson(http, 400, "{\"error\":\"DELETE requires /tableName/id\"}");
            return;
        }

        TableName table = TableName.fromPath(parts[1]);

        if (table == null) {
            sendJson(http, 404, "{\"error\":\"Unknown table\"}");
            return;
        }

        String pk = table.primaryKey();

        if (pk == null) {
            sendJson(http, 400, "{\"error\":\"Composite PK tables not supported for DELETE\"}");
            return;
        }

        String id = parts[2];

        String url = "jdbc:mysql://localhost:3306/TutorSystem";
        String user = "root";
        String password = System.getenv("DB_PASSWORD");

        String sql = "DELETE FROM " + table + " WHERE " + pk + " = ?";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, id);

            int affected = stmt.executeUpdate();

            if (affected == 0) {
                sendJson(http, 404, "{\"message\":\"No row found to delete\"}");
            } else {
                sendJson(http, 200, "{\"message\":\"Row deleted\", \"affectedRows\":" + affected + "}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJson(http, 500, "{\"error\":\"Delete failed\"}");
        }
    }
    private void handlePost(HttpExchange http) {
    String path = http.getRequestURI().getPath();
    String[] parts = path.split("/");

    if (parts.length < 2 || parts[1].isEmpty()) {
        sendJson(http, 400, "{\"error\":\"Invalid path\"}");
        return;
    }

    TableName table = TableName.fromPath(parts[1]);

    if (table == null) {
        sendJson(http, 404, "{\"error\":\"Unknown table\"}");
        return;
    }

    String pkValue = null;

    if (parts.length >= 3 && !parts[2].isEmpty()) {
        pkValue = parts[2];
    }

    try {
        String body = new String(http.getRequestBody().readAllBytes());
        JsonObject json = JsonParser.parseString(body).getAsJsonObject();

        if (pkValue == null) {
            insertRow(http, table, json);
        } else {
            updateRow(http, table, pkValue, json);
        }

    } catch (Exception e) {
        e.printStackTrace();
        sendJson(http, 500, "{\"error\":\"POST request failed\"}");
    }
}


private void insertRow(HttpExchange http, TableName table, JsonObject json) throws Exception {
    String url = "jdbc:mysql://localhost:3306/TutorSystem";
    String user = "root";
    String password = System.getenv("DB_PASSWORD");

    List<String> columns = new ArrayList<>();
    List<Object> values = new ArrayList<>();

    for (String key : json.keySet()) {
        columns.add(key);
        values.add(getJsonValue(json.get(key)));
    }

    String placeholders = String.join(", ", Collections.nCopies(columns.size(), "?"));

    String sql = "INSERT INTO " + table + " (" +
            String.join(", ", columns) +
            ") VALUES (" +
            placeholders +
            ")";

    try (Connection conn = DriverManager.getConnection(url, user, password);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        for (int i = 0; i < values.size(); i++) {
            stmt.setObject(i + 1, values.get(i));
        }

        int affected = stmt.executeUpdate();

        sendJson(http, 201, "{\"message\":\"Row created\", \"affectedRows\":" + affected + "}");
    }
}


private void updateRow(HttpExchange http, TableName table, String pkValue, JsonObject json) throws Exception {
    String pk = table.primaryKey();

    if (pk == null) {
        sendJson(http, 400, "{\"error\":\"This table has a composite primary key and is not supported yet\"}");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/TutorSystem";
    String user = "root";
    String password = System.getenv("DB_PASSWORD");

    List<String> assignments = new ArrayList<>();
    List<Object> values = new ArrayList<>();

    for (String key : json.keySet()) {
        assignments.add(key + " = ?");
        values.add(getJsonValue(json.get(key)));
    }

    String sql = "UPDATE " + table +
            " SET " + String.join(", ", assignments) +
            " WHERE " + pk + " = ?";

    try (Connection conn = DriverManager.getConnection(url, user, password);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        for (int i = 0; i < values.size(); i++) {
            stmt.setObject(i + 1, values.get(i));
        }

        stmt.setObject(values.size() + 1, pkValue);

        int affected = stmt.executeUpdate();

        sendJson(http, 200, "{\"message\":\"Row updated\", \"affectedRows\":" + affected + "}");
    }
}


private Object getJsonValue(JsonElement element) {
    if (element.isJsonNull()) {
        return null;
    }

    if (element.isJsonPrimitive()) {
        if (element.getAsJsonPrimitive().isBoolean()) {
            return element.getAsBoolean();
        }

        if (element.getAsJsonPrimitive().isNumber()) {
            return element.getAsNumber();
        }

        if (element.getAsJsonPrimitive().isString()) {
            return element.getAsString();
        }
    }

    return element.toString();
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
