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
import model.TokenDAO;
import model.TokenInfo;

/**
 *
 * @author AD
 */
@WebServlet(name="resetPassword", urlPatterns={"/resetPassword"})
public class resetPassword extends HttpServlet {
   
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
            out.println("<title>Servlet resetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet resetPassword at " + request.getContextPath () + "</h1>");
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
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("mess", "Link không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        // Lấy token từ DB
        TokenInfo tokenInfo = new TokenDAO().getTokenInfo(token);

        // Kiểm tra token
        if (tokenInfo == null || tokenInfo.isUsed() || tokenInfo.getExpiryTime().before(new java.util.Date())) {
            request.setAttribute("mess", "Link đã hết hạn hoặc không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        // Lấy email từ accountId
        String email = new AccountDAO().getEmailByAccountId(tokenInfo.getAccountId());
        request.setAttribute("email", email);
        request.setAttribute("token", token); // giữ lại token cho POST
        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
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
        String token = request.getParameter("token");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        request.setAttribute("email", email);
        request.setAttribute("token", token);

        if (password == null || confirm == null || !password.equals(confirm)) {
            request.setAttribute("mess", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        if (!Validation.validatePassword(password)) {
            request.setAttribute("mess", "Mật khẩu phải tối thiểu 6 ký tự.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        TokenInfo tokenInfo = new TokenDAO().getTokenInfo(token);
        if (tokenInfo == null || tokenInfo.isUsed() || tokenInfo.getExpiryTime().before(new java.util.Date())) {
            request.setAttribute("mess", "Link đã hết hạn hoặc không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email có khớp với token không
        String dbEmail = new AccountDAO().getEmailByAccountId(tokenInfo.getAccountId());
        if (!email.equalsIgnoreCase(dbEmail)) {
            request.setAttribute("mess", "Email không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        // Cập nhật password (nên hash mật khẩu)
        boolean ok = new AccountDAO().updatePasswordByEmail(email, password);
        if (ok) {
            new TokenDAO().markTokenAsUsed(token);
            response.sendRedirect("login.jsp?reset=success");
        } else {
            request.setAttribute("mess", "Có lỗi xảy ra, vui lòng thử lại!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
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
