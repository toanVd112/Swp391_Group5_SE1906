// Gói (package) chứa class này, giúp tổ chức code theo thư mục controller.tuan
package controller.tuan;

// Các thư viện (import) cần thiết để class hoạt động
import DAO.ServiceDAO; // Lớp ServiceDAO để tương tác với cơ sở dữ liệu (lấy và cập nhật dịch vụ)
import jakarta.servlet.ServletException; // Xử lý lỗi liên quan đến servlet
import jakarta.servlet.annotation.WebServlet; // Đánh dấu đây là một servlet và định nghĩa URL
import jakarta.servlet.http.HttpServlet; // Lớp cha của servlet, cung cấp các chức năng cơ bản
import jakarta.servlet.http.HttpServletRequest; // Đại diện cho yêu cầu từ trình duyệt (như dữ liệu form)
import jakarta.servlet.http.HttpServletResponse; // Đại diện cho phản hồi gửi về trình duyệt
import jakarta.servlet.http.HttpSession; // Quản lý phiên (session) để lưu thông tin người dùng
import model.Account; // Lớp Account đại diện cho tài khoản người dùng
import model.Service; // Lớp Service đại diện cho dịch vụ (như tên, giá, trạng thái)
import java.io.IOException; // Xử lý lỗi khi làm việc với input/output (như đọc/ghi dữ liệu)
import java.time.LocalDateTime; // Lớp để lấy thời gian hiện tại (dùng cho lastUpdateDate)
import java.util.List; // Lớp List để lưu danh sách (như danh sách loại dịch vụ)

// Đánh dấu đây là một servlet với tên "editService" và URL "/editService"
// Khi người dùng truy cập URL này (ví dụ: http://localhost:8080/editService), servlet sẽ được gọi
@WebServlet(name = "editService", urlPatterns = {"/editService"})
public class editService extends HttpServlet {

    // Xử lý yêu cầu HTTP GET
    // Mục đích: Hiển thị form chỉnh sửa dịch vụ (editService.jsp) với dữ liệu dịch vụ hiện có
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đặt mã hóa UTF-8 để hỗ trợ tiếng Việt trong dữ liệu gửi và nhận
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy phiên (session) hiện tại, false nghĩa là không tạo session mới nếu chưa có
        HttpSession session = request.getSession(false);
        // Lấy thông tin tài khoản từ session (nếu có), lưu vào biến currentAccount
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;

