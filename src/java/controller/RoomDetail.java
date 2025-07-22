package controller;

import DAO.FeedbackDAO;
import DAO.RoomDetailDAO;
import DAO.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RoomType;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Feedback;
import model.User;

@WebServlet(name = "RoomDetail", urlPatterns = {"/RoomDetail"})
public class RoomDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID loại phòng");
                return;
            }

            int roomTypeId;
            try {
                roomTypeId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID loại phòng không hợp lệ");
                return;
            }

            RoomDetailDAO roomDao = new RoomDetailDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            UserDao userDao = new UserDao();

            // Get room type details
            RoomType roomType = roomDao.getRoomTypeDetailById(roomTypeId);
            if (roomType == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy loại phòng");
                return;
            }

            // Get room availability and categories
            int availableRooms = roomDao.getAvailableRoomsCount(roomTypeId);
            List<String> categories = roomDao.getCategoriesByRoomTypeId(roomTypeId);

            // Get feedback data using updated FeedbackDAO
            List<Feedback> feedbacks;
            double avgRating;
            int[] ratingDistribution;
            int totalReviews = 0;

            try {
                feedbacks = feedbackDAO.getFeedbackByRoomType(roomTypeId);
                avgRating = feedbackDAO.getAverageRating(roomTypeId);
                ratingDistribution = feedbackDAO.getRatingDistribution(roomTypeId);

                // Calculate total reviews
                for (int count : ratingDistribution) {
                    totalReviews += count;
                }
            } catch (Exception e) {
                e.printStackTrace();
                feedbacks = java.util.Collections.emptyList();
                avgRating = 0.0;
                ratingDistribution = new int[5];
            }

            // Check user login and booking status
            boolean hasBooked = false;
            boolean canSubmitFeedback = false;
            Integer bookingID = null;
            User currentUser = null;

            HttpSession session = request.getSession(false);
            if (session != null) {
               Object obj = session.getAttribute("account"); 

                if (obj instanceof Account) {
                    Account account = (Account) obj;

                    try {
                        // Get user details
                        currentUser = userDao.getUserByAccountId(account.getAccountID());

                        if (currentUser != null) {
                            // Check if user has any completed bookings for this room type
                            List<Feedback> reviewableBookings = feedbackDAO.getReviewableBookings(currentUser.getUserId());

                            for (Feedback reviewable : reviewableBookings) {
                                if (reviewable.getRoomTypeID() == roomTypeId) {
                                    hasBooked = true;
                                    canSubmitFeedback = true;
                                    bookingID = reviewable.getBookingID();
                                    break;
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    // Keep user in session
                    session.setAttribute("user", account);
                    request.setAttribute("currentUser", currentUser);
                }
            }

            // Set all attributes for JSP
            request.setAttribute("roomType", roomType);
            request.setAttribute("images", roomType.getImages());
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("amenities", roomType.getAmenities());
            request.setAttribute("categories", categories);
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("avgRating", Math.round(avgRating * 10.0) / 10.0);
            request.setAttribute("ratingDistribution", ratingDistribution);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("hasBookedThisRoomType", hasBooked);
            request.setAttribute("canSubmitFeedback", canSubmitFeedback);
            request.setAttribute("bookingID", bookingID);

            // Handle success/error messages
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null) {
                switch (error) {
                    case "unauthorized":
                        request.setAttribute("errorMessage", "You must have completed a booking for this room type to submit a review.");
                        break;
                    case "500":
                        request.setAttribute("errorMessage", "An error occurred while submitting your review. Please try again.");
                        break;
                    default:
                        request.setAttribute("errorMessage", "An error occurred.");
                }
            }
            if ("true".equals(success)) {
                request.setAttribute("successMessage", "Your review has been submitted successfully!");
            }

            request.getRequestDispatcher("/rooms-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải thông tin loại phòng: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST không được hỗ trợ.");
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị thông tin chi tiết một loại phòng";
    }
}
