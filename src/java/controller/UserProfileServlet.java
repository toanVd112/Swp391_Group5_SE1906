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
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDao userDAO = new UserDao();
        User user = userDAO.getUserByAccountId(accountId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("user-profile.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8"); // Đảm bảo nhận Tiếng Việt
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        UserDao userDAO = new UserDao();
        User user = userDAO.getUserByAccountId(accountId);
        boolean ok = false;
        if (user == null) {
            // Thêm mới
            user = new User();
            user.setAccountId(accountId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            ok = userDAO.insertUser(user);
        } else {
            // Update
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            ok = userDAO.updateUser(user);
        }
        if (ok) {
            request.setAttribute("msg", "Cập nhật thành công!");
        } else {
            request.setAttribute("msg", "Có lỗi xảy ra!");
        }
        request.setAttribute("user", userDAO.getUserByAccountId(accountId)); // load lại info mới nhất
        request.getRequestDispatcher("user-profile.jsp").forward(request, response);
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
