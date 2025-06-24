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

        DiscountCodeDAO discountCodeDAO = new DiscountCodeDAO();
        List<DiscountCode> discountCodes = discountCodeDAO.getFilteredDiscountCodes(searchKeyword, filterType, filterStatus);
        List<String> types = discountCodeDAO.getAllDistinctDiscountTypes();

        request.setAttribute("discountCodeList", discountCodes);
        request.setAttribute("discountTypeList", types);
        request.setAttribute("currentSearchKeyword", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("currentFilterType", filterType != null ? filterType : "");
        request.setAttribute("currentFilterStatus", filterStatus != null ? filterStatus : "");

        String msg = request.getParameter("msg");
        request.setAttribute("msg", msg);

        request.getRequestDispatcher("/Manager/manager.jsp?page=DiscountCodeList.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {        processRequest(request, response);
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