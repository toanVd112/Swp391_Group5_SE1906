package DAO;

import java.sql.Date;
import java.sql.*;
import java.util.*;
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
                        rs.getInt("MaxGuests")
                );
                roomType.setImages(getImagesByRoomTypeId(id));
                roomType.setAmenities(getAmenitiesByRoomTypeId(id));
                roomType.setCategoryList(getCategoriesByRoomTypeId(id));
                return roomType;
            }
        }
        return null;
    }

    public boolean insertFullRoomType(RoomType type) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String insertRoomTypeSql = "INSERT INTO roomtypes (Name, Description, BasePrice, RoomTypeImage, RoomDetail, MaxGuests) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertRoomTypeSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, type.getName());
                ps.setString(2, type.getDescription());
                ps.setDouble(3, type.getBasePrice());
                ps.setString(4, type.getImageUrl());
                ps.setString(5, type.getRoomDetail());
                ps.setInt(6, type.getMaxGuests());
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    type.setRoomTypeID(rs.getInt(1));
                }
            }

            insertCategories(conn, type);
            insertAmenities(conn, type);
            insertImages(conn, type);

            conn.commit();
            return true;

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

    public boolean updateFullRoomType(RoomType type) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE roomtypes SET Name=?, Description=?, BasePrice=?, RoomTypeImage=?, RoomDetail=?, MaxGuests=? WHERE RoomTypeID=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, type.getName());
                ps.setString(2, type.getDescription());
                ps.setDouble(3, type.getBasePrice());
                ps.setString(4, type.getImageUrl());
                ps.setString(5, type.getRoomDetail());
                ps.setInt(6, type.getMaxGuests());
                ps.setInt(7, type.getRoomTypeID());
                ps.executeUpdate();
            }

            deleteCategoriesByRoomTypeId(type.getRoomTypeID());
            insertCategories(conn, type);

            deleteAmenitiesByRoomTypeId(conn, type.getRoomTypeID());
            insertAmenities(conn, type);

            deleteImagesByRoomTypeId(conn, type.getRoomTypeID());
            insertImages(conn, type);

            conn.commit();
            return true;

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

    private void insertCategories(Connection conn, RoomType type) throws SQLException {
        if (type.getCategoryList() != null && !type.getCategoryList().isEmpty()) {
            String sql = "INSERT INTO roomtype_categories (RoomTypeID, CategoryName) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (String cat : type.getCategoryList()) {
                    ps.setInt(1, type.getRoomTypeID());
                    ps.setString(2, cat.trim());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        }
    }

    private void insertAmenities(Connection conn, RoomType type) throws SQLException {
        if (type.getAmenities() != null && !type.getAmenities().isEmpty()) {
            String sql = "INSERT INTO roomamenities (RoomTypeID, AmenityName, Icon) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Amenity a : type.getAmenities()) {
                    ps.setInt(1, type.getRoomTypeID());
                    ps.setString(2, a.getAmenityName());
                    ps.setString(3, a.getIcon());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        }
    }

    private void insertImages(Connection conn, RoomType type) throws SQLException {
        if (type.getImages() != null && !type.getImages().isEmpty()) {
            String sqlImg = "INSERT INTO roomimages (ImageUrl, IsPrimary, RoomTypeID) VALUES (?, ?, ?)";
            String sqlCat = "INSERT INTO roomimage_categories (ImageID, RoomTypeID, CategoryName) VALUES (?, ?, ?)";

            try (PreparedStatement psImg = conn.prepareStatement(sqlImg, Statement.RETURN_GENERATED_KEYS); PreparedStatement psCat = conn.prepareStatement(sqlCat)) {

                for (RoomImage img : type.getImages()) {
                    psImg.setString(1, img.getImageUrl());
                    psImg.setBoolean(2, img.isPrimary());
                    psImg.setInt(3, type.getRoomTypeID());
                    psImg.executeUpdate();

                    try (ResultSet rs = psImg.getGeneratedKeys()) {
                        if (rs.next()) {
                            int imageId = rs.getInt(1);
                            if (img.getCategories() != null) {
                                for (String cat : img.getCategories()) {
                                    psCat.setInt(1, imageId);
                                    psCat.setInt(2, type.getRoomTypeID());
                                    psCat.setString(3, cat.trim());
                                    psCat.addBatch();
                                }
                            }
                        }
                    }
                }
                psCat.executeBatch();
            }
        }
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

    public List<String> getCategoriesByRoomTypeId(int roomTypeId) throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CategoryName FROM roomtype_categories WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("CategoryName"));
            }
        }
        return categories;
    }

    public void deleteCategoriesByRoomTypeId(int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomtype_categories WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    public void deleteAmenitiesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM roomamenities WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
    }

    private void deleteImagesByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sqlCat = "DELETE FROM roomimage_categories WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlCat)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }

        String sqlImg = "DELETE FROM roomimages WHERE RoomTypeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlImg)) {
            ps.setInt(1, roomTypeId);
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

    private void deleteRoomsByRoomTypeId(Connection conn, int roomTypeId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE RoomTypeID = ? AND Status != 'occupied'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.executeUpdate();
        }
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
}
