/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginStaff", urlPatterns = {"/LoginStaff"})
public class LoginStaff extends HttpServlet {

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
            out.println("<title>Servlet LoginStaff</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginStaff at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        AccountDAO dao = new AccountDAO();
        Account account = dao.login(username, password);

        if (account != null && account.getRole().equalsIgnoreCase(selectedRole)) {
            // Đăng nhập thành công, lưu thông tin vào session
            HttpSession session = request.getSession();
            session.setMaxInactiveInterval(60 * 60);
            session.setAttribute("account", account);

            // Phân quyền: Chuyển hướng đến trang phù hợp với vai trò
            switch (selectedRole) {
                case "Manager":
                    response.sendRedirect("Manager/manager.jsp");
                    break;
                case "Receptionist":
                    response.sendRedirect("Receptionist/reception.jsp");
                    break;
                case "Staff":
                    response.sendRedirect("Staff/staff.jsp");
                    break;
                default:
                    response.sendRedirect("error-404.html");
            }
        } else {
            // Sai thông tin hoặc role không đúng
             request.setAttribute("pass", password);
            request.setAttribute("username", username);
            request.setAttribute("role", selectedRole);
            request.setAttribute("result", "Invalid username, password or role");
            // forward (không redirect) để giữ nguyên request
            request.getRequestDispatcher("login_2.jsp")
                    .forward(request, response);

        }
    }
}

/**
 * Returns a short description of the servlet.
 *
 * @return a String containing servlet description
 */
