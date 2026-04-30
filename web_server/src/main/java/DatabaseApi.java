import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.io.OutputStream;

public class DatabaseApi implements HttpHandler {

    @Override
    public void handle(HttpExchange http){
        System.out.println("Hello world!" + http.getRequestBody().toString());
        OutputStream out  = http.getResponseBody();
        byte[] response = "{\"msg\": \"Hello world!\"}".getBytes();
        try {
            http.sendResponseHeaders(200, response.length);
            out.write(response);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
