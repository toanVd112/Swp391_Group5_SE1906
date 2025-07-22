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
import DAO.UserDao;
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
        response.sendRedirect("roomlist");
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
       Account account = (Account) session.getAttribute("account");

        // Check if user is logged in
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int roomTypeID = -1;

        try {
            // Get parameters
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            boolean isAnonymous = "true".equals(request.getParameter("isAnonymous"));

            // Validate rating
            if (rating < 1 || rating > 5) {
                response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=invalid_rating");
                return;
            }

            // Get user details
            UserDao userDao = new UserDao();
            User user = userDao.getUserByAccountId(account.getAccountID());

            if (user == null) {
                response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=user_not_found");
                return;
            }

            // Check if user can submit feedback
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            if (!feedbackDAO.canSubmitFeedback(bookingID, user.getUserId())) {
                response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=unauthorized");
                return;
            }

            // Create feedback object
            Feedback feedback = new Feedback();
            feedback.setBookingID(bookingID);
            feedback.setUserID(user.getUserId());
            feedback.setRoomTypeID(roomTypeID);
            feedback.setRating(rating);
            feedback.setComment(comment);
            feedback.setAnonymous(isAnonymous);

            // Submit feedback
            boolean success = feedbackDAO.submitFeedback(feedback);

            if (success) {
                response.sendRedirect("RoomDetail?id=" + roomTypeID + "&success=true");
            } else {
                response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=submission_failed");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("RoomDetail?id=" + roomTypeID + "&error=invalid_parameters");
        } catch (Exception e) {
            e.printStackTrace();
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
