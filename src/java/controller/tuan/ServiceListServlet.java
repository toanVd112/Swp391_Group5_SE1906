package controller.tuan;

import DAO.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Service;

@WebServlet(name="ServiceListServlet", urlPatterns={"/serviceslist"})
public class ServiceListServlet extends HttpServlet {
   
    private static final int RECORDS_PER_PAGE = 5; // Số bản ghi mỗi trang

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        if (account == null || !"Manager".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String searchKeyword = request.getParameter("searchKeyword");
        String filterType = request.getParameter("filterType");
        String filterStatus = request.getParameter("filterStatus");
        String sortBy = request.getParameter("sortBy");
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+")) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        
        // Tính tổng số bản ghi để xác định số trang
        int totalRecords = serviceDAO.countFilteredServices(searchKeyword, filterType, filterStatus);
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        // Sửa đổi: Thêm RECORDS_PER_PAGE vào lời gọi getFilteredServices
        List<Service> services = serviceDAO.getFilteredServices(searchKeyword, filterType, filterStatus, sortBy, page, RECORDS_PER_PAGE);
        List<String> types = serviceDAO.getAllDistinctServiceType();
        
        request.setAttribute("serviceList", services);
        request.setAttribute("serviceTypeList", types);
        request.setAttribute("currentSearchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("currentFilterType", filterType != null ? filterType : "");
        request.setAttribute("currentFilterStatus", filterStatus != null ? filterStatus : "");
        request.setAttribute("currentSortBy", sortBy != null ? sortBy : "");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        String a = request.getParameter("msg");
        request.setAttribute("msg", a);

        request.getRequestDispatcher("Manager/manager.jsp?page=ServiceList.jsp").forward(request, response);
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
        return "Servlet để liệt kê và lọc danh sách dịch vụ với phân trang";
    }
}