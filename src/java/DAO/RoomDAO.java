/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.util.*;
import java.sql.*;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
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
        String sql = "SELECT *"
                + "FROM rooms WHERE 1=1";

        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND RoomNumber LIKE ?";
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
                Room room = new Room(
                        rs.getInt("RoomID"),
                        rs.getInt("roomTypeID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        rs.getString("RoomImage")
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
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void addRoom(int roomTypeID, String roomnumber, int floor, String status, String roomImage) {
        String sql = "INSERT INTO rooms (RoomTypeID, RoomNumber, Floor, Status, RoomImage)\n"
                + "VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomTypeID);
            ps.setString(2, roomnumber);
            ps.setInt(3, floor);
            ps.setString(4, status);
            ps.setString(5, roomImage);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void editRoom(int roomTypeID, String roomnumber, int floor, String status, String roomImage, String rid) {
        String sql = "Update rooms\n"
                + "Set RoomTypeID = ?,"
                + "RoomNumber = ?,"
                + "Floor = ?,"
                + "Status = ? ,"
                + "RoomImage = ?\n"
                + "Where RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeID);
            ps.setString(2, roomnumber);
            ps.setInt(3, floor);
            ps.setString(4, status);
            ps.setString(5, roomImage);
            ps.setString(6, rid);
            ps.executeUpdate();

        } catch (SQLException e) {
        }
    }

    public int getRoomIdByNumber(int roomNumber) throws Exception {
        String sql = "SELECT RoomID FROM rooms WHERE RoomNumber = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("RoomID");
            }
        }
        throw new Exception("Không tìm thấy phòng: " + roomNumber);
    }

    public List<RoomInspectionReport> getFilteredPendingRequests(String keyword, String sort, int page, int size, int accountID) {
        List<RoomInspectionReport> list = new ArrayList<>();
        String sql = "SELECT * FROM roominspectionreports WHERE IsRoomOk IS NULL AND StaffID = ?";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND Notes LIKE ?";
        }

        sql += " ORDER BY InspectionTime " + ("asc".equals(sort) ? "ASC" : "DESC");
        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;

            ps.setInt(paramIndex++, accountID);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }

            ps.setInt(paramIndex++, size);
            ps.setInt(paramIndex, (page - 1) * size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomInspectionReport r = new RoomInspectionReport();
                r.setReportID(rs.getInt("ReportID"));
                r.setBookingID(rs.getInt("BookingID"));
                r.setRoomID(rs.getInt("RoomID"));
                r.setStaffID(rs.getInt("StaffID"));
                r.setInspectionTime(rs.getTimestamp("InspectionTime"));
                r.setNotes(rs.getString("Notes"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countPendingRequests(String keyword) {
        String sql = "SELECT COUNT(*) FROM roominspectionreports WHERE IsRoomOk IS NULL";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND Notes LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
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

    public boolean updateInspectionReport(int reportID, boolean isRoomOk, String notes) {
        String sql = "UPDATE roominspectionreports SET IsRoomOk = ?, Notes = ? WHERE ReportID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isRoomOk);
            ps.setString(2, notes);
            ps.setInt(3, reportID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<MaintenanceRequest> getMaintenanceRequests(String search, String sort, int offset, int limit, int accountID) {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceRequests WHERE IsResolved = false AND StaffID = ?";

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND Description LIKE ?";
        }

        sql += " ORDER BY RequestDate " + ("asc".equalsIgnoreCase(sort) ? "ASC" : "DESC");
        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, accountID); // ✅ lọc theo StaffID

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }

            ps.setInt(idx++, limit);
            ps.setInt(idx, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceRequest r = new MaintenanceRequest(
                        rs.getInt("RequestID"),
                        rs.getInt("RoomID"),
                        rs.getInt("StaffID"),
                        rs.getTimestamp("RequestDate"),
                        rs.getString("Description"),
                        rs.getBoolean("IsResolved"),
                        rs.getTimestamp("ResolutionDate")
                );
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countMaintenanceRequests(String search, int accountID) {
        String sql = "SELECT COUNT(*) FROM MaintenanceRequests WHERE IsResolved = false AND StaffID = ?";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND Description LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, accountID);

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx, "%" + search.trim() + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void markAsResolved(int requestID) {
        String sql = "UPDATE MaintenanceRequests SET IsResolved = true, ResolutionDate = NOW() WHERE RequestID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
