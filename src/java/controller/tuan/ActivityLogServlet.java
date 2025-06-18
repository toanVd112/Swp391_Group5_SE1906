package controller.tuan;

import DAO.DBConnect;
import dao.ActivityLogDAO;
import model.ActivityLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(name = "ActivityLogServlet", urlPatterns = {"/ActivityLogServlet"})
public class ActivityLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("manager")) {
            response.sendError(403, "Access Denied: Only managers are allowed to view activity logs.");
            return;
        }

        int page = 1;
        int pageSize = 5;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException ignored) {}
        }

        try (Connection conn = DBConnect.getConnection()) {
            ActivityLogDAO logDAO = new ActivityLogDAO(conn);
            List<ActivityLog> logs = logDAO.getAllLogs(page, pageSize);
            int totalLogs = logDAO.countAllLogs();
            int totalPages = (int) Math.ceil((double) totalLogs / pageSize);

            request.setAttribute("logs", logs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("Manager/activityLogs.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error loading activity logs");
        }
    }
}