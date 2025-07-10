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
import java.util.UUID;
import model.EmailUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/Register"})
public class RegisterCustomerServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Đặt lại để JSP đổ giá trị khi error
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        //request.setAttribute("password", password);
        //request.setAttribute("confirmPassword", confirmPassword);

        Validation val = new Validation();
        AccountDAO dao = new AccountDAO();

        // 1. Kiểm tra username
        if (!val.validateUsername(username)) {
            request.setAttribute("result", "Username must be greater than or equal to 4 characters and less than 20 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra password
        if (!val.validatePassword(password)) {
            request.setAttribute("result", "Password must be greater than or equal to 6 characters and less than 20 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra confirm password
        if (!password.equals(confirmPassword)) {
            request.setAttribute("result", "Password and Confirm Password do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 4. Kiểm tra trùng username hoặc email
        if (dao.isDuplicateAccount(username, email)) {
            request.setAttribute("result", "Username or Email already exists");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 5. Tạo account và lưu
        
        Account account = new Account();
        account.setUsername(username);
        account.setEmail(email);
        account.setPassword(password);
        account.setRole("Customer");
        account.setIsActive(true); // Đảm bảo account hoạt động


        boolean inserted = dao.insertAccount(account);
        if (inserted) {
        // Gửi mail với link đăng nhập
            String context = request.getRequestURL().toString().replace(request.getServletPath(), "");
            String loginLink = context + "/login.jsp";
            String content = "Hello,<br/>Your account has been successfully registered!<br/>"
                    + "You can login here: <a href='" + loginLink + "'>Login</a>";

            EmailUtil.sendMail(email, "Hoang Nam Hotel account registration successful", content);

            // Hiển thị message ở trang đăng nhập
            request.setAttribute("success", "You have successfully registered, please enter your email to login.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            request.setAttribute("result", "Registration failed, please try again");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Register servlet for HoangNam Hotel";
    }// </editor-fold>

}
