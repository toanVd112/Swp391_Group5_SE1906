/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manageAccountCustomer;

import DAO.AccountDAO;
import controller.managerAccountStaff.AddAccount;
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

/**
 *
 * @author MyPC
 */
@WebServlet(name = "AddAccountCustomer", urlPatterns = {"/addAccountC"})
public class AddAccountCustomer extends HttpServlet {

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
            out.println("<title>Servlet AddAccountCustomer</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAccountCustomer at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String active = request.getParameter("isActive");

        String role = "Customer";  // Cố định

        boolean hasError = false;
        AccountDAO dao = new AccountDAO();

        try {
            if (dao.isUsernameTaken(user)) {
                request.setAttribute("usernameError", "Tên đăng nhập đã tồn tại.");
                hasError = true;
            }

            if (dao.isEmailTaken(email)) {
                request.setAttribute("emailError", "Email đã được sử dụng.");
                hasError = true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AddAccount.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình kiểm tra dữ liệu.");
            hasError = true;
        }

        if (user == null || user.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username không được để trống.");
            hasError = true;
        }

        if (pass == null || pass.trim().length() < 6) {
            request.setAttribute("passwordError", "Password phải có ít nhất 6 ký tự.");
            hasError = true;
        }

        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            request.setAttribute("emailError", "Email không hợp lệ.");
            hasError = true;
        }

        boolean isActive = Boolean.parseBoolean(active);

        if (hasError) {
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("isActive", active);
            request.setAttribute("email", email);
            request.setAttribute("showAddModal", true); // Để tự mở modal khi quay lại

            request.getRequestDispatcher("/Receptionist/managerAccountCustomer.jsp").forward(request, response);
        } else {
            dao.addAccountC(user, pass, isActive, email); // Phải truyền role luôn

            response.sendRedirect("managerAccountC");
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
