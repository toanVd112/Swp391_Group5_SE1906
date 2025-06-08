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
        // Đặt kiểu nội dung trả về là JSON (thay vì HTML), để giao tiếp với frontend (như JavaScript)
        response.setContentType("application/json");
        
        // Bắt đầu khối try-catch để xử lý các lỗi có thể xảy ra
        try {
            // Tạo BufferedReader để đọc dữ liệu từ body của yêu cầu (nơi chứa JSON)
            BufferedReader reader = request.getReader();
            // Tạo StringBuilder để xây dựng chuỗi JSON từ các dòng đọc được
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            // Đọc từng dòng từ body của yêu cầu
            while ((line = reader.readLine()) != null) {
                // Thêm dòng vào StringBuilder
                jsonBuilder.append(line);
            }

            // Lấy chuỗi JSON từ StringBuilder
            String jsonString = jsonBuilder.toString();
            // Kiểm tra xem JSON có rỗng không
            if (jsonString.isEmpty()) {
                // Nếu rỗng, trả về mã lỗi 400 (Bad Request)
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                // Gửi phản hồi JSON với thông báo lỗi
                response.getWriter().write("{\"error\": \"Empty request body\"}");
                return; // Dừng xử lý tiếp
            }

            // Parse chuỗi JSON thành một đối tượng JsonObject để dễ truy cập các trường
            JsonObject jsonObject = new JsonParser().parse(jsonString).getAsJsonObject();
            // Kiểm tra xem JSON có trường "id" không
            if (!jsonObject.has("id")) {
                // Nếu thiếu trường "id", trả về mã lỗi 400
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                // Gửi phản hồi JSON với thông báo lỗi
                response.getWriter().write("{\"error\": \"Missing id field\"}");
                return; // Dừng xử lý tiếp
            }
            // Lấy giá trị của trường "id" từ JSON dưới dạng chuỗi
            String serviceId = jsonObject.get("id").getAsString();
            // Khởi tạo biến id với giá trị mặc định là 0
            int id = 0;
            // Thử chuyển đổi serviceId từ chuỗi sang số nguyên
            try {
                id = Integer.parseInt(serviceId);
            } catch (Exception e) {
                // Nếu chuyển đổi thất bại (ví dụ: id không phải số), id vẫn là 0
                // Lưu ý: Phần này không xử lý lỗi, cần cải thiện
            }

            // Gọi ServiceDAO để cập nhật trạng thái dịch vụ (toggle: ví dụ từ active sang inactive)
            boolean success = serviceDAO.toggleServiceStatus(id);

            // Kiểm tra kết quả cập nhật
            if (success) {
                // Nếu thành công, trả về mã trạng thái 200 (OK)
                response.setStatus(HttpServletResponse.SC_OK);
                // Gửi phản hồi JSON với thông báo thành công
                response.getWriter().write("{\"message\": \"Update Status Success\"}");
            } else {
                // Nếu thất bại, trả về mã lỗi 500 (Internal Server Error)
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                // Gửi phản hồi JSON với thông báo lỗi
                response.getWriter().write("{\"error\": \"Failed to update status\"}");
            }
        } catch (Exception e) {
            // Nếu có lỗi bất kỳ (như lỗi parse JSON hoặc lỗi hệ thống)
            // Trả về mã lỗi 500
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // Gửi phản hồi JSON với thông báo lỗi chi tiết
            response.getWriter().write("{\"error\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}