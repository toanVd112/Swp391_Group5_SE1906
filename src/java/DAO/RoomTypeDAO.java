package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
                        rs.getInt("roomCount") // Giả sử dùng roomCount làm availableRooms (cần điều chỉnh nếu khác)
                );
                rt.setImages(getImagesByRoomTypeId(rs.getInt("RoomTypeID")));
                list.add(rt);
            }
        } catch (SQLException e) {

            throw e;
        }
        return list;
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
}
