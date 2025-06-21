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
//import java.io.PrintWriter;
//import java.sql.Connection;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.List;
//
//@WebServlet(name = "ExportLogsServlet", urlPatterns = {"/ExportLogsServlet"})
//public class ExportLogsServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("manager")) {
//            response.sendError(403, "Access Denied: Only managers are allowed to export logs.");
//            return;
//        }
//
//        String username = request.getParameter("username");
//        String actionType = request.getParameter("actionType");
//        String startDateStr = request.getParameter("startDate");
//        String endDateStr = request.getParameter("endDate");
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
//            response.sendError(400, "Invalid date format.");
//            return;
//        }
//
//        try (Connection conn = DBConnect.getConnection()) {
//            ActivityLogDAO logDAO = new ActivityLogDAO(conn);
//            List<ActivityLog> logs = logDAO.getLogs(username, actionType, startDate, endDate, "actionTime", "DESC", 1, Integer.MAX_VALUE);
//
//            response.setContentType("text/csv");
//            response.setHeader("Content-Disposition", "attachment; filename=\"activity_logs.csv\"");
//            PrintWriter writer = response.getWriter();
//            writer.println("Log ID,Date,Username,Role,Action Type,Target Table,Target ID,Description,IP Address");
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            for (ActivityLog log : logs) {
//                writer.println(String.format("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\"",
//                    log.getLogId(),
//                    dateFormat.format(log.getActionTime()),
//                    escapeCsv(log.getUsername()),
//                    escapeCsv(log.getRole()),
//                    escapeCsv(log.getActionType()),
//                    escapeCsv(log.getTargetTable()),
//                    log.getTargetId(),
//                    escapeCsv(log.getDescription()),
//                    escapeCsv(log.getIpAddress())
//                ));
//            }
//            writer.flush();
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(500, "Error exporting logs: " + e.getMessage());
//        }
//    }
//
//    private String escapeCsv(String value) {
//        if (value == null) return "";
//        return value.replace("\"", "\"\"");
//    }
//}