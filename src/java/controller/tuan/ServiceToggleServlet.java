package controller.tuan;

import DAO.ServiceDAO;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/services/toggle")
public class ServiceToggleServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAO(); // Khởi tạo ServiceDAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try {
            // Đọc JSON từ request body
            BufferedReader reader = request.getReader();
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }

            // Kiểm tra nếu JSON rỗng
            String jsonString = jsonBuilder.toString();
            if (jsonString.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Empty request body\"}");
                return;
            }

            // Parse JSON để lấy id
            JsonObject jsonObject = new JsonParser().parse(jsonString).getAsJsonObject();
            if (!jsonObject.has("id")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Missing id field\"}");
                return;
            }
            String serviceId = jsonObject.get("id").getAsString();
            int id = 0;
            try {
                id = Integer.parseInt(serviceId);
            } catch (Exception e) {
            }

            // Cập nhật trạng thái service qua ServiceDAO
            boolean success = serviceDAO.toggleServiceStatus(id);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\": \"Update Status Success\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to update status\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}
