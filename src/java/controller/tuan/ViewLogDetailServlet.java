package controller.tuan;

import dao.ActivityLogDAO;
import model.ActivityLog;
import DAO.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "ViewLogDetailServlet", urlPatterns = {"/ViewLogDetailServlet"})
public class ViewLogDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("manager")) {
            response.sendError(403, "Access Denied: Only managers are allowed to view log details.");
            return;
        }

        String csrfToken = request.getParameter("csrfToken");
        if (csrfToken == null || !csrfToken.equals(session.getAttribute("csrfToken"))) {
            response.sendError(403, "Invalid CSRF token.");
            return;
        }

        String logIdStr = request.getParameter("id");
        int logId;
        try {
            logId = Integer.parseInt(logIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid log ID.");
            request.getRequestDispatcher("/Manager/logDetail.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnect.getConnection()) {
            ActivityLogDAO logDAO = new ActivityLogDAO(conn);
            ActivityLog log = logDAO.getLogById(logId);
            if (log == null) {
                request.setAttribute("errorMessage", "Log not found.");
            } else {
                request.setAttribute("log", log);
            }
            request.getRequestDispatcher("/Manager/logDetail.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading log details: " + e.getMessage());
            request.getRequestDispatcher("/Manager/logDetail.jsp").forward(request, response);
        }
    }
}