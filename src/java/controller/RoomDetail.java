package controller;

import DAO.FeedbackDAO;
import DAO.RoomDetailDAO;
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

            RoomType roomType = roomDao.getRoomTypeDetailById(roomTypeId);
            if (roomType == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy loại phòng");
                return;
            }

            int availableRooms = roomDao.getAvailableRoomsCount(roomTypeId);
            List<String> categories = roomDao.getCategoriesByRoomTypeId(roomTypeId);

            List<Feedback> feedbacks;
            double avgRating;
            Map<Integer, Integer> ratingMap;

            try {
                feedbacks = feedbackDAO.getFeedbacksByRoomType(roomTypeId);
                avgRating = feedbackDAO.getAverageRatingByRoomType(roomTypeId);
                ratingMap = feedbackDAO.getRatingDistribution(roomTypeId);
            } catch (Exception e) {
                e.printStackTrace();
                feedbacks = java.util.Collections.emptyList();
                avgRating = 0.0;
                ratingMap = java.util.Collections.emptyMap();
            }

            boolean hasBooked = false;
            Integer bookingID = null;

            HttpSession session = request.getSession(false);
            if (session != null) {
                // Đồng bộ với LoginCustomerServlet: sessionScope.user = Account
                Object obj = session.getAttribute("user");

                if (obj instanceof Account) {
                    Account account = (Account) obj;
                    int userID = account.getAccountID();

                    bookingID = feedbackDAO.getAnyBookingIDForUser(userID, roomTypeId);
                    hasBooked = bookingID != null;

                    // Duy trì "user" trong sessionScope để JSP nhận diện
                    session.setAttribute("user", account);

                    // Truyền bookingID để JSP hiển thị
                    request.setAttribute("bookingID", bookingID != null ? bookingID : "");
                }
            }

            // Truyền toàn bộ dữ liệu cần thiết sang JSP
            request.setAttribute("roomType", roomType);
            request.setAttribute("images", roomType.getImages());
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("amenities", roomType.getAmenities());
            request.setAttribute("categories", categories);
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("ratingMap", ratingMap);
            request.setAttribute("hasBookedThisRoomType", hasBooked);
            request.setAttribute("bookingID", bookingID);
            request.setAttribute("error", request.getParameter("error"));
            request.setAttribute("success", request.getParameter("success"));

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
