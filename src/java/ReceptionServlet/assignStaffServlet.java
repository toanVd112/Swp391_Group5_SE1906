/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ReceptionServlet;

import DAO.AccountDAO;
import DAO.MaintenanceRequestDAO;
import DAO.RoomDAO;
import DAO.RoomInspectionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;

import java.util.*;
import java.util.List;
import model.Account;

/**
 *
 * @author Admin
 */
@WebServlet(name = "assignStaffServlet", urlPatterns = {"/assignStaffServlet"})
public class assignStaffServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet assignStaffServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet assignStaffServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            AccountDAO accountDAO = new AccountDAO();
            List<Account> staffList = accountDAO.getAccountsByRole("Staff");

            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("/Receptionist/assignTask.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi doGet AssignTaskServlet: " + e.getMessage(), e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            String taskType = request.getParameter("taskType");
            String deadlineStr = request.getParameter("deadline");
            String description = request.getParameter("description");

            Timestamp deadline = Timestamp.valueOf(deadlineStr.replace("T", " ") + ":00");

            RoomDAO roomDAO = new RoomDAO();
            int roomId = roomDAO.getRoomIdByNumber(roomNumber);

            if ("inspection".equals(taskType)) {
                RoomInspectionDAO inspectionDAO = new RoomInspectionDAO();
                inspectionDAO.assignInspection(roomId, staffId, deadline, description);
            } else if ("maintenance".equals(taskType)) {
                MaintenanceRequestDAO maintenanceDAO = new MaintenanceRequestDAO();
                maintenanceDAO.createRequest(roomId, staffId, description, deadline);
            }

            response.sendRedirect("Receptionist/assignTask.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Receptionist/assignTask.jsp?error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
