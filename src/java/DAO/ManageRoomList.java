/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author Admin
 */
import DAO.DBConnect;
import model.Room;
import model.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Room2;
import model.RoomType;

public class ManageRoomList {

    /**
     * Lấy danh sách RoomType để đổ vào combobox
     */
    public List<RoomType> getRoomTypes() throws SQLException {
        String sql = "SELECT RoomTypeID, Name FROM RoomTypes ORDER BY Name";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            List<RoomType> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new RoomType(rs.getInt("RoomTypeID"), rs.getString("Name")));
            }
            return list;
        }
    }

    /**
     * Tìm/lọc phòng theo: - roomTypeId (nullable) - status (nullable) - số
     * phòng chứa keyword (nullable) - floor from-to (nullable) - price from-to
     * (nullable)
     */
    public List<Room2> searchRooms(
            Integer roomTypeId,
            String status,
            String keyword,
            Integer minFloor,
            Integer maxFloor,
            Double minPrice,
            Double maxPrice
    ) throws SQLException {
        String sql = """
            SELECT r.RoomID, r.RoomNumber, r.Floor, r.Status,
                   rt.RoomTypeID, rt.Name AS RoomTypeName, rt.BasePrice
            FROM Rooms r
            JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
            WHERE (? IS NULL OR r.RoomTypeID = ?)
              AND (? IS NULL OR r.Status     = ?)
              AND (? IS NULL OR r.RoomNumber LIKE CONCAT('%',?, '%'))
              AND (? IS NULL OR r.Floor      >= ?)
              AND (? IS NULL OR r.Floor      <= ?)
              AND (? IS NULL OR rt.BasePrice >= ?)
              AND (? IS NULL OR rt.BasePrice <= ?)
            ORDER BY r.RoomNumber
        """;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1-2: roomTypeId
            ps.setObject(1, roomTypeId);
            ps.setObject(2, roomTypeId);
            // 3-4: status
            ps.setObject(3, status);
            ps.setObject(4, status);
            // 5-6: keyword
            ps.setObject(5, keyword);
            ps.setObject(6, keyword);
            // 7-8: minFloor
            ps.setObject(7, minFloor);
            ps.setObject(8, minFloor);
            // 9-10: maxFloor
            ps.setObject(9, maxFloor);
            ps.setObject(10, maxFloor);
            // 11-12: minPrice
            ps.setObject(11, minPrice);
            ps.setObject(12, minPrice);
            // 13-14: maxPrice
            ps.setObject(13, maxPrice);
            ps.setObject(14, maxPrice);

            ResultSet rs = ps.executeQuery();
            List<Room2> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new Room2(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getInt("RoomTypeID"),
                        rs.getString("RoomTypeName"),
                        rs.getDouble("BasePrice")
                ));
            }
            return list;
        }
    }

    public int countRooms(
            Integer roomTypeId,
            String status,
            String keyword,
            Integer minFloor,
            Integer maxFloor,
            Double minPrice,
            Double maxPrice
    ) throws SQLException {
        String sql = """
        SELECT COUNT(*) AS Total
        FROM Rooms r
        JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
        WHERE (? IS NULL OR r.RoomTypeID = ?)
          AND (? IS NULL OR r.Status     = ?)
          AND (? IS NULL OR r.RoomNumber LIKE CONCAT('%',?, '%'))
          AND (? IS NULL OR r.Floor      >= ?)
          AND (? IS NULL OR r.Floor      <= ?)
          AND (? IS NULL OR rt.BasePrice >= ?)
          AND (? IS NULL OR rt.BasePrice <= ?)
    """;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, roomTypeId);
            ps.setObject(2, roomTypeId);
            ps.setObject(3, status);
            ps.setObject(4, status);
            ps.setObject(5, keyword);
            ps.setObject(6, keyword);
            ps.setObject(7, minFloor);
            ps.setObject(8, minFloor);
            ps.setObject(9, maxFloor);
            ps.setObject(10, maxFloor);
            ps.setObject(11, minPrice);
            ps.setObject(12, minPrice);
            ps.setObject(13, maxPrice);
            ps.setObject(14, maxPrice);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Total");
            }
        }

        return 0;
    }

    public List<Room2> searchRoomsPaginated(
            Integer roomTypeId,
            String status,
            String keyword,
            Integer minFloor,
            Integer maxFloor,
            Double minPrice,
            Double maxPrice,
            int offset,
            int limit
    ) throws SQLException {
        String sql = """
        SELECT r.RoomID, r.RoomNumber, r.Floor, r.Status,
               rt.RoomTypeID, rt.Name AS RoomTypeName, rt.BasePrice
        FROM Rooms r
        JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
        WHERE (? IS NULL OR r.RoomTypeID = ?)
          AND (? IS NULL OR r.Status     = ?)
          AND (? IS NULL OR r.RoomNumber LIKE CONCAT('%',?, '%'))
          AND (? IS NULL OR r.Floor      >= ?)
          AND (? IS NULL OR r.Floor      <= ?)
          AND (? IS NULL OR rt.BasePrice >= ?)
          AND (? IS NULL OR rt.BasePrice <= ?)
        ORDER BY r.RoomNumber
        LIMIT ? OFFSET ?
    """;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, roomTypeId);
            ps.setObject(2, roomTypeId);
            ps.setObject(3, status);
            ps.setObject(4, status);
            ps.setObject(5, keyword);
            ps.setObject(6, keyword);
            ps.setObject(7, minFloor);
            ps.setObject(8, minFloor);
            ps.setObject(9, maxFloor);
            ps.setObject(10, maxFloor);
            ps.setObject(11, minPrice);
            ps.setObject(12, minPrice);
            ps.setObject(13, maxPrice);
            ps.setObject(14, maxPrice);
            ps.setInt(15, limit);
            ps.setInt(16, offset);

            ResultSet rs = ps.executeQuery();
            List<Room2> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new Room2(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getInt("RoomTypeID"),
                        rs.getString("RoomTypeName"),
                        rs.getDouble("BasePrice")
                ));
            }
            return list;
        }
    }

}
