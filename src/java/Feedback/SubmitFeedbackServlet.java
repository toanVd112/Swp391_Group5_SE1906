/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Feedback;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.FeedbackDAO;
import jakarta.servlet.http.*;
import model.Account;
import model.Feedback;
import model.User;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "SubmitFeedbackServlet", urlPatterns = {"/submit-feedback"})
public class SubmitFeedbackServlet extends HttpServlet {

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
            out.println("<title>Servlet NewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NewServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");

        // ✅ Kiểm tra đăng nhập
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int roomTypeID = -1; // Khởi tạo để dùng khi redirect lỗi

        try {
            int userID = account.getAccountID();
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));  // Có thể là 0 nếu không dùng
            roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            String comment = request.getParameter("comment");

            // ✅ Đã tạm bỏ phần rating
            int rating = 0;

            boolean showEmail = request.getParameter("showEmail") != null;
            boolean showFacebook = request.getParameter("showFacebook") != null;
            boolean showInstagram = request.getParameter("showInstagram") != null;

            Feedback fb = new Feedback();
            fb.setUserID(userID);
            fb.setBookingID(bookingID);
            fb.setRating(rating);
            fb.setComment(comment);
            fb.setShowEmail(showEmail);
            fb.setShowFacebook(showFacebook);
            fb.setShowInstagram(showInstagram);

            FeedbackDAO dao = new FeedbackDAO();
            dao.insertFeedback(fb);

            // ✅ Redirect thành công
            response.sendRedirect("RoomDetail?id=" + roomTypeID + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            // ✅ Redirect lại với id hợp lệ để tránh lỗi "id=0"
            response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=500");
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
