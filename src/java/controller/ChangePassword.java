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
        // Kiểm tra session để đảm bảo người dùng đã đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Chuyển hướng đến trang thay đổi mật khẩu
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
        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form
        String username = (String) session.getAttribute("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra lỗi cơ bản
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("mess", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        // Kết nối cơ sở dữ liệu và xử lý
        AccountDAO accountDAO = new AccountDAO();
        try {
            // Lấy email từ AccountID dựa trên username
            int accountId = getAccountIdFromUsername(username, accountDAO);
            String email = accountDAO.getEmailByAccountId(accountId);

            // Gọi phương thức changePassword
            boolean ok = accountDAO.changePassword(email, currentPassword, newPassword);
            if (ok) {
                request.setAttribute("message", "Đổi mật khẩu thành công vào lúc 04:00 PM +07, Wednesday, July 09, 2025");
                request.getRequestDispatcher("/user_profile2.jsp").forward(request, response);
            } else {
                request.setAttribute("mess", "Có lỗi xảy ra khi thay đổi mật khẩu! Vui lòng kiểm tra mật khẩu hiện tại.");
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
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("AccountID");
                }
            }
        }
        throw new SQLException("Không tìm thấy AccountID cho username: " + username);
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
