import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

public class DatabaseApi implements HttpHandler {
    static final String url = "jdbc:mysql://localhost:3306/tutorsystem";
    static final String user = "root"; // or 'myuser' if you created a custom user
    private static String password = System.getenv("DB_PASSWORD");


    @Override
    public void handle(HttpExchange http){
        addCorsHeaders(http);

        String path = http.getRequestURI().getPath();

        String requestMethod = http.getRequestMethod();

        try {
            if (requestMethod.equals("POST")) {

            } else if (requestMethod.equals("GET")) {

            } else {
                sendJson(http, 404, "{\"error\": \"Route not found\"");
            }
        } catch (Exception e) {
            e.printStackTrace();
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
