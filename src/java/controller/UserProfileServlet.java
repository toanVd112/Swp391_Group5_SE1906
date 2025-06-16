/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import DAO.UserDao;
import model.Account;
import model.User;

/**
 *
 * @author AD
 */
@WebServlet(name="UserProfileServlet", urlPatterns={"/user-profile"})
public class UserProfileServlet extends HttpServlet {
   
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
            out.println("<title>Servlet UserProfileServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserProfileServlet at " + request.getContextPath () + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int accountId = account.getAccountID();

        UserDao userDAO = new UserDao();
        User user = userDAO.getUserByAccountId(accountId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/admin/user-profile.jsp").forward(request, response);
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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo nhận Tiếng Việt
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int accountId = account.getAccountID();
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        StringBuilder errors = new StringBuilder();
    // Validate họ tên
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Vui lòng nhập Họ tên.<br>");
        } else if (!isValidName(fullName.trim())) {
            errors.append("Họ tên chỉ được nhập chữ, không chứa số hoặc ký tự đặc biệt.<br>");
        }

    // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.append("Vui lòng nhập Email.<br>");
        } else if (!isValidEmail(email.trim())) {
            errors.append("Email không hợp lệ.<br>");
        }

    // Validate số điện thoại
        if (phone == null || phone.trim().isEmpty()) {
            errors.append("Vui lòng nhập Số điện thoại.<br>");
        } else if (!isValidPhone(phone.trim())) {
            errors.append("Số điện thoại phải gồm đúng 10 số.<br>");
        }
    // Validate địa chỉ
        if (address == null || address.trim().isEmpty()) {
            errors.append("Vui lòng nhập Địa chỉ.<br>");
        } else if (address.trim().length() > 30) {
            errors.append("Địa chỉ chỉ được nhập tối đa 30 ký tự.<br>");
        }

        UserDao userDAO = new UserDao();
        User user = userDAO.getUserByAccountId(accountId);
        
        if (errors.length() > 0) {
            if (user == null) {
                user = new User();
                user.setAccountId(accountId);
            }
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);

            request.setAttribute("user", user);
            request.setAttribute("msg", "<span style='color:red'>" + errors.toString() + "</span>");
            request.getRequestDispatcher("/admin/user-profile.jsp").forward(request, response);
            return;
        }

        boolean ok;
        if (user == null) {
            user = new User();
            user.setAccountId(accountId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            ok = userDAO.insertUser(user);
        } else {
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            ok = userDAO.updateUser(user);
        }
        if (ok) {
            request.setAttribute("msg", "<span style='color:green'>Cập nhật thành công!</span>");
        } else {
            request.setAttribute("msg", "<span style='color:red'>Có lỗi xảy ra khi lưu thông tin!</span>");
        }
        request.setAttribute("user", userDAO.getUserByAccountId(accountId)); // load lại info mới nhất
        request.getRequestDispatcher("/admin/user-profile.jsp").forward(request, response);
    }
    
    // Validate email theo regex đơn giản
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w-.]+@[\\w-]+(\\.[\\w-]+)+$");
    }

    // Validate số điện thoại (chỉ số và 10 ký tự)
    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^\\d{10}$");
    }
    
    // Cho phép chữ cái tiếng Việt, chữ hoa, thường, và khoảng trắng, không số hoặc ký tự đặc biệt
    private boolean isValidName(String name) {
        return name != null && name.matches("^[a-zA-ZÀ-ỹ\\s]+$");
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
