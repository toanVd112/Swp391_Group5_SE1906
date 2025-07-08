package controller.tuan;

import DAO.RevenueDAO;
import model.Account;
import model.RevenueStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "RevenueStatsServlet", urlPatterns = {"/revenuestats"})
public class RevenueStatsServlet extends HttpServlet {

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

        // Get filter parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String groupBy = request.getParameter("groupBy");

        // Default filters if not provided
        if (startDate == null || endDate == null) {
            LocalDate now = LocalDate.now();
            startDate = now.minusMonths(1).toString();
            endDate = now.toString();
            groupBy = "month";
        }
        if (groupBy == null) {
            groupBy = "month";
        }

        RevenueDAO revenueDAO = new RevenueDAO();
        List<RevenueStats> roomRevenue = revenueDAO.getRoomRevenueByType(startDate, endDate, groupBy);
        List<RevenueStats> serviceRevenue = revenueDAO.getServiceRevenueByType(startDate, endDate, groupBy);

        request.setAttribute("roomRevenue", roomRevenue);
        request.setAttribute("serviceRevenue", serviceRevenue);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("groupBy", groupBy);

        request.getRequestDispatcher("/Manager/RevenueStats.jsp").forward(request, response);
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
        return "Servlet to display revenue statistics with date range and grouping";
    }
}