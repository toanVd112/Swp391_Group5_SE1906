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
@WebServlet(name = "EditAccount", urlPatterns = {"/editAccount"})
public class EditAccount extends HttpServlet {

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
            out.println("<title>Servlet EditAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditAccount at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String active = request.getParameter("isActive");
        String email = request.getParameter("email");
        String aid = request.getParameter("aid");

        boolean isActive = Boolean.parseBoolean(active);
        boolean hasError = false;

        // Gán lại account để giữ giá trị trong form nếu có lỗi
        Account acc = new Account(Integer.parseInt(aid), user, pass, role, isActive, email);
        request.setAttribute("account", acc);

        // Validate từng trường và đặt thông báo lỗi tương ứng
        if (user == null || user.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username must not be empty.");
            hasError = true;
        }

        if (pass == null || pass.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password must not be empty.");
            hasError = true;
        }

        if (email == null || email.trim().isEmpty()
                || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("emailError", "Invalid email address.");
            hasError = true;
        }

        // Nếu có lỗi thì quay lại trang editAccount.jsp
        if (hasError) {
            request.getRequestDispatcher("managerAccount").forward(request, response);
            return;
        }

        // Cập nhật vào CSDL
        AccountDAO ad = new AccountDAO();
        ad.editAccount(user, pass, role, isActive, email, aid);

        // Ghi lại lịch sử chỉnh sửa
        Account currentUser = (Account) request.getSession().getAttribute("account");
        int editedID = Integer.parseInt(aid);
        ActivityStaffDAO logDAO = new ActivityStaffDAO();
        try {
            logDAO.logAction(currentUser.getAccountID(), "Edit", "accounts", editedID);
        } catch (SQLException ex) {
            Logger.getLogger(EditAccount.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Chuyển hướng về trang quản lý tài khoản
        response.sendRedirect("managerAccount");
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
