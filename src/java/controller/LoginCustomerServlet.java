/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.AccountDAO;
import DAO.BookingDAO;
import DAO.RoomDAO;
import DAO.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginCustomerServlet extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("login.jsp").forward(request, response);
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

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AccountDAO dao = new AccountDAO();
        Account account = dao.login(username, password);
        int accountId = account.getAccountID();

        if (account != null) {
            HttpSession session = request.getSession();
            session.setMaxInactiveInterval(60 * 60); // 60 minutes

            // Lưu thông tin tài khoản
            session.setAttribute("account", account);
            session.setAttribute("accountId", account.getAccountID());
            session.setAttribute("user", account);
            // Lấy thông tin người dùng
            UserDao userDao = new UserDao();
            User userInfo = null;
            try {
                userInfo = userDao.getUserByAccountId(account.getAccountID());
              
                if (userInfo == null) {
                    // Tạo user mặc định nếu chưa có (tùy chọn)
                    // userInfo = new User();
                    // userInfo.setAccountId(account.getAccountID());
                    // userDao.updateUser(userInfo); // Cần thêm logic insert nếu muốn
                }
            } catch (Exception ex) {
                Logger.getLogger(LoginCustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            session.setAttribute("userInfo", userInfo); // Có thể null nếu không có bản ghi User

            // Chuyển hướng theo vai trò
            String role = account.getRole();
            switch (role.toLowerCase()) {
                case "customer":
                    response.sendRedirect("Home");
                    break;
                case "manager":
                    response.sendRedirect("Manager/manager.jsp");
                    break;
                case "receptionist":
                    response.sendRedirect("Receptionist/reception.jsp");
                    break;
                case "staff":
                    response.sendRedirect("Staff/staff.jsp");
                    break;
                default:
                    request.setAttribute("result", "Vai trò không được hỗ trợ!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    break;
            }
        } else {
            // Đăng nhập thất bại
            request.setAttribute("username", username);
            request.setAttribute("pass", password);
            request.setAttribute("result", "Incorrect username or password, Re-Enter, please!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
