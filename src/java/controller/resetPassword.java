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
        System.out.println("[DEBUG] Token param: " + token);
        
        if (token == null || token.trim().isEmpty()) {
            System.out.println("[DEBUG] Token is null or empty");
            request.setAttribute("mess", "Link không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        // Lấy token từ DB
        TokenInfo tokenInfo = new TokenDAO().getTokenInfo(token);

        // Kiểm tra token
        System.out.println("[DEBUG] TokenInfo: " + tokenInfo);
        if (tokenInfo != null) {
            System.out.println("[DEBUG] tokenInfo.token = " + tokenInfo.getToken());
            System.out.println("[DEBUG] tokenInfo.isUsed = " + tokenInfo.isUsed());
            System.out.println("[DEBUG] tokenInfo.expiryTime = " + tokenInfo.getExpiryTime());
            System.out.println("[DEBUG] Now = " + new java.util.Date());
        }

        // Lấy email từ accountId
        if (tokenInfo == null || tokenInfo.isUsed() || tokenInfo.getExpiryTime().before(new java.util.Date())) {
            System.out.println("[DEBUG] Token invalid or expired");
            request.setAttribute("mess", "Link đã hết hạn hoặc không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        
        String email = new AccountDAO().getEmailByAccountId(tokenInfo.getAccountId());
        System.out.println("[DEBUG] Email for accountId " + tokenInfo.getAccountId() + " is: " + email);

        request.setAttribute("email", email);
        request.setAttribute("token", token);
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

//        request.setAttribute("email", email);
//        request.setAttribute("token", token);

        System.out.println("[DEBUG] POST: token = " + token + ", email = " + email);

        if (password == null || confirm == null || !password.equals(confirm)) {
            System.out.println("[DEBUG] Passwords do not match");
            request.setAttribute("mess", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        if (!Validation.validatePassword(password)) {
            System.out.println("[DEBUG] Password does not meet criteria");
            request.setAttribute("mess", "Mật khẩu phải tối thiểu 6 ký tự.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        TokenInfo tokenInfo = new TokenDAO().getTokenInfo(token);
        if (tokenInfo != null) {
            System.out.println("[DEBUG] POST tokenInfo.token = " + tokenInfo.getToken());
            System.out.println("[DEBUG] POST tokenInfo.isUsed = " + tokenInfo.isUsed());
            System.out.println("[DEBUG] POST tokenInfo.expiryTime = " + tokenInfo.getExpiryTime());
            System.out.println("[DEBUG] POST Now = " + new java.util.Date());
        }

        if (tokenInfo == null || tokenInfo.isUsed() || tokenInfo.getExpiryTime().before(new java.util.Date())) {
            System.out.println("[DEBUG] Token invalid or expired (POST)");
            request.setAttribute("mess", "Link đã hết hạn hoặc không hợp lệ!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        String dbEmail = new AccountDAO().getEmailByAccountId(tokenInfo.getAccountId());
        System.out.println("[DEBUG] DB email: " + dbEmail + ", submitted email: " + email);

        if (!email.equalsIgnoreCase(dbEmail)) {
            System.out.println("[DEBUG] Email does not match");
            request.setAttribute("mess", "Email không hợp lệ!");
            request.getRequestDispatcher("resetPassword);.jsp").forward(request, response);
            return;
        }

        // =========== Check trùng mật khẩu cũ ===========
        AccountDAO accountDAO = new AccountDAO();
        String oldPassword = accountDAO.getPasswordByEmail(email);

        // Nếu dùng mã hóa mật khẩu, phải hash password trước khi so sánh!
        if (oldPassword != null && password.equals(oldPassword)) {
            request.setAttribute("mess", "Mật khẩu mới không được trùng với mật khẩu cũ, vui lòng nhập lại!");
            request.setAttribute("email", email);
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        
        boolean ok = new AccountDAO().updatePasswordByEmail(email, password);
        System.out.println("[DEBUG] Update password result: " + ok);
        if (ok) {
            new TokenDAO().markTokenAsUsed(token);
            System.out.println("[DEBUG] Password updated and token marked as used");
            response.sendRedirect("login.jsp?reset=success");
        } else {
            System.out.println("[DEBUG] Failed to update password");
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
