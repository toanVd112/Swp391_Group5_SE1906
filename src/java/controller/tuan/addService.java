package controller.tuan;

import DAO.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account; // Cần import model.Account
import model.Service; // Cần import model.Service

import java.io.IOException;
import java.time.LocalDateTime;

// Đổi tên class và WebServlet name để tránh trùng với tên package và rõ ràng hơn
@WebServlet(name = "AddServiceServlet", urlPatterns = {"/addService"})
public class addService extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Chuyển hướng đến trang JSP để hiển thị form thêm dịch vụ.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Kiểm tra quyền truy cập của người dùng
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login_2.jsp"); // Chuyển đến trang đăng nhập
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (!"Manager".equals(account.getRole())) {
            // Nếu không phải Manager, có thể chuyển hướng về trang chủ hoặc trang lỗi quyền
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return;
        }

        // Đường dẫn đến addService.jsp (giả sử nằm trong /manager/addService.jsp)
        // Nếu JSP nằm ở thư mục gốc webapp, dùng "/addService.jsp"
        request.getRequestDispatcher("../Manager/addService.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Xử lý dữ liệu từ form thêm dịch vụ và lưu vào cơ sở dữ liệu.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo xử lý đúng tiếng Việt
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Account currentAccount = null;
        if (session != null) {
            currentAccount = (Account) session.getAttribute("account");
        }

        // Kiểm tra đăng nhập và quyền
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return;
        }
        // Giả sử Account model có getUsername() hoặc một phương thức tương tự để lấy tên người dùng
        String loggedInUser = currentAccount.getUsername();

        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");
        String serviceType = request.getParameter("serviceType");
        String serviceImage = request.getParameter("serviceImage");

        String jspPath = "../manager/addService.jsp"; // Đường dẫn tới JSP để forward lại nếu có lỗi

        // Validate đầu vào cơ bản
        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên dịch vụ và giá là bắt buộc.");
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        int price;
        try {
            // JSP có step="0.01", nhưng DAO và model Service dùng int cho price.
            // Nếu price có thể là số thập phân, cần sửa model và DAO (dùng BigDecimal).
            // Hiện tại, chuyển đổi sang int (làm tròn xuống nếu có phần thập phân).
            price = (int) Double.parseDouble(priceStr);
            if (price < 0) {
                 request.setAttribute("errorMessage", "Giá không được là số âm.");
                 request.getRequestDispatcher(jspPath).forward(request, response);
                 return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số.");
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        // Tạo đối tượng Service
        Service newService = new Service();
        newService.setName(name);
        newService.setDescription(description);
        newService.setPrice(price);
        newService.setStatus(status);
        newService.setType(serviceType);
        newService.setServiceImage(serviceImage); // URL hình ảnh
        newService.setCreateDate(LocalDateTime.now());
        newService.setLastUpdateDate(LocalDateTime.now());
        newService.setCreatedBy(loggedInUser);
        newService.setLastUpdateBy(loggedInUser);

        ServiceDAO serviceDAO = new ServiceDAO();
        boolean success = false;
        try {
            success = serviceDAO.addService(newService);
        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi server
            request.setAttribute("errorMessage", "Lỗi hệ thống khi thêm dịch vụ: " + e.getMessage());
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (success) {
            // Chuyển hướng đến trang danh sách dịch vụ với thông báo thành công
            // Giả sử URL của trang danh sách là "/services/list" (theo link trong JSP)
            response.sendRedirect(request.getContextPath() + "/services/list?addStatus=success");
        } else {
            request.setAttribute("errorMessage", "Thêm dịch vụ mới thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet để thêm dịch vụ mới";
    }
}