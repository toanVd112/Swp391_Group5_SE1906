package controller.Manager.RoomType;

import DAO.DBConnect;
import DAO.RoomTypeDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RoomType;
import model.RoomImage;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ManageRoomType", urlPatterns = {"/ManageRoomType"})
public class ManageRoomType extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManageRoomType.class.getName());
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                RoomType roomType = roomTypeDAO.getRoomTypeById(id);
                request.setAttribute("roomType", roomType);
            } catch (NumberFormatException | SQLException e) {
                LOGGER.severe("Lỗi khi lấy thông tin loại phòng ID=" + idParam + ": " + e.getMessage());
                request.setAttribute("error", "Lỗi khi lấy thông tin loại phòng");
            }
        }
        request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        RoomType type = new RoomType();
        List<RoomImage> images = new ArrayList<>();

        // Lấy dữ liệu từ form
        String idRaw = request.getParameter("roomTypeID");
        String name = request.getParameter("name");
        String description = request.getParameter("description"); // lấy từ input hidden
        String basePriceRaw = request.getParameter("basePrice");
        String imageUrl = request.getParameter("imageUrl"); // Nhập URL thủ công
        String roomDetail = request.getParameter("roomDetail"); // giữ lại nếu có mô tả thủ công

        // Debug log
        System.out.println("Tên loại phòng: " + name);
        System.out.println("Giá: " + basePriceRaw);
        System.out.println("Mô tả: " + description);
        System.out.println("Chi tiết: " + roomDetail);
        System.out.println("Ảnh: " + imageUrl);

        try {
            if (basePriceRaw == null || basePriceRaw.isEmpty()) {
                throw new NumberFormatException("Giá không được để trống");
            }

            double basePrice = Double.parseDouble(basePriceRaw);

            type.setName(name);
            type.setDescription(description);
            type.setBasePrice(basePrice);
            type.setRoomDetail(roomDetail);

            // Lấy danh sách URL ảnh chi tiết
            String[] imageUrls = request.getParameterValues("imageUrls");

            if (imageUrls != null && imageUrls.length > 0) {
                type.setImageUrl(imageUrls[0].trim()); // Ảnh đầu tiên làm đại diện
                for (String url : imageUrls) {
                    if (url != null && !url.trim().isEmpty()) {
                        images.add(new RoomImage(0, null, type.getRoomTypeID(), url.trim(), false, ""));
                    }
                }
            } else {
                type.setImageUrl(""); // Nếu không có ảnh chi tiết
            }

            type.setImages(images);

            if (idRaw == null || idRaw.isEmpty()) {
                // Thêm mới
                try {
                    roomTypeDAO.insertRoomType(type);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi thêm loại phòng: ", ex);
                    request.setAttribute("error", "Không thể thêm loại phòng: " + ex.getMessage());
                    request.getRequestDispatcher("roomTypeManagement.jsp").forward(request, response);
                    return;
                }
            } else {
                // Cập nhật
                try {
                    int id = Integer.parseInt(idRaw);
                    type.setRoomTypeID(id);
                    roomTypeDAO.updateRoomType(type);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật loại phòng: ", ex);
                    request.setAttribute("error", "Không thể cập nhật loại phòng: " + ex.getMessage());
                    request.getRequestDispatcher("roomTypeManagement.jsp").forward(request, response);
                    return;
                }
            }

            // Thành công
            response.sendRedirect("Manager/manager.jsp?page=ListRoomType.jsp");

        } catch (NumberFormatException e) {
            LOGGER.severe("Lỗi khi xử lý dữ liệu: " + e.getMessage());
            request.setAttribute("error", "Giá không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("roomTypeManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageIdParam = request.getParameter("imageId");
        if (imageIdParam != null) {
            try {
                int imageId = Integer.parseInt(imageIdParam);
                String sql = "DELETE FROM roomimages WHERE ImageID = ?";
                try (java.sql.Connection conn = DBConnect.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, imageId);
                    ps.executeUpdate();
                }
                request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.severe("Lỗi xóa ảnh ID=" + imageIdParam + ": " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xóa ảnh");
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Manage room types (add/edit)";
    }
}
