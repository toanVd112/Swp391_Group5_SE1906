/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.AccountDAO;
import DAO.DBConnect;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.*;
import model.Account;
import model.EmailUtil;
import model.User;


/**
 *
 * @author AD
 */
@WebServlet(name="ChangePassword", urlPatterns={"/changePassword"})
public class ChangePassword extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ChangePassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassword at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            request.setAttribute("mess", "Session expired or invalid! Please log in again.");
            response.sendRedirect("login.jsp");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByID(String.valueOf(accountId));
        if (account == null || account.getUsername() == null) {
            request.setAttribute("mess", "Unable to determine user information!");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra lỗi cơ bản
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("mess", "New password and confirm password do not match!");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("mess", "New password must be at least 6 characters!");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        // Kết nối cơ sở dữ liệu và xử lý
        try {
//            int accountIdInt = accountId; // Sử dụng accountId từ session
            String email = account.getEmail();
            StringBuilder errorMessage = new StringBuilder();
            boolean ok = accountDAO.changePassword(email, currentPassword, newPassword, errorMessage);

            if (ok) {
               
                // Gửi email thông báo bằng EmailUtil
                String subject = "Password changed successfully";
                String content = "<h3>Hello,</h3>" +
                                "<p>Your password has been changed successfully.</p>" +
                                "<p>If you do not make this change, please contact your administrator immediately.</p>" +
                                "<p>Thank you so much,<br>Hoang Nam Hotel</p>";
                boolean emailSent = EmailUtil.sendMail(email, subject, content);
                if (emailSent) {
                    System.out.println("Email notification sent successfully to " + email);
                } else {
                    System.out.println("Failed to send email notification to " + email);
                }
                request.setAttribute("message", "Password changed successfully!");
                request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            } else {
                request.setAttribute("mess", errorMessage.toString());
                request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("mess", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
        }
    }

    // Phương thức bổ sung để lấy AccountID từ Username
    private int getAccountIdFromUsername(String username, AccountDAO accountDAO) throws SQLException {
        String sql = "SELECT AccountID FROM Accounts WHERE Username = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            ps.setString(1, username);
            if (rs.next()) {
                return rs.getInt("AccountID");
            }
            throw new SQLException("Không tìm thấy AccountID cho username: " + username);
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy AccountID: " + e.getMessage());
            throw e;
        }
    }
    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
