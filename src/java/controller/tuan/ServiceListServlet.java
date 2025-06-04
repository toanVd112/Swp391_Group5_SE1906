package controller.tuan;

import DAO.ServiceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account; // Đảm bảo import đúng model Account
import model.Service; // Đảm bảo import đúng model Service

@WebServlet(name="ServiceListServlet", urlPatterns={"/services/list"})
public class ServiceListServlet extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Quan trọng để xử lý tiếng Việt khi tìm kiếm

        HttpSession session = request.getSession(false);
        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        // Kiểm tra quyền truy cập
        if (account == null || !"Manager".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy các tham số lọc từ request
        String searchKeyword = request.getParameter("searchKeyword");
        String filterType = request.getParameter("filterType");
        String filterStatus = request.getParameter("filterStatus");
        // String sortBy = request.getParameter("sortBy"); // Có thể thêm sau cho chức năng sắp xếp
        // int page = 1; // Mặc định trang 1, có thể thêm sau cho phân trang
        // String pageParam = request.getParameter("page");
        // if (pageParam != null && pageParam.matches("\\d+")) {
        //     page = Integer.parseInt(pageParam);
        // }


        ServiceDAO serviceDAO = new ServiceDAO();
        
        // Gọi phương thức DAO mới với các tham số lọc
        // Hiện tại sortBy và page chưa được triển khai đầy đủ ở JSP, truyền null và 0
        List<Service> services = serviceDAO.getFilteredServices(searchKeyword, filterType, filterStatus, null, 0);
        List<String> types = serviceDAO.getAllDistinctServiceType(); // Để hiển thị trong dropdown loại dịch vụ
        
        request.setAttribute("serviceList", services);
        request.setAttribute("serviceTypeList", types);
        
        // Đặt lại các giá trị lọc vào request để JSP có thể hiển thị lại ("sticky filters")
        request.setAttribute("currentSearchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("currentFilterType", filterType != null ? filterType : "");
        request.setAttribute("currentFilterStatus", filterStatus != null ? filterStatus : "");
        // request.setAttribute("currentSortBy", sortBy);
        // request.setAttribute("currentPage", page);
        // request.setAttribute("totalPages", totalPages); // Nếu có phân trang

        request.getRequestDispatcher("/Manager/ServiceList.jsp").forward(request, response);
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Thông thường, việc tìm kiếm/lọc sử dụng GET để URL có thể được bookmark.
        // Nếu bạn cũng muốn POST thực hiện lọc, hãy gọi processRequest.
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet để liệt kê và lọc danh sách dịch vụ";
    }
}