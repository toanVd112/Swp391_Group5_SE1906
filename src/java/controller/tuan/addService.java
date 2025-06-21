// Gói (package) chứa class này, giúp tổ chức code theo thư mục controller.tuan
package controller.tuan;

// Các thư viện (import) cần thiết để class hoạt động
import DAO.ServiceDAO; // Lớp ServiceDAO để tương tác với cơ sở dữ liệu (thêm dịch vụ mới)
import jakarta.servlet.ServletException; // Xử lý lỗi liên quan đến servlet
import jakarta.servlet.annotation.WebServlet; // Đánh dấu đây là một servlet và định nghĩa URL
import jakarta.servlet.http.HttpServlet; // Lớp cha của servlet, cung cấp các chức năng cơ bản
import jakarta.servlet.http.HttpServletRequest; // Đại diện cho yêu cầu từ trình duyệt (như dữ liệu form)
import jakarta.servlet.http.HttpServletResponse; // Đại diện cho phản hồi gửi về trình duyệt
import jakarta.servlet.http.HttpSession; // Quản lý phiên (session) để lưu thông tin người dùng
import model.Account; // Lớp Account đại diện cho tài khoản người dùng
import model.Service; // Lớp Service đại diện cho dịch vụ (như tên, giá, trạng thái)
import java.io.IOException; // Xử lý lỗi khi làm việc với input/output (như đọc/ghi dữ liệu)
import java.time.LocalDateTime; // Lớp để lấy thời gian hiện tại (dùng cho createDate, lastUpdateDate)

// Đánh dấu đây là một servlet với tên "AddServiceServlet" và URL "/addService"
// Khi người dùng truy cập URL này (ví dụ: http://localhost:8080/addService), servlet sẽ được gọi
@WebServlet(name = "AddServiceServlet", urlPatterns = {"/addService"})
public class addService extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET
     * Mục đích: Hiển thị form thêm dịch vụ mới (addService.jsp)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy phiên (session) hiện tại, false nghĩa là không tạo session mới nếu chưa có
        HttpSession session = request.getSession(false);
        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (session == null || session.getAttribute("account") == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return; // Dừng xử lý tiếp
        }
        // Lấy thông tin tài khoản từ session
        Account account = (Account) session.getAttribute("account");
        // Kiểm tra xem người dùng có vai trò "Manager" không
        if (!"Manager".equals(account.getRole())) {
            // Nếu không phải Manager, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return; // Dừng xử lý tiếp
        }

        // Chuyển tiếp (forward) yêu cầu tới file addService.jsp để hiển thị form thêm dịch vụ
        // Đường dẫn "../Manager/addService.jsp" giả sử JSP nằm trong thư mục Manager
        request.getRequestDispatcher("Manager/manager.jsp?page=addService.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu HTTP POST
     * Mục đích: Lấy dữ liệu từ form, validate, và lưu dịch vụ mới vào cơ sở dữ liệu
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đặt mã hóa UTF-8 để hỗ trợ tiếng Việt trong dữ liệu form
        request.setCharacterEncoding("UTF-8");
        // Đặt kiểu nội dung trả về là HTML với mã hóa UTF-8
        response.setContentType("text/html;charset=UTF-8");

        // Lấy phiên (session) hiện tại
        HttpSession session = request.getSession(false);
        Account currentAccount = null;
        if (session != null) {
            // Lấy thông tin tài khoản từ session
            currentAccount = (Account) session.getAttribute("account");
        }

        // Kiểm tra đăng nhập và quyền Manager
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            // Nếu chưa đăng nhập hoặc không phải Manager, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return; // Dừng xử lý tiếp
        }
        // Lấy tên người dùng từ tài khoản (giả sử Account có phương thức getUsername)
        String loggedInUser = currentAccount.getUsername();

        // Lấy dữ liệu từ form (các trường trong addService.jsp)
        String name = request.getParameter("name"); // Tên dịch vụ
        String description = request.getParameter("description"); // Mô tả dịch vụ
        String priceStr = request.getParameter("price"); // Giá (dạng chuỗi)
        String status = request.getParameter("status"); // Trạng thái (ví dụ: "1" hoặc "0")
        String serviceType = request.getParameter("serviceType"); // Loại dịch vụ
        String serviceImage = request.getParameter("serviceImage"); // URL hình ảnh

        // Đường dẫn tới JSP để quay lại nếu có lỗi
        String jspPath = "../manager/addService.jsp";

        // Validate dữ liệu đầu vào cơ bản
        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
            // Nếu tên hoặc giá rỗng, đặt thông báo lỗi
            request.setAttribute("errorMessage", "Tên dịch vụ và giá là bắt buộc.");
            // Chuyển tiếp về form để người dùng nhập lại
            request.getRequestDispatcher(jspPath).forward(request, response);
            return; // Dừng xử lý tiếp
        }

        int price;
        try {
            // Chuyển giá từ chuỗi sang số (lưu ý: form có thể gửi số thập phân)
            // Hiện tại ép kiểu sang int, làm tròn xuống nếu có phần thập phân
            price = (int) Double.parseDouble(priceStr);
            // Kiểm tra giá âm
            if (price < 0) {
                request.setAttribute("errorMessage", "Giá không được là số âm.");
                request.getRequestDispatcher(jspPath).forward(request, response);
                return; // Dừng xử lý tiếp
            }
        } catch (NumberFormatException e) {
            // Nếu giá không phải số hợp lệ, đặt thông báo lỗi
            request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số.");
            request.getRequestDispatcher(jspPath).forward(request, response);
            return; // Dừng xử lý tiếp
        }

        // Tạo đối tượng Service để lưu thông tin dịch vụ mới
        Service newService = new Service();
        newService.setName(name);
        newService.setDescription(description);
        newService.setPrice(price);
        newService.setStatus(status);
        newService.setType(serviceType);
        newService.setServiceImage(serviceImage);
        newService.setCreateDate(LocalDateTime.now()); // Lưu thời gian tạo
        newService.setLastUpdateDate(LocalDateTime.now()); // Lưu thời gian cập nhật
        newService.setCreatedBy(loggedInUser); // Lưu người tạo
        newService.setLastUpdateBy(loggedInUser); // Lưu người cập nhật

        // Tạo đối tượng ServiceDAO để tương tác với cơ sở dữ liệu
        ServiceDAO serviceDAO = new ServiceDAO();
        boolean success = false;
        try {
            // Gọi phương thức addService để lưu dịch vụ mới
            success = serviceDAO.addService(newService);
        } catch (Exception e) {
            // Nếu có lỗi (như lỗi cơ sở dữ liệu), in lỗi ra console
            e.printStackTrace();
            // Đặt thông báo lỗi cho người dùng
            request.setAttribute("errorMessage", "Lỗi hệ thống khi thêm dịch vụ: " + e.getMessage());
            request.getRequestDispatcher(jspPath).forward(request, response);
            return; // Dừng xử lý tiếp
        }

        // Kiểm tra kết quả thêm dịch vụ
        if (success) {
            // Nếu thành công, chuyển hướng về trang danh sách dịch vụ với thông báo
            response.sendRedirect(request.getContextPath() + "/serviceslist?addStatus=success");
        } else {
            // Nếu thất bại, đặt thông báo lỗi và quay lại form
            request.setAttribute("errorMessage", "Thêm dịch vụ mới thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    /**
     * Mô tả ngắn gọn về servlet
     */
    @Override
    public String getServletInfo() {
        return "Servlet để thêm dịch vụ mới";
    }
}