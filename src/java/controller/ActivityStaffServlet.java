/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ActivityStaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ActivityLog;

@WebServlet(name = "ActivityStaff", urlPatterns = {"/activityStaff"})
public class ActivityStaffServlet extends HttpServlet {

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String actionType = request.getParameter("actionType");
        String targetTable = request.getParameter("targetTable");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String targetID = request.getParameter("targetID");

        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 5);
        int offset = (page - 1) * pageSize;

        ActivityStaffDAO dao = new ActivityStaffDAO();

        int totalLogs = dao.countFilteredLogs(username, actionType, targetTable, from, to, targetID);
        int totalPages = (int) Math.ceil((double) totalLogs / pageSize);

        List<ActivityLog> logs = dao.getFilteredLogsPaginated(username, actionType, targetTable, from, to, targetID, offset, pageSize);

        request.setAttribute("logList", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        // Giữ filter
        request.setAttribute("param.username", username);
        request.setAttribute("param.actionType", actionType);
        request.setAttribute("param.targetTable", targetTable);
        request.setAttribute("param.from", from);
        request.setAttribute("param.to", to);
        request.setAttribute("param.targetID", targetID);

        request.getRequestDispatcher("Manager/ActivityStaff.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return def;
        }
    }

}
