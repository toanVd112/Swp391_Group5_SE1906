/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.util.*;
import java.sql.*;
import model.Room;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
public class RoomDAO {

    // --- Lấy danh sách phòng có lọc, sắp xếp, phân trang ---
    public List<Room> getRooms(Integer floor, Integer typeId, String sortFloor, String sortPrice, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        if (floor != null) {
            sql.append(" AND r.Floor = ?");
        }
        if (typeId != null) {
            sql.append(" AND r.RoomTypeID = ?");
        }

        // ORDER BY nhiều điều kiện nếu có
        List<String> orderList = new ArrayList<>();
        if ("asc".equalsIgnoreCase(sortFloor)) {
            orderList.add("r.Floor ASC");
        } else if ("desc".equalsIgnoreCase(sortFloor)) {
            orderList.add("r.Floor DESC");
        }

        if ("asc".equalsIgnoreCase(sortPrice)) {
            orderList.add("rt.BasePrice ASC");
        } else if ("desc".equalsIgnoreCase(sortPrice)) {
            orderList.add("rt.BasePrice DESC");
        }

        if (!orderList.isEmpty()) {
            sql.append(" ORDER BY ").append(String.join(", ", orderList));
        } else {
            sql.append(" ORDER BY r.Floor ASC"); // mặc định
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (floor != null) {
                ps.setInt(index++, floor);
            }
            if (typeId != null) {
                ps.setInt(index++, typeId);
            }
            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("TypeName"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                );
                Room room = new Room(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getString("RoomImage"),
                        roomType
                );
                list.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // --- Đếm số phòng có áp dụng bộ lọc ---
    public int countRoomsByFilter(Integer floor, Integer typeId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM rooms WHERE 1=1");

        if (floor != null) {
            sql.append(" AND Floor = ?");
        }
        if (typeId != null) {
            sql.append(" AND RoomTypeID = ?");
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (floor != null) {
                ps.setInt(index++, floor);
            }
            if (typeId != null) {
                ps.setInt(index++, typeId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ---  ---
    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM roomtypes";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomtypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                );
                list.add(roomType);
            }
        }
        return list;
    }

    public List<Integer> getAllFloors() throws SQLException {
        List<Integer> floors = new ArrayList<>();
        String sql = "SELECT DISTINCT Floor FROM rooms ORDER BY Floor";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                floors.add(rs.getInt("Floor"));
            }
        }
        return floors;
    }

    public Room getLatestRoom() {
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                + "ORDER BY r.RoomID DESC LIMIT 1";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                );
                return new Room(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getString("RoomImage"),
                        roomType
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Room> getRoomsByPage(String search, String sort, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1";

        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND r.RoomNumber LIKE ?";
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY rt.BasePrice ASC";
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY rt.BasePrice DESC";
        }

        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (hasSearch) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("TypeName"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                );

                Room room = new Room(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getString("RoomImage"),
                        roomType
                );

                list.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countRooms(String search) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE 1=1";

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND RoomNumber LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void deleteRoom(String rid) {
        String sql = "DELETE FROM rooms WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rid);
            ps.executeUpdate();
        } catch (Exception e){
            e.printStackTrace();
        }

    }
}
