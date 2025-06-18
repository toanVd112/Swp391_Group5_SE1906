// Gói (package) chứa class này, giúp tổ chức code theo thư mục controller.tuan
package controller.tuan;

// Các thư viện (import) cần thiết để class hoạt động
import DAO.ServiceDAO; // Lớp ServiceDAO để tương tác với cơ sở dữ liệu (cập nhật trạng thái dịch vụ)
import com.google.gson.JsonObject; // Lớp để xử lý dữ liệu JSON (định dạng dữ liệu giống như một cặp key-value)
import com.google.gson.JsonParser; // Lớp để phân tích (parse) chuỗi JSON thành đối tượng Java
import jakarta.servlet.ServletException; // Xử lý lỗi liên quan đến servlet
import jakarta.servlet.annotation.WebServlet; // Đánh dấu đây là một servlet và định nghĩa URL
import jakarta.servlet.http.HttpServlet; // Lớp cha của servlet, cung cấp các chức năng cơ bản
import jakarta.servlet.http.HttpServletRequest; // Đại diện cho yêu cầu từ trình duyệt (như dữ liệu JSON)
import jakarta.servlet.http.HttpServletResponse; // Đại diện cho phản hồi gửi về trình duyệt
import java.io.BufferedReader; // Đọc dữ liệu từ luồng (stream) một cách hiệu quả
import java.io.IOException; // Xử lý lỗi khi làm việc với input/output (như đọc/ghi dữ liệu)

// Đánh dấu đây là một servlet với URL "/services/toggle"
// Khi người dùng gửi yêu cầu tới URL này (ví dụ: http://localhost:8080/services/toggle), servlet sẽ được gọi
@WebServlet("/services/toggle")
public class ServiceToggleServlet extends HttpServlet {

    // Biến instance để lưu đối tượng ServiceDAO, dùng để tương tác với cơ sở dữ liệu
    private ServiceDAO serviceDAO;

    // Phương thức init được gọi khi servlet được khởi tạo (chỉ một lần khi server khởi động)
    @Override
    public void init() throws ServletException {
        // Tạo một đối tượng ServiceDAO mới và gán vào biến serviceDAO
        serviceDAO = new ServiceDAO(); // Khởi tạo ServiceDAO
    }

    // Phương thức xử lý yêu cầu POST (khi người dùng gửi dữ liệu qua AJAX hoặc form)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        try {
            BufferedReader reader = request.getReader();
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }

            String jsonString = jsonBuilder.toString();
            if (jsonString.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Empty request body\"}");
                return;
            }

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
                // Cải thiện bằng cách trả lỗi nếu ID không hợp lệ
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid ID\"}");
                return;
            }

            boolean success = serviceDAO.toggleServiceStatus(id);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                // ✅ Thêm key "success": true
                response.getWriter().write("{\"success\": true, \"message\": \"Update Status Success\"}");
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
// update serviceToggleServlet
