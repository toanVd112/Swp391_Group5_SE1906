/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ActivityLogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ActivityLog;

@WebServlet(name = "ActivityLogServlet", urlPatterns = {"/activityLogs"})
public class ActivityLogServlet extends HttpServlet {

    @Override
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy các tham số từ form lọc
        String username = request.getParameter("username");
        String actionType = request.getParameter("actionType");
        String targetTable = request.getParameter("targetTable");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String targetID = request.getParameter("targetID");

        ActivityLogDAO dao = new ActivityLogDAO();
        List<ActivityLog> logs = dao.getFilteredLogs(username, actionType, targetTable, from, to, targetID);

        // Gửi dữ liệu và giữ nguyên các giá trị filter
        request.setAttribute("logList", logs);
        request.getRequestDispatcher("Manager/ActivityLogs.jsp").forward(request, response);
    }

}
