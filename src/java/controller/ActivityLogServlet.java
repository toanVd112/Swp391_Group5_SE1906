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
        ActivityLogDAO dao = new ActivityLogDAO();
        List<ActivityLog> logs = dao.getAllLogs();

        request.setAttribute("logList", logs);
        request.getRequestDispatcher("Manager/ActivityLogs.jsp").forward(request, response);
    }
}
