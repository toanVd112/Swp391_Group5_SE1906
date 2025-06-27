package controller.Manager.RoomType;

import DAO.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RoomType;
import model.RoomImage;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Amenity;

@WebServlet(name = "ManageRoomType", urlPatterns = {"/ManageRoomType"})
public class ManageRoomType extends HttpServlet {

    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                RoomType roomType = roomTypeDAO.getRoomTypeById(id);
                if (roomType != null) {
                    request.setAttribute("roomType", roomType);
                } else {
                    request.setAttribute("error", "Không tìm thấy loại phòng!");
                }
            } catch (NumberFormatException | SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("error", "Lỗi khi lấy thông tin loại phòng!");
            }
        }
        request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        // 1. Xử lý thêm/xóa tiện ích
        String amenityAction = request.getParameter("amenityAction");
        if ("add".equals(amenityAction)) {
            String amenityName = request.getParameter("amenityName");
            String icon = request.getParameter("icon");
            String roomTypeIdRaw = request.getParameter("roomTypeID");

            if (amenityName == null || icon == null || roomTypeIdRaw == null
                    || amenityName.trim().isEmpty() || icon.trim().isEmpty() || roomTypeIdRaw.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Thiếu dữ liệu tiện ích!");
                return;
            }

            try {
                int roomTypeId = Integer.parseInt(roomTypeIdRaw.trim());
                Amenity amenity = new Amenity();
                amenity.setAmenityName(amenityName.trim());
                amenity.setIcon(icon.trim());
                RoomType rt = new RoomType();
                rt.setRoomTypeID(roomTypeId);
                amenity.setRoomType(rt);

                roomTypeDAO.insertAmenity(amenity);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Đã thêm tiện ích");
            } catch (NumberFormatException | SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi thêm tiện ích");
            }
            return;
        }

        if ("delete".equals(amenityAction)) {
            String amenityIdRaw = request.getParameter("amenityId");
            if (amenityIdRaw == null || amenityIdRaw.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Thiếu ID tiện ích!");
                return;
            }

            try {
                int amenityId = Integer.parseInt(amenityIdRaw);
                roomTypeDAO.deleteAmenityById(amenityId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Đã xóa tiện ích");
            } catch (NumberFormatException | SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi xóa tiện ích");
            }
            return;
        }

        // 2. Xử lý xóa ảnh
        String deleteImageIdRaw = request.getParameter("deleteImageId");
        if (deleteImageIdRaw != null && !deleteImageIdRaw.trim().isEmpty()) {
            try {
                int imageId = Integer.parseInt(deleteImageIdRaw);
                roomTypeDAO.deleteImageById(imageId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Xóa ảnh thành công");
            } catch (NumberFormatException | SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi xóa ảnh");
            }
            return;
        }

        // 3. Xử lý form loại phòng
        String idRaw = request.getParameter("roomTypeID");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String basePriceRaw = request.getParameter("basePrice");
        String imageUrl = request.getParameter("imageUrl");
        String roomDetail = request.getParameter("roomDetail");
        String maxGuestsRaw = request.getParameter("maxGuests");

        // Validation
        if (name == null || name.trim().isEmpty() || basePriceRaw == null || basePriceRaw.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Tên loại phòng và giá cơ bản là bắt buộc!");
            return;
        }

        double basePrice;
        int maxGuests;
        try {
            basePrice = Double.parseDouble(basePriceRaw.trim());
            maxGuests = maxGuestsRaw != null && !maxGuestsRaw.trim().isEmpty() ? Integer.parseInt(maxGuestsRaw.trim()) : 0;
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Giá cơ bản hoặc số khách tối đa không hợp lệ!");
            return;
        }

        // Xử lý danh sách ảnh chi tiết
        List<RoomImage> images = new ArrayList<>();
        String[] imageUrls = request.getParameterValues("imageUrls[]");
        String[] categories = request.getParameterValues("categories[]");
        if (imageUrls != null && categories != null && imageUrls.length == categories.length) {
            for (int i = 0; i < imageUrls.length; i++) {
                if (imageUrls[i] != null && !imageUrls[i].trim().isEmpty()) {
                    RoomImage img = new RoomImage();
                    img.setImageUrl(imageUrls[i].trim());
                    img.setPrimary(false); // Chỉ ảnh đại diện là primary
                    img.setCategory(categories[i] != null ? categories[i].trim() : "Default");
                    images.add(img);
                }
            }
        }

        RoomType type = new RoomType();
        type.setName(name.trim());
        type.setDescription(description != null ? description.trim() : "");
        type.setBasePrice(basePrice);
        type.setRoomDetail(roomDetail != null ? roomDetail.trim() : "");
        type.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        type.setMaxGuests(maxGuests);
        type.setImages(images);

        try {
            if (idRaw == null || idRaw.trim().isEmpty()) {
                roomTypeDAO.insertRoomType(type);
            } else {
                int id = Integer.parseInt(idRaw);
                type.setRoomTypeID(id);
                roomTypeDAO.updateRoomType(type);
            }
            response.sendRedirect("RoomTypeListServlet");
        } catch (NumberFormatException | SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi khi lưu loại phòng");
        }
    }

    @Override
    public String getServletInfo() {
        return "Manage room types (add/edit/delete images)";
    }
}
