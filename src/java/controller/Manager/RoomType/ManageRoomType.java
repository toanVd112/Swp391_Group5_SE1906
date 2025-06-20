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
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            RoomType roomType = null;
            try {
                roomType = roomTypeDAO.getRoomTypeById(id);
                roomType.setAmenities(roomTypeDAO.getAmenitiesByRoomTypeId(id));
            } catch (SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("roomType", roomType);
        }
        request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");

    // 1. Nếu là thêm / xóa tiện ích thì xử lý và return sớm
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

        int roomTypeId = Integer.parseInt(roomTypeIdRaw.trim());
        Amenity amenity = new Amenity();
        amenity.setAmenityName(amenityName.trim());
        amenity.setIcon(icon.trim());
        RoomType rt = new RoomType();
        rt.setRoomTypeID(roomTypeId);
        amenity.setRoomType(rt);

        try {
            roomTypeDAO.insertAmenity(amenity);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Đã thêm tiện ích");
        } catch (SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi khi thêm tiện ích");
        }
        return;
    }

    if ("delete".equals(amenityAction)) {
        int amenityId = Integer.parseInt(request.getParameter("amenityId"));
        roomTypeDAO.deleteAmenityById(amenityId);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Đã xóa tiện ích");
        return;
    }

    // 2. Nếu không phải tiện ích thì mới xử lý loại phòng (form submit)
    String deleteImageIdRaw = request.getParameter("deleteImageId");
    if (deleteImageIdRaw != null) {
        int imageId = Integer.parseInt(deleteImageIdRaw);
        try {
            roomTypeDAO.deleteImageById(imageId);
        } catch (SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
        }
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Xóa ảnh thành công");
        return;
    }

    // Đến đây mới là xử lý form loại phòng
    String idRaw = request.getParameter("roomTypeID");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    double basePrice = Double.parseDouble(request.getParameter("basePrice"));
    String imageUrl = request.getParameter("imageUrl");
    String roomDetail = request.getParameter("roomDetail");

    List<RoomImage> images = new ArrayList<>();
    String[] imageUrls = request.getParameterValues("imageUrls[]");
    if (imageUrls != null) {
        for (String url : imageUrls) {
            if (url != null && !url.trim().isEmpty()) {
                images.add(new RoomImage(0, null, 0, url.trim(), false, ""));
            }
        }
    }

    RoomType type = new RoomType();
    type.setName(name);
    type.setDescription(description);
    type.setBasePrice(basePrice);
    type.setRoomDetail(roomDetail);
    type.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
    type.setImages(images);

    if (idRaw == null || idRaw.isEmpty()) {
        try {
            roomTypeDAO.insertRoomType(type);
        } catch (SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
        }
    } else {
        int id = Integer.parseInt(idRaw);
        type.setRoomTypeID(id);
        try {
            roomTypeDAO.updateRoomType(type);
        } catch (SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    response.sendRedirect("RoomTypeListServlet");
}

    @Override
    public String getServletInfo() {
        return "Manage room types (add/edit/delete images)";
    }
}
