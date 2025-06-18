/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.managerAccount;

import DAO.AccountDAO;
import DAO.ActivityStaffDAO;
import controller.Validation;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;

/**
 *
 * @author MyPC
 */
@WebServlet(name = "AddAccount", urlPatterns = {"/addAccount"})
public class AddAccount extends HttpServlet {

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
            out.println("<title>Servlet AddAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAccount at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String active = request.getParameter("isActive");
        String email = request.getParameter("email");
        String aid = request.getParameter("aid");

        boolean hasError = false;

        // Kiểm tra username
        if (user == null || user.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username không được để trống.");
            hasError = true;
        }

        // Kiểm tra password
        if (pass == null || pass.length() < 6) {
            request.setAttribute("passwordError", "Password phải có ít nhất 6 ký tự.");
            hasError = true;
        }

        // Kiểm tra email
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            request.setAttribute("emailError", "Email không hợp lệ.");
            hasError = true;
        }

        // Kiểm tra role
        if (role == null || !(role.equals("Manager") || role.equals("Receptionist") || role.equals("Staff"))) {
            request.setAttribute("roleError", "Role không hợp lệ.");
            hasError = true;
        }

        // Kiểm tra isActive
        boolean isActive = Boolean.parseBoolean(active);

        if (hasError) {
            // Gửi lại dữ liệu đã nhập và chuyển hướng về lại trang edit
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("email", email);
            request.setAttribute("role", role);
            request.setAttribute("isActive", active);
            request.setAttribute("aid", aid);

            request.getRequestDispatcher("Manager/editAccount.jsp").forward(request, response);
        } else {
            // Nếu hợp lệ thì cập nhật dữ liệu
            AccountDAO ad = new AccountDAO();
            Account acc=new Account(0, user, pass, role, isActive, email);
            ad.addAccount(user, pass, role, isActive, email);
            response.sendRedirect("managerAccount");
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String active = request.getParameter("isActive");
        String email = request.getParameter("email");

        boolean hasError = false;

        // Validate input
        if (user == null || user.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username không được để trống.");
            hasError = true;
        }

        if (pass == null || pass.length() < 6) {
            request.setAttribute("passwordError", "Password phải có ít nhất 6 ký tự.");
            hasError = true;
        }

        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            request.setAttribute("emailError", "Email không hợp lệ.");
            hasError = true;
        }

        if (role == null || !(role.equals("Receptionist") || role.equals("Staff"))) {
            request.setAttribute("roleError", "Role không hợp lệ.");
            hasError = true;
        }

        boolean isActive = Boolean.parseBoolean(active);

        if (hasError) {
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("role", role);
            request.setAttribute("isActive", active);
            request.setAttribute("email", email);
            request.setAttribute("showAddModal", true); // Để mở lại modal

            request.getRequestDispatcher("managerAccount").forward(request, response);
        } else {
            // Gọi DAO để thêm account mới
            AccountDAO dao = new AccountDAO();
            dao.addAccount(user, pass, role, isActive, email);
            response.sendRedirect("managerAccount"); // Quay lại danh sách
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
