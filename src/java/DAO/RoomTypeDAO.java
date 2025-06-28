package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Amenity;
import model.RoomImage;
import model.RoomType;

public class RoomTypeDAO {

    public RoomType getRoomTypeById(int id) throws SQLException {
        String sql = "SELECT * FROM roomtypes WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail"),
                        0
                );
                roomType.setImages(getImagesByRoomTypeId(id));
                return roomType;
            }
        }
        return null;
    }

    public int insertRoomType(RoomType type) throws SQLException {
        String sql = "INSERT INTO roomtypes (Name, Description, BasePrice, RoomTypeImage, RoomDetail, MaxGuests) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.setInt(6, type.getMaxGuests());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Insert failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Trả về RoomTypeID mới
                } else {
                    throw new SQLException("Insert failed, no ID obtained.");
                }
            }
        }
    }

    public void updateRoomType(RoomType type) throws SQLException {
        String sql = "UPDATE roomtypes SET Name = ?, Description = ?, BasePrice = ?, RoomTypeImage = ?, RoomDetail = ?, MaxGuests = ? WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.setInt(6, type.getMaxGuests()); // 🟢 dòng cần thêm
            ps.setInt(7, type.getRoomTypeID());
            ps.executeUpdate();
        }
        deleteImagesByRoomTypeId(type.getRoomTypeID());
        insertImages(type.getRoomTypeID(), type.getImages());
    }

    public boolean deleteRoomType(int roomTypeId) throws SQLException {
        if (hasOccupiedRooms(roomTypeId)) {
            return false;
        }

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            deleteAmenitiesByRoomTypeId(conn, roomTypeId);
            deleteImagesByRoomTypeId(conn, roomTypeId);
            deleteRoomsByRoomTypeId(conn, roomTypeId);

            String sql = "DELETE FROM roomtypes WHERE RoomTypeID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, roomTypeId);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private boolean hasOccupiedRooms(int roomTypeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE RoomTypeID = ? AND Status = 'occupied'";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void deleteAmenitiesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomamenities WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    private void deleteImagesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        Connection localConn = (conn != null) ? conn : DBConnect.getConnection();
        try {
            String categorySql = "DELETE FROM roomimage_categories WHERE RoomTypeID = ?";
            try (PreparedStatement psCat = localConn.prepareStatement(categorySql)) {
                psCat.setInt(1, roomTypeId);
                psCat.executeUpdate();
            }

            String imageSql = "DELETE FROM roomimages WHERE RoomTypeID = ?";
            try (PreparedStatement psImg = localConn.prepareStatement(imageSql)) {
                psImg.setInt(1, roomTypeId);
                psImg.executeUpdate();
            }
        } finally {
            if (conn == null && localConn != null) {
                localConn.close();
            }
        }
    }

    private void deleteRoomsByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE RoomTypeID = ? AND Status != 'occupied'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    public int getOccupiedRoomsCount(int roomTypeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE RoomTypeID = ? AND Status = 'occupied'";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<RoomImage> getImagesByRoomTypeId(int roomTypeId) throws SQLException {
        List<RoomImage> images = new ArrayList<>();
        String sql = "SELECT * FROM roomimages WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomImage img = new RoomImage(
                        rs.getInt("ImageID"),
                        roomTypeId,
                        rs.getString("ImageUrl"),
                        rs.getBoolean("IsPrimary")
                );
                img.setCategories(getImageCategories(img.getImageID(), roomTypeId));
                images.add(img);
            }
        }
        return images;
    }

    public void insertImages(int roomTypeId, List<RoomImage> images) throws SQLException {
        if (images == null || images.isEmpty()) {
            return;
        }

        String imageSql = "INSERT INTO roomimages (ImageUrl, IsPrimary, RoomTypeID) VALUES (?, ?, ?)";
        String categorySql = "INSERT INTO roomimage_categories (ImageID, RoomTypeID, CategoryName) VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement imagePs = null;
        PreparedStatement categoryPs = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            imagePs = conn.prepareStatement(imageSql, Statement.RETURN_GENERATED_KEYS);
            categoryPs = conn.prepareStatement(categorySql);

            for (RoomImage img : images) {
                imagePs.setString(1, img.getImageUrl());
                imagePs.setBoolean(2, img.isPrimary());
                imagePs.setInt(3, roomTypeId);
                imagePs.executeUpdate();

                try (ResultSet rs = imagePs.getGeneratedKeys()) {
                    if (rs.next()) {
                        int imageId = rs.getInt(1);
                        if (img.getCategories() != null) {
                            for (String category : img.getCategories()) {
                                categoryPs.setInt(1, imageId);
                                categoryPs.setInt(2, roomTypeId);
                                categoryPs.setString(3, category);
                                categoryPs.addBatch();
                            }
                        }
                    }
                }
            }

            categoryPs.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (imagePs != null) {
                imagePs.close();
            }
            if (categoryPs != null) {
                categoryPs.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public void deleteImagesByRoomTypeId(int roomTypeId) throws SQLException {
        Connection conn = null; // ✅ Khai báo conn ở đây
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            deleteImagesByRoomTypeId(conn, roomTypeId);

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public void deleteImageById(int imageId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String categorySql = "DELETE FROM roomimage_categories WHERE ImageID = ?";
            try (PreparedStatement psCat = conn.prepareStatement(categorySql)) {
                psCat.setInt(1, imageId);
                psCat.executeUpdate();
            }

            String imageSql = "DELETE FROM roomimages WHERE ImageID = ?";
            try (PreparedStatement psImg = conn.prepareStatement(imageSql)) {
                psImg.setInt(1, imageId);
                psImg.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<RoomType> searchRoomTypes(String keyword, double minPrice, double maxPrice, String sortBy, int offset, int limit) throws SQLException {
        List<RoomType> list = new ArrayList<>();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder(
                "SELECT rt.*, COUNT(r.RoomID) AS roomCount "
                + "FROM roomtypes rt "
                + "LEFT JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID "
                + "WHERE rt.BasePrice BETWEEN ? AND ?"
        );

        if (hasKeyword) {
            sql.append(" AND rt.Name LIKE ?");
        }

        sql.append(" GROUP BY rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail ");
        switch (sortBy != null ? sortBy : "") {
            case "name":
                sql.append(" ORDER BY rt.Name ASC");
                break;
            case "price":
                sql.append(" ORDER BY rt.BasePrice ASC");
                break;
            case "roomCount":
                sql.append(" ORDER BY roomCount DESC");
                break;
            default:
                sql.append(" ORDER BY rt.RoomTypeID DESC");
        }
        sql.append(" LIMIT ?, ?");

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setDouble(index++, minPrice);
            ps.setDouble(index++, maxPrice);
            if (hasKeyword) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }
            ps.setInt(index++, offset);
            ps.setInt(index, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType rt = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail"),
                        rs.getInt("roomCount")
                );
                rt.setImages(getImagesByRoomTypeId(rs.getInt("RoomTypeID")));
                list.add(rt);
            }
        } catch (SQLException e) {
            throw e;
        }
        return list;
    }

    public int getRoomCountByRoomTypeId(int roomTypeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countRoomTypes(String keyword, double minPrice, double maxPrice) throws SQLException {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM roomtypes WHERE BasePrice BETWEEN ? AND ?");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND Name LIKE ?");
        }
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setDouble(index++, minPrice);
            ps.setDouble(index++, maxPrice);
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index, "%" + keyword + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw e;
        }
        return count;
    }

    public List<Amenity> getAmenitiesByRoomTypeId(int roomTypeId) throws SQLException {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT RoomAmenityID, AmenityName, Icon FROM roomamenities WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Amenity a = new Amenity();
                a.setAmenityId(rs.getInt("RoomAmenityID"));
                a.setAmenityName(rs.getString("AmenityName"));
                a.setIcon(rs.getString("Icon"));
                list.add(a);
            }
        }
        return list;
    }

    public void insertAmenity(Amenity amenity) throws SQLException {
        String sql = "INSERT INTO roomamenities (RoomTypeID, AmenityName, Icon) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, amenity.getRoomType().getRoomTypeID());
            ps.setString(2, amenity.getAmenityName());
            ps.setString(3, amenity.getIcon());
            ps.executeUpdate();
        }
    }

    public void deleteAmenityById(int amenityId) {
        String sql = "DELETE FROM roomamenities WHERE RoomAmenityID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, amenityId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<RoomType> getAvailableRoomTypes(Date checkin, Date checkout,
            String roomTypeFilter, Integer minGuests, Double maxPrice) throws SQLException {
        List<RoomType> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.MaxGuests, rt.RoomTypeImage, rt.RoomDetail,
               COUNT(r.RoomID) AS AvailableRooms
        FROM roomtypes rt
        JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID
        WHERE r.Status = 'Available'
          AND r.RoomID NOT IN (
              SELECT bd.RoomID
              FROM bookingdetails bd
              JOIN bookings b ON bd.BookingID = b.BookingID
              WHERE b.CheckOutDate > ? AND b.CheckInDate < ?
          )
    """);

        if (roomTypeFilter != null && !roomTypeFilter.isBlank()) {
            sql.append(" AND rt.Name = ?");
        }
        if (minGuests != null) {
            sql.append(" AND rt.MaxGuests >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND rt.BasePrice <= ?");
        }

        sql.append("""
        GROUP BY rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.MaxGuests, rt.RoomTypeImage, rt.RoomDetail
    """);

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setDate(index++, checkin);
            ps.setDate(index++, checkout);

            if (roomTypeFilter != null && !roomTypeFilter.isBlank()) {
                ps.setString(index++, roomTypeFilter);
            }
            if (minGuests != null) {
                ps.setInt(index++, minGuests);
            }
            if (maxPrice != null) {
                ps.setDouble(index++, maxPrice);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeID(rs.getInt("RoomTypeID"));
                rt.setName(rs.getString("Name"));
                rt.setDescription(rs.getString("Description"));
                rt.setBasePrice(rs.getDouble("BasePrice"));
                rt.setMaxGuests(rs.getInt("MaxGuests"));
                rt.setImageUrl(rs.getString("RoomTypeImage"));
                rt.setAvailableRooms(rs.getInt("AvailableRooms"));
                rt.setImages(getImagesByRoomTypeId(rs.getInt("RoomTypeID")));
                list.add(rt);
            }
        }

        return list;
    }

    public void deleteCategoriesByRoomTypeId(int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomtype_categories WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM roomtypes";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeID(rs.getInt("RoomTypeID"));
                rt.setName(rs.getString("Name"));
                list.add(rt);
            }
        }
        return list;
    }

    // Quản lý category
    public void addCategoryToRoomType(int roomTypeId, String categoryName) throws SQLException {
        String sql = "INSERT IGNORE INTO roomtype_categories (RoomTypeID, CategoryName) VALUES (?, ?)"; // IGNORE duplicates
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setString(2, categoryName.trim());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                System.out.println("Category already exists or insert failed: RoomTypeID=" + roomTypeId + ", CategoryName=" + categoryName);
            } else {
                System.out.println("Added category: RoomTypeID=" + roomTypeId + ", CategoryName=" + categoryName);
            }
        } catch (SQLException e) {
            System.err.println("Error adding category: " + e.getMessage());
            throw e;
        }
    }

    public void deleteCategoryFromRoomType(int roomTypeId, String categoryName) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String sqlImg = "DELETE FROM roomimage_categories WHERE RoomTypeID = ? AND CategoryName = ?";
            try (PreparedStatement psImg = conn.prepareStatement(sqlImg)) {
                psImg.setInt(1, roomTypeId);
                psImg.setString(2, categoryName.trim());
                psImg.executeUpdate();
            }

            String sqlCat = "DELETE FROM roomtype_categories WHERE RoomTypeID = ? AND CategoryName = ?";
            try (PreparedStatement psCat = conn.prepareStatement(sqlCat)) {
                psCat.setInt(1, roomTypeId);
                psCat.setString(2, categoryName.trim());
                int rowsAffected = psCat.executeUpdate();
                if (rowsAffected == 0) {
                    System.out.println("No category found to delete: RoomTypeID=" + roomTypeId + ", CategoryName=" + categoryName);
                } else {
                    System.out.println("Deleted category: RoomTypeID=" + roomTypeId + ", CategoryName=" + categoryName);
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            System.err.println("Error deleting category: " + e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<String> getCategoriesByRoomTypeId(int roomTypeId) throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CategoryName FROM roomtype_categories WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(rs.getString("CategoryName").trim());
                }
            }
        }
        return categories;
    }

    public void addCategoryToImage(int imageId, int roomTypeId, String categoryName) throws SQLException {
        String sql = "INSERT INTO roomimage_categories (ImageID, RoomTypeID, CategoryName) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.setInt(2, roomTypeId);
            ps.setString(3, categoryName);
            ps.executeUpdate();
        }
    }

    public void removeCategoryFromImage(int imageId, int roomTypeId, String categoryName) throws SQLException {
        String sql = "DELETE FROM roomimage_categories WHERE ImageID = ? AND RoomTypeID = ? AND CategoryName = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.setInt(2, roomTypeId);
            ps.setString(3, categoryName);
            ps.executeUpdate();
        }
    }

    public List<String> getImageCategories(int imageId, int roomTypeId) throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CategoryName FROM roomimage_categories WHERE ImageID = ? AND RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.setInt(2, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("CategoryName"));
            }
        }
        return categories;
    }

    public static void main(String[] args) {
        try {
            RoomTypeDAO dao = new RoomTypeDAO();

            Date checkin = Date.valueOf("2025-06-25");
            Date checkout = Date.valueOf("2025-06-28");
            String roomTypeFilter = "";
            Integer minGuests = 5;
            Double maxPrice = 600.0;

            List<RoomType> roomTypes = dao.getAvailableRoomTypes(checkin, checkout, roomTypeFilter, minGuests, maxPrice);

            for (RoomType rt : roomTypes) {
                System.out.println("RoomType: " + rt.getName());
                System.out.println(" - Max Guests: " + rt.getMaxGuests());
                System.out.println(" - Price: " + rt.getBasePrice());
                System.out.println(" - Available Rooms: " + rt.getAvailableRooms());
                System.out.println("-----------");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