        // Kiểm tra xem người dùng có đăng nhập và có vai trò "Manager" không
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            // Nếu chưa đăng nhập hoặc không phải Manager, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return; // Dừng xử lý tiếp
        }

        // Định nghĩa đường dẫn tới file JSP để hiển thị form chỉnh sửa
        // Lưu ý: Đường dẫn dùng request.getContextPath() có thể gây lỗi nếu JSP không ở vị trí đúng
        String jspPath = request.getContextPath() + "/Manager/editService.jsp";
        // Tạo đối tượng ServiceDAO để tương tác với cơ sở dữ liệu
        ServiceDAO serviceDAO = new ServiceDAO();

        try {
            // Lấy tham số "id" từ URL (ví dụ: /editService?id=123)
            String idParam = request.getParameter("id");
            // Kiểm tra xem id có được gửi không
            if (idParam == null || idParam.trim().isEmpty()) {
                // Nếu id rỗng, đặt thông báo lỗi
                request.setAttribute("errorMessage", "ID dịch vụ không được cung cấp.");
                // Chuyển hướng về trang danh sách dịch vụ
                response.sendRedirect(request.getContextPath() + "/services/list");
                return; // Dừng xử lý tiếp
            }
            // Chuyển id từ chuỗi sang số nguyên
            int id = Integer.parseInt(idParam);
            // Lấy thông tin dịch vụ từ cơ sở dữ liệu dựa trên id
            Service service = serviceDAO.getServiceByID(id);
            // Lấy danh sách tất cả loại dịch vụ để hiển thị trong dropdown trên form
            List<String> serviceTypes = serviceDAO.getAllDistinctServiceType();

            // Kiểm tra xem dịch vụ có tồn tại không
            if (service != null) {
                // Nếu dịch vụ tồn tại, lưu thông tin dịch vụ và danh sách loại dịch vụ vào request
                request.setAttribute("service", service);
                request.setAttribute("serviceTypes", serviceTypes);
                // Chuyển tiếp (forward) tới editService.jsp để hiển thị form
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else {
                // Nếu không tìm thấy dịch vụ, đặt thông báo lỗi
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ với ID: " + id);
                // Chuyển hướng về trang danh sách dịch vụ
                response.sendRedirect(request.getContextPath() + "/services/list");
            }
        } catch (NumberFormatException e) {
            // Nếu id không phải số hợp lệ, đặt thông báo lỗi
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ.");
            // Chuyển hướng về danh sách dịch vụ với thông báo lỗi
            response.sendRedirect(request.getContextPath() + "/services?action=list&error=invalidIdFormat");
        } catch (Exception e) {
            // Nếu có lỗi hệ thống (như lỗi cơ sở dữ liệu), in lỗi ra console
            e.printStackTrace();
            // Đặt thông báo lỗi cho người dùng
            request.setAttribute("errorMessage", "Lỗi hệ thống khi tải dữ liệu dịch vụ: " + e.getMessage());
            try {
                // Cố gắng forward về form chỉnh sửa với thông báo lỗi
                this.log("omm"); // Ghi log (có thể là lỗi đánh máy, nên thay bằng thông báo rõ ràng)
                request.getRequestDispatcher(jspPath).forward(request, response);
            } catch (Exception ex) {
                // Nếu forward thất bại, chuyển hướng về danh sách dịch vụ với thông báo lỗi
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=systemError");
            }
        }
    }

    // Xử lý yêu cầu HTTP POST
    // Mục đích: Cập nhật thông tin dịch vụ dựa trên dữ liệu từ form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bước 1: Thiết lập mã hóa ký tự để hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Bước 2: Kiểm tra phiên đăng nhập và quyền Manager
        HttpSession session = request.getSession(false);
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            // Nếu không đăng nhập hoặc không phải Manager, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return;
        }

        // Bước 3: Khởi tạo các biến cần thiết
        String jspPath = request.getContextPath() + "/Manager/editService.jsp"; // Đường dẫn tới JSP để forward khi cần
        ServiceDAO serviceDAO = new ServiceDAO(); // Đối tượng DAO để tương tác với cơ sở dữ liệu
        int serviceId = -1; // Biến lưu ID dịch vụ, mặc định -1 để xử lý trường hợp lỗi

        try {
            // Bước 4: Lấy và kiểm tra ID dịch vụ từ form
            String idParam = request.getParameter("id"); // Lấy ID từ trường hidden trong form
            if (idParam == null || idParam.trim().isEmpty()) {
                // Nếu ID không được gửi, đặt thông báo lỗi và chuyển hướng về danh sách dịch vụ
                request.setAttribute("errorMessage", "ID dịch vụ không được gửi trong form.");
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=missingFormId");
                return;
            }
            serviceId = Integer.parseInt(idParam); // Chuyển ID thành số nguyên

            // Bước 5: Lấy các tham số khác từ form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String status = request.getParameter("status"); // "1" (active) hoặc "0" (inactive)
            String serviceType = request.getParameter("serviceType");
            String serviceImage = request.getParameter("serviceImage");

            // Bước 6: Validate dữ liệu đầu vào
            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || serviceType == null || serviceType.trim().isEmpty()) {
                // Nếu các trường bắt buộc bị thiếu, đặt thông báo lỗi
                request.setAttribute("errorMessage", "Tên dịch vụ, giá Sex and price are required.");
                // Tải lại dữ liệu dịch vụ từ DB để hiển thị trên form
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit); // Gửi dữ liệu dịch vụ
                request.setAttribute("serviceTypes", allServiceTypes); // Gửi danh sách loại dịch vụ
                request.getRequestDispatcher(jspPath).forward(request, response); // Forward về form chỉnh sửa
                return;
            }

            // Bước 7: Validate và chuyển đổi giá thành số nguyên
            int price;
            try {
                price = Integer.parseInt(priceStr); // Chuyển giá từ chuỗi sang số nguyên
                if (price < 0) {
                    // Nếu giá âm, đặt thông báo lỗi
                    request.setAttribute("errorMessage", "Giá không được là số âm.");
                    Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                    List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                    request.setAttribute("service", serviceToEdit);
                    request.setAttribute("serviceTypes", allServiceTypes);
                    request.getRequestDispatcher(jspPath).forward(request, response); // Forward về form
                    return;
                }
            } catch (NumberFormatException e) {
                // Nếu giá không phải số hợp lệ, đặt thông báo lỗi
                request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số nguyên.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response); // Forward về form
                return;
            }

            // Bước 8: Tạo đối tượng Service với thông tin cập nhật
            Service serviceToUpdate = new Service();
            serviceToUpdate.setId(serviceId);
            serviceToUpdate.setName(name);
            serviceToUpdate.setDescription(description);
            serviceToUpdate.setPrice(price);
            serviceToUpdate.setStatus(status); // "1" hoặc "0"
            serviceToUpdate.setType(serviceType);
            serviceToUpdate.setServiceImage(serviceImage);
            serviceToUpdate.setLastUpdateDate(LocalDateTime.now()); // Cập nhật thời gian sửa đổi
            serviceToUpdate.setLastUpdateBy(currentAccount.getUsername()); // Ghi nhận người sửa

            // Bước 9: Lấy thông tin gốc để giữ nguyên ngày tạo và người tạo
            Service existingService = serviceDAO.getServiceByID(serviceId);
            if (existingService != null) {
                serviceToUpdate.setCreateDate(existingService.getCreateDate());
                serviceToUpdate.setCreatedBy(existingService.getCreatedBy());
            } else {
                // Nếu không tìm thấy dịch vụ gốc, đặt thông báo lỗi và chuyển hướng
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ gốc để cập nhật. Dịch vụ có thể đã bị xóa.");
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=originalNotFound");
                return;
            }

            // Bước 10: Thực hiện cập nhật dịch vụ trong cơ sở dữ liệu
            boolean success = serviceDAO.update(serviceToUpdate);

            // Bước 11: Xử lý kết quả cập nhật
            if (success) {
                // Nếu cập nhật thành công, chuyển hướng về danh sách dịch vụ với thông báo
                response.sendRedirect(request.getContextPath() + "/services/list?msg=Update+success");
            } else {
                // Nếu cập nhật thất bại, đặt thông báo lỗi
                request.setAttribute("errorMessage", "Cập nhật dịch vụ thất bại. Vui lòng thử lại.");
                // Gửi lại dữ liệu người dùng đã nhập để hiển thị trên form
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToUpdate); // Dữ liệu người dùng vừa nhập
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response); // Forward về form
            }

        } catch (NumberFormatException e) {
            // Bước 12: Xử lý lỗi khi ID không hợp lệ
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ trong form gửi đi.");
            response.sendRedirect(request.getContextPath() + "/services?action=list&error=invalidFormId");
        } catch (Exception e) {
            // Bước 13: Xử lý các lỗi hệ thống khác
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật dịch vụ: " + e.getMessage());
            // Nếu serviceId hợp lệ, tải lại dữ liệu từ DB để hiển thị trên form
            if (serviceId != -1) {
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
            }
            request.getRequestDispatcher(jspPath).forward(request, response); // Forward về form
        }
    }

    // Mô tả ngắn gọn về servlet
    @Override
    public String getServletInfo() {
        return "Servlet for editing an existing service.";
    }
}