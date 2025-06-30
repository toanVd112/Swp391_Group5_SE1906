package controller.tuan;

import DAO.ServiceDAO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.util.Map;

@WebServlet(name = "IsDuplicatedServiceName", urlPatterns = {"/services/dupe"})
public class IsDuplicatedServiceName extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StringBuilder stringBuilder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        }
        String inputString = stringBuilder.toString();

        Gson gson = new Gson();
        Type mapType = new TypeToken<Map<String, Object>>() {}.getType();
        Map<String, Object> jsonMap = gson.fromJson(inputString, mapType);

        String serviceName = (String) jsonMap.get("name");
        String idStr = (String) jsonMap.get("id");
        int serviceId = -1;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                serviceId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                // Ignore invalid ID
            }
        }

        boolean isDupeServiceName = new ServiceDAO().isDuplicatedServiceName(serviceName, serviceId);

        String responseMessage = isDupeServiceName ? "true" : "false";
        String responseJson = gson.toJson(responseMessage);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(responseJson);
            out.flush();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Checks if a service name is duplicated, excluding the current service ID.";
    }
}