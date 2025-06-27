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

        RevenueDAO revenueDAO = new RevenueDAO();
        List<RevenueStats> roomRevenue = revenueDAO.getRoomRevenueByType();
        List<RevenueStats> serviceRevenue = revenueDAO.getServiceRevenueByType();

        request.setAttribute("roomRevenue", roomRevenue);
        request.setAttribute("serviceRevenue", serviceRevenue);

        request.getRequestDispatcher("/Manager/manager.jsp?page=RevenueStats.jsp").forward(request, response);
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
        return "Servlet to display revenue statistics";
    }
}