package controller.tuan;

import DAO.DiscountCodeDAO;
import model.Account;
import model.DiscountCode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DiscountCodeListServlet", urlPatterns = {"/discountcodes/list"})
public class DiscountCodeListServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 5;

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

        // Get and validate filter parameters
        String searchKeyword = request.getParameter("searchKeyword");
        if (searchKeyword != null && searchKeyword.trim().length() > 50) {
            request.setAttribute("msg", "Search keyword must not exceed 50 characters.");
            searchKeyword = "";
        } else if (searchKeyword != null) {
            searchKeyword = searchKeyword.trim();
        }

        String filterType = request.getParameter("filterType");
        if (filterType != null && !filterType.isEmpty() && !filterType.matches("1|2")) {
            request.setAttribute("msg", "Invalid discount type.");
            filterType = "";
        }

        String filterStatus = request.getParameter("filterStatus");
        if (filterStatus != null && !filterStatus.isEmpty() && !filterStatus.matches("Active|Inactive")) {
            request.setAttribute("msg", "Invalid status.");
            filterStatus = "";
        }

        // Get page parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+")) {
            page = Integer.parseInt(pageParam);
            if (page < 1) page = 1;
        }

        DiscountCodeDAO discountCodeDAO = new DiscountCodeDAO();
        List<DiscountCode> discountCodes = discountCodeDAO.getFilteredDiscountCodes(
            searchKeyword, filterType, filterStatus, page, RECORDS_PER_PAGE
        );
        int totalRecords = discountCodeDAO.getTotalDiscountCodes(searchKeyword, filterType, filterStatus);
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        request.setAttribute("discountCodeList", discountCodes);
        request.setAttribute("discountTypeList", discountCodeDAO.getAllDistinctDiscountTypes());
        request.setAttribute("currentSearchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("currentFilterType", filterType != null ? filterType : "");
        request.setAttribute("currentFilterStatus", filterStatus != null ? filterStatus : "");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }

        request.getRequestDispatcher("/Manager/manager.jsp?page=DiscountCodeList.jsp").forward(request, response);
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
        return "Servlet to list and filter discount codes";
    }
}