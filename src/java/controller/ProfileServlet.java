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
import DAO.UserDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.Date;

/**
 *
 * @author AD
 */
@WebServlet(name="LoadProfileServlet", urlPatterns={"/profile"})
public class ProfileServlet extends HttpServlet {
   
    private static final long serialVersionUID = 1L;

    // Regex validation
    private static final Pattern NAME_RE  = Pattern.compile("^[A-Za-z\\s]{1,30}$");
    private static final Pattern PHONE_RE = Pattern.compile("^\\d{10}$");
    private static final Pattern DOB_RE   = Pattern.compile("^[\\d/]{1,15}$");

    private final UserDao userDao = new UserDao();
    
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
            out.println("<title>Servlet LoadProfileServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadProfileServlet at " + request.getContextPath () + "</h1>");
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
        Integer accountId = (Integer) session.getAttribute("accountID");
        if (accountId == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        User user = userDao.getUserByAccountId(accountId);
        if (user != null) {
            session.setAttribute("user", user);
                    // Chuyển đổi ngày sinh từ "dd/MM/yyyy" sang "yyyy-MM-dd" để hiển thị trên <input type="date">
            String rawDob = user.getDateOfBirth();
            String formattedDob = "";
            if (rawDob != null && !rawDob.isEmpty()) {
                try {
                    Date parsedDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(rawDob);
                    formattedDob = new java.text.SimpleDateFormat("yyyy-MM-dd").format(parsedDate);
                } catch (java.text.ParseException e) {
                    formattedDob = ""; // fallback nếu lỗi định dạng
                }
            }
            request.setAttribute("formattedDob", formattedDob);
        }
        // Forward về JSP   
        request.getRequestDispatcher("user_profile2.jsp")
           .forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountID");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName").trim();
        String email    = request.getParameter("email").trim();
        String phone    = request.getParameter("phone").trim();
        String rawDob   = request.getParameter("dateOfBirth").trim(); // yyyy-MM-dd
        String address  = request.getParameter("address").trim();

        // Validate
        String error = null;
        if (!NAME_RE.matcher(fullName).matches()) {
            error = "Họ tên chỉ chứa chữ và khoảng trắng, tối đa 30 ký tự.";
        } else if (!PHONE_RE.matcher(phone).matches()) {
            error = "Số điện thoại phải đúng 10 chữ số.";
        } else if (!DOB_RE.matcher(rawDob.replace("-", "/")).matches()) {
            error = "Ngày sinh chỉ số và '/', tối đa 15 ký tự.";
        } else if (address.length() > 30) {
            error = "Địa chỉ tối đa 30 ký tự.";
        }

        // Chuyển định dạng ngày sinh: yyyy-MM-dd → dd/MM/yyyy
        String dobFormatted = "";
        if (error == null) {
            try {
                java.util.Date parsed = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(rawDob);
                dobFormatted = new java.text.SimpleDateFormat("dd/MM/yyyy").format(parsed);
            } catch (java.text.ParseException e) {
                error = "Định dạng ngày sinh không hợp lệ.";
            }
        }
        
        if (error != null) {
            // Trả lại lỗi và giữ tạm giá trị đã nhập
            request.setAttribute("errorMessage", error);
            request.setAttribute("tempFullName", fullName);
            request.setAttribute("tempEmail", email);
            request.setAttribute("tempPhone", phone);
            request.setAttribute("tempDob", rawDob);
            request.setAttribute("tempAddress", address);
            request.getRequestDispatcher("user_profile2.jsp")
               .forward(request, response);
            return;
        }

        // Cập nhật vào DB
        User user = (User) session.getAttribute("user");
        if (user == null) user = new User();
        user.setAccountId(accountId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setDateOfBirth(dobFormatted);
        user.setAddress(address);

        boolean ok = userDao.updateUser(user);
        if (ok) {
            // Cập nhật session và redirect để tránh resubmit
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thất bại, vui lòng thử lại.");
            request.getRequestDispatcher("user_profile2.jsp")
               .forward(request, response);
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
