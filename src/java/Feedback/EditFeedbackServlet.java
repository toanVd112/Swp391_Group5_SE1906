/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Feedback;

import DAO.FeedbackDAO;
import DAO.UserDao;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Feedback;
import model.User;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "EditFeedbackServlet", urlPatterns = {"/edit-feedback"})
public class EditFeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;
    private UserDao userDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
        userDao = new UserDao();
        gson = new Gson();
    }

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

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get user details
            User user = userDao.getUserByAccountId(account.getAccountID());
            if (user == null) {
                request.setAttribute("errorMessage", "User not found");
                request.getRequestDispatcher("/user-feedback.jsp").forward(request, response);
                return;
            }

            // Get user's feedback
            List<Feedback> userFeedbacks = feedbackDAO.getFeedbackByUserId(user.getUserId());

            // Set attributes
            request.setAttribute("userFeedbacks", userFeedbacks);
            request.setAttribute("currentUser", user);

            // Forward to JSP
            request.getRequestDispatcher("/user-feedback.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading your reviews");
            request.getRequestDispatcher("/user-feedback.jsp").forward(request, response);
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

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        if (account == null) {
            result.put("success", false);
            result.put("message", "Please log in to continue");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("update".equals(action)) {
                handleUpdateFeedback(request, response, account, result);
            } else if ("delete".equals(action)) {
                handleDeleteFeedback(request, response, account, result);
            } else {
                result.put("success", false);
                result.put("message", "Invalid action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "An error occurred: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    private void handleUpdateFeedback(HttpServletRequest request, HttpServletResponse response,
            Account account, Map<String, Object> result) throws Exception {

        // Get parameters
        String feedbackIdParam = request.getParameter("feedbackId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");
        boolean isAnonymous = "true".equals(request.getParameter("isAnonymous"));

        // Validate parameters
        if (feedbackIdParam == null || ratingParam == null) {
            result.put("success", false);
            result.put("message", "Missing required parameters");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdParam);
        int rating = Integer.parseInt(ratingParam);

        // Validate rating
        if (rating < 1 || rating > 5) {
            result.put("success", false);
            result.put("message", "Rating must be between 1 and 5");
            return;
        }

        // Validate comment length
        if (comment != null && comment.length() > 1000) {
            result.put("success", false);
            result.put("message", "Comment must be less than 1000 characters");
            return;
        }

        // Get user details
        User user = userDao.getUserByAccountId(account.getAccountID());
        if (user == null) {
            result.put("success", false);
            result.put("message", "User not found");
            return;
        }

        // Get existing feedback to verify ownership
        Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
        if (existingFeedback == null) {
            result.put("success", false);
            result.put("message", "Feedback not found");
            return;
        }

        // Check if user owns this feedback
        if (existingFeedback.getUserID() != user.getUserId()) {
            result.put("success", false);
            result.put("message", "You can only edit your own reviews");
            return;
        }

        // Update feedback
        existingFeedback.setRating(rating);
        existingFeedback.setComment(comment != null ? comment.trim() : "");
        existingFeedback.setAnonymous(isAnonymous);

        boolean success = feedbackDAO.updateFeedback(existingFeedback);

        if (success) {
            result.put("success", true);
            result.put("message", "Review updated successfully");
        } else {
            result.put("success", false);
            result.put("message", "Failed to update review");
        }
    }

    private void handleDeleteFeedback(HttpServletRequest request, HttpServletResponse response,
            Account account, Map<String, Object> result) throws Exception {

        String feedbackIdParam = request.getParameter("feedbackId");

        if (feedbackIdParam == null) {
            result.put("success", false);
            result.put("message", "Missing feedback ID");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdParam);

        // Get user details
        User user = userDao.getUserByAccountId(account.getAccountID());
        if (user == null) {
            result.put("success", false);
            result.put("message", "User not found");
            return;
        }

        // Get existing feedback to verify ownership
        Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
        if (existingFeedback == null) {
            result.put("success", false);
            result.put("message", "Feedback not found");
            return;
        }

        // Check if user owns this feedback
        if (existingFeedback.getUserID() != user.getUserId()) {
            result.put("success", false);
            result.put("message", "You can only delete your own reviews");
            return;
        }

        boolean success = feedbackDAO.deleteFeedback(feedbackId);

        if (success) {
            result.put("success", true);
            result.put("message", "Review deleted successfully");
        } else {
            result.put("success", false);
            result.put("message", "Failed to delete review");
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
