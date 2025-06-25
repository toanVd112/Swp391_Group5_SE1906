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

    public void insertRoomType(RoomType type) throws SQLException {
        String sql = "INSERT INTO roomtypes (Name, Description, BasePrice, RoomTypeImage, RoomDetail) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int roomTypeId = rs.getInt(1);
                insertImages(roomTypeId, type.getImages());
            }
        }
    }

    public void updateRoomType(RoomType type) throws SQLException {
        String sql = "UPDATE roomtypes SET Name = ?, Description = ?, BasePrice = ?, RoomTypeImage = ?, RoomDetail = ? WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.setInt(6, type.getRoomTypeID());
            ps.executeUpdate();
        }
        deleteImagesByRoomTypeId(type.getRoomTypeID());
        insertImages(type.getRoomTypeID(), type.getImages());
    }

    /**
     * Xóa loại phòng - kiểm tra điều kiện không có phòng occupied
     *
     * @param roomTypeId ID của loại phòng cần xóa
     * @return true nếu xóa thành công, false nếu không thể xóa do có phòng
     * occupied
     * @throws SQLException
     */
    public boolean deleteRoomType(int roomTypeId) throws SQLException {
        // Kiểm tra xem có phòng nào của loại này đang occupied không
        if (hasOccupiedRooms(roomTypeId)) {
            return false; // Không thể xóa vì có phòng đang occupied
        }

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Xóa amenities của room type
            deleteAmenitiesByRoomTypeId(conn, roomTypeId);

            // Xóa images của room type
            deleteImagesByRoomTypeId(conn, roomTypeId);

            // Xóa các phòng thuộc loại này (nếu không có booking active)
            deleteRoomsByRoomTypeId(conn, roomTypeId);

            // Cuối cùng xóa room type
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

    /**
     * Kiểm tra xem loại phòng có phòng đang occupied không
     */
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

    /**
     * Xóa tất cả amenities của room type
     */
    private void deleteAmenitiesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomamenities WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    /**
     * Xóa images với connection được truyền vào (cho transaction)
     */
    private void deleteImagesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomimages WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    /**
     * Xóa các phòng thuộc loại này (chỉ những phòng không occupied)
     */
    private void deleteRoomsByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE RoomTypeID = ? AND Status != 'occupied'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy thông tin về số phòng occupied của loại phòng
     */
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
                        (Integer) rs.getObject("RoomID"),
                        roomTypeId,
                        rs.getString("ImageUrl"),
                        rs.getBoolean("IsPrimary"),
                        rs.getString("Category")
                );
                images.add(img);
            }
        }
        return images;
    }

    public void insertImages(int roomTypeId, List<RoomImage> images) throws SQLException {
        if (images == null || images.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO roomimages (RoomID, ImageUrl, IsPrimary, Category, RoomTypeID) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (RoomImage img : images) {
                ps.setObject(1, img.getRoomID());
                ps.setString(2, img.getImageUrl());
                ps.setBoolean(3, img.isPrimary());
                ps.setString(4, img.getCategory());
                ps.setInt(5, roomTypeId);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public void deleteImagesByRoomTypeId(int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomimages WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    public void deleteImageById(int imageId) throws SQLException {
        String sql = "DELETE FROM roomimages WHERE ImageID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
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

    // Tiện ích
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

    public List<RoomType> getAvailableRoomTypes(Date checkin, Date checkout, String roomTypeFilter, Integer minGuests, Double maxPrice) throws SQLException {
        List<RoomType> list = new ArrayList<>();

        String sql = """
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
             AND (? IS NULL OR rt.Name = ?)
             AND (? IS NULL OR rt.MaxGuests >= ?)
             AND (? IS NULL OR rt.BasePrice <= ?)
           GROUP BY rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.MaxGuests, rt.RoomTypeImage, rt.RoomDetail
        """;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, checkin);
            ps.setDate(2, checkout);

            ps.setString(3, roomTypeFilter);        // 1st ?
            ps.setString(4, roomTypeFilter);        // 2nd ?

            if (minGuests == null) {
                ps.setNull(5, Types.INTEGER);
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(5, minGuests);
                ps.setInt(6, minGuests);
            }

            if (maxPrice == null) {
                ps.setNull(7, Types.DOUBLE);
                ps.setNull(8, Types.DOUBLE);
            } else {
                ps.setDouble(7, maxPrice);
                ps.setDouble(8, maxPrice);
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
                list.add(rt);
            }
        }

        return list;
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
}
