//package controller.tuan;
//
//import dao.ActivityLogDAO;
//import model.ActivityLog;
//import DAO.DBConnect;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.sql.Connection;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.List;
//import java.util.UUID;
//
//@WebServlet(name = "ActivityLogServlet", urlPatterns = {"/ActivityLogServlet"})
//public class ActivityLogServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("manager")) {
//            response.sendError(403, "Access Denied: Only managers are allowed to view activity logs.");
//            return;
//        }
//
//        String csrfToken = (String) session.getAttribute("csrfToken");
//        if (csrfToken == null) {
//            csrfToken = UUID.randomUUID().toString();
//            session.setAttribute("csrfToken", csrfToken);
//        }
//
//        int page = 1;
//        int pageSize = 5;
//        String username = request.getParameter("username");
//        String actionType = request.getParameter("actionType");
//        String startDateStr = request.getParameter("startDate");
//        String endDateStr = request.getParameter("endDate");
//        String sortBy = request.getParameter("sortBy");
//        String sortOrder = request.getParameter("sortOrder");
//
//        if (request.getParameter("page") != null) {
//            try {
//                page = Integer.parseInt(request.getParameter("page"));
//            } catch (NumberFormatException ignored) {}
//        }
//
//        Date startDate = null, endDate = null;
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//        try {
//            if (startDateStr != null && !startDateStr.isEmpty()) {
//                startDate = sdf.parse(startDateStr);
//            }
//            if (endDateStr != null && !endDateStr.isEmpty()) {
//                endDate = sdf.parse(endDateStr);
//                endDate = new Date(endDate.getTime() + 24 * 60 * 60 * 1000 - 1);
//            }
//        } catch (Exception e) {
//            request.setAttribute("errorMessage", "Invalid date format.");
//        }
//
//        try (Connection conn = DBConnect.getConnection()) {
//            ActivityLogDAO logDAO = new ActivityLogDAO(conn);
//            List<ActivityLog> logs = logDAO.getLogs(username, actionType, startDate, endDate, sortBy, sortOrder, page, pageSize);
//            int totalLogs = logDAO.countLogs(username, actionType, startDate, endDate);
//            int totalPages = (int) Math.ceil((double) totalLogs / pageSize);
//
//            request.setAttribute("logs", logs);
//            request.setAttribute("currentPage", page);
//            request.setAttribute("totalPages", totalPages);
//            request.getRequestDispatcher("/Manager/activityLogs.jsp").forward(request, response);
//        } catch (Exception e) {
//            request.setAttribute("errorMessage", "Error loading activity logs: " + e.getMessage());
//            request.getRequestDispatcher("/Manager/activityLogs.jsp").forward(request, response);
//        }
//    }
//}