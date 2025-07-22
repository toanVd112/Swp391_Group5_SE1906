/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Feedback;

import DAO.FeedbackDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Feedback;
import model.User;

/**
 *
 * @author Arcueid
 */
@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

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
    private FeedbackDAO feedbackDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listFeedback(request, response);
                break;
            case "reviewable":
                getReviewableBookings(request, response);
                break;
            case "rating":
                getRoomRating(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
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

        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            submitFeedback(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void submitFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userInfo");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }

        int userID = user.getUserId();

        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            int roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            boolean isAnonymous = "true".equals(request.getParameter("isAnonymous"));

            if (rating < 1 || rating > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5");
                return;
            }

            if (!feedbackDAO.canSubmitFeedback(bookingID, userID)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You cannot submit feedback for this booking");
                return;
            }

            Feedback feedback = new Feedback(bookingID, userID, roomTypeID, rating, comment, isAnonymous);

            if (feedbackDAO.submitFeedback(feedback)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Feedback submitted successfully\"}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Failed to submit feedback");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private void listFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            List<Feedback> feedbackList = feedbackDAO.getFeedbackByRoomType(roomTypeID);
            double averageRating = feedbackDAO.getAverageRating(roomTypeID);
            int[] distribution = feedbackDAO.getRatingDistribution(roomTypeID);

            int totalReviews = 0;
            for (int count : distribution) {
                totalReviews += count;
            }

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("averageRating", Math.round(averageRating * 10.0) / 10.0);
            request.setAttribute("ratingDistribution", distribution);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("roomTypeID", roomTypeID);

            String acceptHeader = request.getHeader("Accept");
            if (acceptHeader != null && acceptHeader.contains("application/json")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(gson.toJson(feedbackList));
            } else {
                request.getRequestDispatcher("/feedback-display.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room type ID");
        }
    }

    private void getReviewableBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userInfo");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }

        int userID = user.getUserId();
        List<Feedback> reviewableBookings = feedbackDAO.getReviewableBookings(userID);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(reviewableBookings));
    }

    private void getRoomRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            double averageRating = feedbackDAO.getAverageRating(roomTypeID);
            int[] distribution = feedbackDAO.getRatingDistribution(roomTypeID);

            RatingInfo ratingInfo = new RatingInfo();
            ratingInfo.averageRating = averageRating;
            ratingInfo.distribution = distribution;
            ratingInfo.totalReviews = 0;
            for (int count : distribution) {
                ratingInfo.totalReviews += count;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(ratingInfo));

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room type ID");
        }
    }

    private static class RatingInfo {

        public double averageRating;
        public int[] distribution;
        public int totalReviews;
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
