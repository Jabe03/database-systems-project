import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.InetSocketAddress;

public class ApiServer  {

    public static void main(String[] args){
        try {
            HttpServer server = HttpServer.create(new InetSocketAddress("localhost", 8080), 0);
            DatabaseApi apiHandler = new DatabaseApi();
            server.createContext("/tutors", apiHandler);
            server.createContext("/performance", apiHandler);
            server.createContext("/enrollment", apiHandler);

            server.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
