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
import jakarta.servlet.http.*;
import model.Account;
import java.util.regex.Pattern;

/**
 *
 * @author AD
 */
@WebServlet(name="AddEmployeeServlet", urlPatterns={"/add-employee"})
public class AddEmployeeServlet extends HttpServlet {
     private AccountDAO accountDao;

    @Override
    public void init() throws ServletException {
        accountDao = new AccountDAO();
    }
   
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
            out.println("<title>Servlet AddEmployeeServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddEmployeeServlet at " + request.getContextPath () + "</h1>");
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Account current = (Account) session.getAttribute("loggedUser");
        if (!"Manager".equals(current.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/addEmployee.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Account current = (Account) session.getAttribute("loggedUser");
        if (!"Manager".equals(current.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }
        // Lấy dữ liệu từ form
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");
        String email    = request.getParameter("email").trim();
        String role     = request.getParameter("role");

        String errorMsg = null;

        // 1. Validate username bằng Validation.validateUsername()
        if (!Validation.validateUsername(username)) {
            errorMsg = "Username phải từ 4-20 ký tự và không được để trống.";
        }
        // 2. Validate password bằng Validation.validatePassword()
        else if (!Validation.validatePassword(password)) {
            errorMsg = "Password phải có ít nhất 6 ký tự.";
        }
        // 3. Validate email với regex
        else if (email.isEmpty() || !Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email)) {
            errorMsg = "Email không hợp lệ.";
        }
        // 4. Role phải là Staff hoặc Receptionist
        else if (!("Staff".equals(role) || "Receptionist".equals(role))) {
            errorMsg = "Role chỉ được chọn 'Staff' hoặc 'Receptionist'.";
        }

        // Nếu có lỗi validate, back lại JSP với thông báo
        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/WEB-INF/views/addEmployee.jsp").forward(request, response);
            return;
        }

        // 5. Kiểm tra duplicate (username hoặc email)
        boolean isDup = accountDao.isDuplicateAccount(username, email);
        if (isDup) {
            request.setAttribute("error", "Username hoặc Email đã tồn tại. Vui lòng chọn thông tin khác.");
            request.getRequestDispatcher("/WEB-INF/views/addEmployee.jsp").forward(request, response);
            return;
        }

        // 6. Chuẩn bị đối tượng Account để chèn
        Account newAcct = new Account();
        newAcct.setUsername(username);
        newAcct.setPassword(password); // Lưu ý: mật khẩu ở đây vẫn là plaintext. Nếu muốn hash, bạn phải sửa DAO để hash trước khi insert.
        newAcct.setRole(role);
        newAcct.setActive(true);
        newAcct.setEmail(email);

        // 7. Gọi DAO để insert
        boolean created = accountDao.insertAccount(newAcct);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/manage-employees?msg=success");
        } else {
            request.setAttribute("error", "Không thể tạo tài khoản mới. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/addEmployee.jsp").forward(request, response);
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
