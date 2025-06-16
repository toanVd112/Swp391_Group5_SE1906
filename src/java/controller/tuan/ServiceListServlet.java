// Gói (package) chứa class này, giúp tổ chức code theo thư mục controller.tuan
package controller.tuan;

// Các thư viện (import) cần thiết để class hoạt động
import DAO.ServiceDAO; // Lớp ServiceDAO để tương tác với cơ sở dữ liệu (lấy danh sách dịch vụ)
import java.io.IOException; // Xử lý lỗi khi làm việc với input/output (như đọc/ghi file hoặc mạng)
import jakarta.servlet.ServletException; // Xử lý lỗi liên quan đến servlet
import jakarta.servlet.annotation.WebServlet; // Đánh dấu đây là một servlet và định nghĩa URL
import jakarta.servlet.http.HttpServlet; // Lớp cha của servlet, cung cấp các chức năng cơ bản
import jakarta.servlet.http.HttpServletRequest; // Đại diện cho yêu cầu từ trình duyệt (như dữ liệu form)
import jakarta.servlet.http.HttpServletResponse; // Đại diện cho phản hồi gửi về trình duyệt
import jakarta.servlet.http.HttpSession; // Quản lý phiên (session) để lưu thông tin người dùng
import java.util.List; // Lớp List để lưu danh sách (như danh sách dịch vụ)
import model.Account; // Lớp Account đại diện cho tài khoản người dùng
import model.Service; // Lớp Service đại diện cho dịch vụ (như tên, giá, trạng thái)

// Đánh dấu đây là một servlet với tên "ServiceListServlet" và URL "/services/list"
// Khi người dùng truy cập URL này (ví dụ: http://localhost:8080/services/list), servlet sẽ được gọi
@WebServlet(name="ServiceListServlet", urlPatterns={"/services/list"})
public class ServiceListServlet extends HttpServlet {
   
    // Phương thức chính xử lý cả GET và POST, nhận yêu cầu và trả về phản hồi
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Đặt kiểu nội dung trả về là HTML và mã hóa UTF-8 để hỗ trợ tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        // Đảm bảo dữ liệu gửi từ trình duyệt (như form) được đọc đúng với tiếng Việt
        request.setCharacterEncoding("UTF-8");
        // Đảm bảo dữ liệu gửi về trình duyệt cũng hiển thị tiếng Việt đúng
        response.setCharacterEncoding("UTF-8");
        
        // Lấy phiên (session) hiện tại của người dùng, false nghĩa là không tạo session mới nếu chưa có
        HttpSession session = request.getSession(false);
        // Lấy thông tin tài khoản từ session (nếu có), lưu vào biến account
        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        // Kiểm tra xem người dùng đã đăng nhập và có vai trò "Manager" chưa
        if (account == null || !"Manager".equals(account.getRole())) {
            // Nếu chưa đăng nhập hoặc không phải Manager, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return; // Dừng xử lý tiếp
        }

        // Lấy các tham số lọc từ yêu cầu (do người dùng nhập trên giao diện)
        // searchKeyword: Từ khóa tìm kiếm (ví dụ: tên dịch vụ)
        String searchKeyword = request.getParameter("searchKeyword");
        // filterType: Loại dịch vụ (ví dụ: "Spa", "Gym")
        String filterType = request.getParameter("filterType");
        // filterStatus: Trạng thái dịch vụ (ví dụ: "1" là active, "0" là inactive)
        String filterStatus = request.getParameter("filterStatus");

        // Các dòng bị comment này là để hỗ trợ sắp xếp và phân trang (chưa được dùng)
        // String sortBy = request.getParameter("sortBy"); // Sắp xếp theo cột nào
        // int page = 1; // Trang hiện tại, mặc định là trang 1
        // String pageParam = request.getParameter("page");
        // if (pageParam != null && pageParam.matches("\\d+")) {
        //     page = Integer.parseInt(pageParam); // Chuyển tham số page thành số
        // }

        // Tạo một đối tượng ServiceDAO để làm việc với cơ sở dữ liệu
        ServiceDAO serviceDAO = new ServiceDAO();
        
        // Lấy danh sách dịch vụ từ cơ sở dữ liệu dựa trên các bộ lọc
        // Truyền các tham số lọc, sortBy và page (hiện tại sortBy là null, page là 0 vì chưa dùng)
        List<Service> services = serviceDAO.getFilteredServices(searchKeyword, filterType, filterStatus, null, 0);
        // Lấy danh sách tất cả các loại dịch vụ (dùng để hiển thị trong dropdown trên giao diện)
        List<String> types = serviceDAO.getAllDistinctServiceType();
        
        // Lưu danh sách dịch vụ vào request để JSP có thể hiển thị
        request.setAttribute("serviceList", services);
        // Lưu danh sách loại dịch vụ vào request để JSP tạo dropdown
        request.setAttribute("serviceTypeList", types);
        
        // Lưu các giá trị lọc vào request để JSP hiển thị lại (gọi là "sticky filters")
        // Nếu người dùng nhập từ khóa, nó sẽ được giữ lại trên form
        request.setAttribute("currentSearchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("currentFilterType", filterType != null ? filterType : "");
        request.setAttribute("currentFilterStatus", filterStatus != null ? filterStatus : "");
        // Các dòng comment này dành cho sắp xếp và phân trang (chưa dùng)
        // request.setAttribute("currentSortBy", sortBy);
        // request.setAttribute("currentPage", page);
        // request.setAttribute("totalPages", totalPages);

        // Lấy thông báo (msg) từ tham số URL (ví dụ: ?msg=Update+success)
        String a = request.getParameter("msg");
        // Lưu thông báo vào request để JSP có thể hiển thị (như alert)
        request.setAttribute("msg", a);

        // Chuyển tiếp (forward) yêu cầu và phản hồi tới file JSP để hiển thị giao diện
        request.getRequestDispatcher("/Manager/ServiceList.jsp").forward(request, response);
    } 

    // Xử lý yêu cầu GET (khi người dùng truy cập URL hoặc nhấn nút tìm kiếm)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Gọi processRequest để xử lý logic chung
        processRequest(request, response);
    } 

    // Xử lý yêu cầu POST (nếu form tìm kiếm dùng method POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Gọi processRequest để xử lý logic chung
        // Lưu ý: Tìm kiếm thường dùng GET để URL có thể lưu lại, nhưng POST cũng được hỗ trợ
        processRequest(request, response);
    }

    // Mô tả ngắn gọn về servlet (dùng cho tài liệu hoặc công cụ quản lý)
    @Override
    public String getServletInfo() {
        return "Servlet để liệt kê và lọc danh sách dịch vụ";
    }
}

//check commit 