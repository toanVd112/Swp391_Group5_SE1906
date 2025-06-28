package controller.Manager.RoomType;

import DAO.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RoomType;
import model.RoomImage;
import model.Amenity;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ManageRoomType", urlPatterns = {"/ManageRoomType"})
public class ManageRoomType extends HttpServlet {

    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            RoomType roomType = new RoomType(); // Tránh null

            if (idParam != null && !idParam.isBlank()) {
                int id = Integer.parseInt(idParam);
                roomType = roomTypeDAO.getRoomTypeById(id);

                if (roomType != null) {
                    roomType.setAmenities(roomTypeDAO.getAmenitiesByRoomTypeId(id));
                    roomType.setCategoryList(roomTypeDAO.getCategoriesByRoomTypeId(id));
                    roomType.setImages(roomTypeDAO.getImagesByRoomTypeId(id)); // ✅ Load ảnh chi tiết
                } else {
                    roomType = new RoomType(); // fallback
                }
            }

            request.setAttribute("roomType", roomType);
            request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Lỗi khi tải thông tin loại phòng: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String maxGuestsRaw = request.getParameter("maxGuests");
        String deleteImageIdRaw = request.getParameter("deleteImageId");
        if (deleteImageIdRaw != null) {
            try {
                int imageId = Integer.parseInt(deleteImageIdRaw);
                roomTypeDAO.deleteImageById(imageId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Xóa ảnh thành công");
            } catch (SQLException ex) {
                Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, null, ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi xóa ảnh");
            }
            return;
        }

        String idRaw = request.getParameter("roomTypeID");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        String imageUrl = request.getParameter("imageUrl");
        String roomDetail = request.getParameter("roomDetail");
        String categorySync = request.getParameter("categorySync");

        RoomType type = new RoomType();
        type.setName(name);
        type.setDescription(description);
        type.setBasePrice(basePrice);
        type.setRoomDetail(roomDetail);
        type.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

// Thêm đoạn này:
        int maxGuests = 0;
        try {
            if (maxGuestsRaw != null && !maxGuestsRaw.isBlank()) {
                maxGuests = Integer.parseInt(maxGuestsRaw.trim());
            }
        } catch (NumberFormatException e) {
            maxGuests = 0;
        }
        type.setMaxGuests(maxGuests);
        // Ảnh chi tiết
        String[] imageUrls = request.getParameterValues("imageUrls[]");
        List<RoomImage> images = new ArrayList<>();
        if (imageUrls != null) {
            for (int i = 0; i < imageUrls.length; i++) {
                String url = imageUrls[i];
                if (url != null && !url.trim().isEmpty()) {
                    RoomImage img = new RoomImage();
                    img.setImageUrl(url.trim());

                    List<String> catList = new ArrayList<>();
                    String[] cats = request.getParameterValues("imageCategories" + i);
                    if (cats != null) {
                        for (String c : cats) {
                            if (!c.trim().isEmpty()) {
                                catList.add(c.trim());
                            }
                        }
                    }
                    img.setCategories(catList);
                    images.add(img);
                }
            }
        }
        type.setImages(images);

        // Tiện ích
        List<Amenity> amenities = new ArrayList<>();
        String[] amenityNames = request.getParameterValues("amenityNames[]");
        String[] amenityIcons = request.getParameterValues("amenityIcons[]");
        if (amenityNames != null && amenityIcons != null) {
            for (int i = 0; i < amenityNames.length; i++) {
                if (!amenityNames[i].isBlank()) {
                    Amenity a = new Amenity();
                    a.setAmenityName(amenityNames[i]);
                    a.setIcon(amenityIcons[i]);
                    a.setRoomType(type);
                    amenities.add(a);
                }
            }
        }
        type.setAmenities(amenities);

        // Danh mục
        List<String> categoryList = new ArrayList<>();
        String[] categories = request.getParameterValues("categoryList[]");
        if (categories != null) {
            for (String cat : categories) {
                if (!cat.isBlank()) {
                    categoryList.add(cat.trim());
                }
            }
        }
        if (categoryList.isEmpty() && categorySync != null && !categorySync.isEmpty()) {
            categoryList.addAll(List.of(categorySync.split(",")));
        }
        type.setCategoryList(categoryList);

        try {
            int roomTypeId;

            if (idRaw == null || idRaw.isEmpty()) {
                roomTypeId = roomTypeDAO.insertRoomType(type); // ✅ Trả về RoomTypeID mới
                type.setRoomTypeID(roomTypeId);
            } else {
                roomTypeId = Integer.parseInt(idRaw);
                type.setRoomTypeID(roomTypeId);
            }

            // ➤ Thêm danh mục trước
            List<String> currentCategories = roomTypeDAO.getCategoriesByRoomTypeId(roomTypeId);
            for (String cat : categoryList) {
                if (!currentCategories.contains(cat)) {
                    roomTypeDAO.addCategoryToRoomType(roomTypeId, cat);
                    Logger.getLogger(ManageRoomType.class.getName()).info("Added category: " + cat);
                }
            }
            for (String cat : currentCategories) {
                if (!categoryList.contains(cat)) {
                    roomTypeDAO.deleteCategoryFromRoomType(roomTypeId, cat);
                    Logger.getLogger(ManageRoomType.class.getName()).info("Removed category: " + cat);
                }
            }

            // ➤ Sau đó update RoomType để thêm ảnh, tiện ích
            roomTypeDAO.updateRoomType(type);

        } catch (SQLException ex) {
            Logger.getLogger(ManageRoomType.class.getName()).log(Level.SEVERE, "Lỗi khi lưu loại phòng: ", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi khi lưu thông tin: " + ex.getMessage());
            return;
        }

        response.sendRedirect("RoomTypeListServlet");
    }

    @Override
    public String getServletInfo() {
        return "Manage room types (add/edit/delete images, amenities, categories)";
    }
}
