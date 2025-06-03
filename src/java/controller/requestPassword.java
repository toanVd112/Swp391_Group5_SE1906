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
import model.Account;
import model.EmailUtil;
import model.TokenDAO;

/**
 *
 * @author AD
 */
@WebServlet(name="requestPassword", urlPatterns={"/requestPassword"})
public class requestPassword extends HttpServlet {
   
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
            out.println("<title>Servlet requestPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet requestPassword at " + request.getContextPath () + "</h1>");
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
//        request.getRequestDispatcher("requestPassword.jsp").forward(request, response);
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
        String email = request.getParameter("email");
        // 1. Kiểm tra email hợp lệ
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("mess", "Email không được để trống!");
            request.getRequestDispatcher("requestPassword.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra email có trong hệ thống không
        Account account = new AccountDAO().getAccountByEmail(email);

        // Nếu tài khoản tồn tại
        if (account != null) {
            // 3. Sinh token ngẫu nhiên
            String token = java.util.UUID.randomUUID().toString();
            // 4. Thời gian hết hạn (ví dụ: 30 phút từ bây giờ)
            java.util.Date expiry = new java.util.Date(System.currentTimeMillis() + 30*60*1000);

            // 5. Ghi token vào DB (DAO cần method insertToken)
            new TokenDAO().insertToken(token, new java.sql.Timestamp(expiry.getTime()), false, account.getAccountID());

            // 6. Gửi email (dùng JavaMail, code mẫu bên dưới)
            String link = request.getRequestURL().toString().replace("requestPassword", "resetPassword") + "?token=" + token;
            String subject = "Reset Password - Hoang Nam Hotel";
            String content = "Enter the link to reset password (có hiệu lực 30 phút): " + link;

            EmailUtil.sendMail(email, subject, content); // Bạn tự implement hoặc dùng thư viện JavaMail
        }

        // 7. Luôn trả về thông báo không tiết lộ email đúng/sai
        request.setAttribute("mess", "Nếu email hợp lệ, bạn sẽ nhận được hướng dẫn trong hộp thư của mình!");
        request.getRequestDispatcher("requestPassword.jsp").forward(request, response);
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
