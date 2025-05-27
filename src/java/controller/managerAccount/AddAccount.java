/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.managerAccount;

import DAO.AccountDAO;
import controller.Validation;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author MyPC
 */
@WebServlet(name = "AddAccount", urlPatterns = {"/addAccount"})
public class AddAccount extends HttpServlet {

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
            out.println("<title>Servlet AddAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAccount at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        AccountDAO ad = new AccountDAO();
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");
        String active = request.getParameter("isActive");
        String email = request.getParameter("email");

        boolean isActive = Boolean.parseBoolean(active);
        if (ad.isDuplicateAccount(user, email)) {
            request.setAttribute("error", "user or email đã tồn tại");
            request.setAttribute("showAddModal", true);
            request.getRequestDispatcher("managerAccount").forward(request, response);
            return;
        }//
        // Validation username
        if (!Validation.validateUsername(user)) {
            request.setAttribute("error", "Tên đăng nhập không hợp lệ. Độ dài từ 4–20 ký tự.");
            request.setAttribute("showAddModal", true);
            request.getRequestDispatcher("managerAccount").forward(request, response);
            return;
        }

        {
            if (!Validation.validatePassword(pass)) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự, chứa chữ hoa, chữ thường, số và ký tự đặc biệt.");
                request.setAttribute("showAddModal", true);
                request.getRequestDispatcher("managerAccount").forward(request, response);
                return;
            }
        }

        // Nếu hợp lệ, thêm tài khoản
        ad.addAccount(user, pass, role, isActive, email);
        response.sendRedirect("managerAccount");
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
