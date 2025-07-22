package DAO;

import java.util.*;
import java.sql.*;
import model.CartRoom;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;
import model.RoomTypeOccupancy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * @author Arcueid
 */
public class RoomDAO {
    private static final Logger LOGGER = Logger.getLogger(RoomDAO.class.getName());
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
                        roomType
                );
                list.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getMaxGuests() {
        int maxGuests = 1; // default value
        String query = "SELECT MAX(MaxGuests) FROM roomtypes";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                maxGuests = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return maxGuests;
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
        String sql = "SELECT rt.RoomTypeID, rt.Name AS TypeName, "
                + "SUM(CASE WHEN r.Status = 'Occupied' THEN 1 ELSE 0 END) AS occupiedRooms, "
                + "COUNT(r.RoomID) AS totalRooms "
                + "FROM roomtypes rt "
                + "LEFT JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID "
                + "GROUP BY rt.RoomTypeID, rt.Name";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

    // --- Lấy thống kê tỷ lệ lấp đầy phòng theo ngày/tháng/năm ---
    public List<RoomTypeOccupancy> getRoomOccupancyStatisticsByPeriod(String periodType, String periodValue) {
        List<RoomTypeOccupancy> occupancyList = new ArrayList<>();
        String sql = "SELECT rt.RoomTypeID, rt.Name AS TypeName, "
                + "COUNT(DISTINCT res.RoomID) AS occupiedRooms, "
                + "COUNT(DISTINCT r.RoomID) AS totalRooms "
                + "FROM roomtypes rt "
                + "LEFT JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID "
                + "LEFT JOIN reservations res ON r.RoomID = res.RoomID ";

        if ("day".equalsIgnoreCase(periodType)) {
            sql += "AND DATE(res.CheckInDate) = ? ";
        } else if ("month".equalsIgnoreCase(periodType)) {
            sql += "AND DATE_FORMAT(res.CheckInDate, '%Y-%m') = ? ";
        } else if ("year".equalsIgnoreCase(periodType)) {
            sql += "AND YEAR(res.CheckInDate) = ? ";
        }

        sql += "GROUP BY rt.RoomTypeID, rt.Name";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (periodType != null && periodValue != null) {
                ps.setString(1, periodValue);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RoomTypeOccupancy occupancy = new RoomTypeOccupancy();
                occupancy.setRoomTypeID(rs.getInt("RoomTypeID"));
                occupancy.setTypeName(rs.getString("TypeName"));
                occupancy.setOccupiedRooms(rs.getInt("occupiedRooms"));
                occupancy.setTotalRooms(rs.getInt("totalRooms"));

                double rate = occupancy.getTotalRooms() > 0
                        ? (occupancy.getOccupiedRooms() * 100.0) / occupancy.getTotalRooms()
                        : 0.0;
                occupancy.setOccupancyRate(Math.round(rate * 100.0) / 100.0);
                occupancyList.add(occupancy);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return occupancyList;
    }

    public int getAvailableRoomCount(String roomTypeId) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE RoomTypeID = ? AND Status = 'Available'";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CartRoom> getCartByAccountId(int accountId) {
        List<CartRoom> list = new ArrayList<>();
        String sql = "SELECT rt.RoomTypeID, rt.Name AS RoomName, rt.BasePrice, rt.RoomTypeImage AS imageUrl, "
                + "rt.MaxGuests, "
                + "(SELECT COUNT(*) FROM Rooms r WHERE r.RoomTypeID = rt.RoomTypeID AND r.Status = 'Available') AS availableQuantity "
                + "FROM CartRooms c "
                + "JOIN RoomTypes rt ON c.RoomTypeID = rt.RoomTypeID "
                + "WHERE c.AccountID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartRoom room = new CartRoom();
                room.setRoomTypeId(rs.getInt("RoomTypeID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setBasePrice(rs.getDouble("BasePrice"));
                room.setImageUrl(rs.getString("imageUrl"));
                room.setMaxguest(rs.getInt("MaxGuests"));
                room.setAvailableQuantity(rs.getInt("availableQuantity"));
                list.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateRoomStatus(int roomID, String status) {
        String sql = "UPDATE rooms SET Status = ? WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomID);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warning("Không có dòng nào được cập nhật cho RoomID: " + roomID);
            } else {
                LOGGER.info("Cập nhật trạng thái thành công cho RoomID: " + roomID);
            }
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi cập nhật trạng thái cho RoomID " + roomID + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // --- Lấy thông tin phòng dựa trên RoomNumber ---
    public Room getRoomByNumber(String roomnumber) {
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail, rt.MaxGuests "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                + "WHERE r.RoomNumber = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomnumber);
            try (ResultSet rs = ps.executeQuery()) {
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
                            roomType
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // --- Lấy danh sách phòng sẵn sàng ---
    public List<Room> getAvailableRooms() throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail, rt.MaxGuests "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                + "WHERE r.Status = 'Available'";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
                        roomType
                );
                list.add(room);
            }
        }
        return list;
    }
}
