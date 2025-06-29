package controller;

import DAO.RoomDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RoomType;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RoomDetail", urlPatterns = {"/RoomDetail"})
public class RoomDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy ID loại phòng từ request
            int roomTypeId = Integer.parseInt(request.getParameter("id"));

            RoomDetailDAO dao = new RoomDetailDAO();

            // Lấy thông tin loại phòng
            RoomType roomType = dao.getRoomTypeDetailById(roomTypeId);

            if (roomType == null) {
                throw new ServletException("Không tìm thấy loại phòng với ID = " + roomTypeId);
            }
          int availableRooms = dao.getAvailableRoomsCount(roomTypeId);
            List<String> categories = dao.getCategoriesByRoomTypeId(roomTypeId);

            // Truyền dữ liệu sang view
            request.setAttribute("roomType", roomType);
            request.setAttribute("images", roomType.getImages());
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("amenities", roomType.getAmenities());
            request.setAttribute("categories", categories);

            // Hiển thị trang chi tiết
            request.getRequestDispatcher("/rooms-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải thông tin loại phòng: " + e.getMessage());
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
