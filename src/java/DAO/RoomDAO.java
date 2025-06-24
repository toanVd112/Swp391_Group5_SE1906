package DAO;

import java.util.*;
import java.sql.*;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;
import model.RoomTypeOccupancy;

/**
 *
 * @author Arcueid
 */
public class RoomDAO {

    // --- Lấy danh sách phòng có lọc, sắp xếp, phân trang ---
    public List<Room> getRooms(Integer floor, Integer typeId, String sortFloor, String sortPrice, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail, rt.MaxGuests "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        if (floor != null) {
            sql.append(" AND r.Floor = ?");
        }
        if (typeId != null) {
            sql.append(" AND r.RoomTypeID = ?");
        }

        // ORDER BY nhiều điều kiện nếu có
        if ("asc".equalsIgnoreCase(sortFloor)) {
            sql.append(" ORDER BY r.Floor ASC");
        } else if ("desc".equalsIgnoreCase(sortFloor)) {
            sql.append(" ORDER BY r.Floor DESC");
        } else if ("asc".equalsIgnoreCase(sortPrice)) {
            sql.append(" ORDER BY rt.BasePrice ASC");
        } else if ("desc".equalsIgnoreCase(sortPrice)) {
            sql.append(" ORDER BY rt.BasePrice DESC");
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
                        rs.getString("RoomDetail"),
                        rs.getInt("MaxGuests")
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

    // --- Lấy tất cả loại phòng ---
    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM roomtypes";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail"),
                        rs.getInt("MaxGuests")
                );
                list.add(roomType);
            }
        }
        return list;
    }

    // --- Lấy tất cả các tầng ---
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

    // --- Lấy phòng mới nhất ---
    public Room getLatestRoom() {
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail, rt.MaxGuests "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                + "ORDER BY r.RoomID DESC LIMIT 1";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("TypeName"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail"),
                        rs.getInt("MaxGuests")
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

    // --- Lấy thống kê tỷ lệ lấp đầy phòng theo loại phòng ---
    public List<RoomTypeOccupancy> getRoomOccupancyStatistics() {
        List<RoomTypeOccupancy> occupancyList = new ArrayList<>();
        String sql = "SELECT rt.RoomTypeID, rt.Name AS TypeName, " +
                     "SUM(CASE WHEN r.Status = 'Occupied' THEN 1 ELSE 0 END) AS occupiedRooms, " +
                     "COUNT(r.RoomID) AS totalRooms " +
                     "FROM roomtypes rt " +
                     "LEFT JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID " +
                     "GROUP BY rt.RoomTypeID, rt.Name";

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                RoomTypeOccupancy occupancy = new RoomTypeOccupancy();
                occupancy.setRoomTypeID(rs.getInt("RoomTypeID"));
                occupancy.setTypeName(rs.getString("TypeName"));
                occupancy.setOccupiedRooms(rs.getInt("occupiedRooms"));
                occupancy.setTotalRooms(rs.getInt("totalRooms"));
                
                double rate = occupancy.getTotalRooms() > 0 
                    ? (occupancy.getOccupiedRooms() * 100.0) / occupancy.getTotalRooms() 
                    : 0.0;
                occupancy.setOccupancyRate(Math.round(rate * 100.0) / 100.0); // Round to 2 decimals
                
                occupancyList.add(occupancy);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return occupancyList;
    }
}
