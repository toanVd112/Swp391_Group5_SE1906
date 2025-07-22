package DAO;

import java.util.*;
import java.sql.*;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;

/**
 * @author Arcueid
 */
public class ManageRoomDAO {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    public List<Room> getRoomsByPage(String search, String sort, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, rt.RoomTypeID "
                + "FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        boolean hasSearch = search != null && !search.trim().isEmpty();
        if (hasSearch) {
            sql.append(" AND r.RoomNumber LIKE ?");
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice ASC");
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice DESC");
        } else {
            sql.append(" ORDER BY r.RoomNumber ASC");
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasSearch) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType roomType = null;
                if (rs.getObject("RoomTypeID") != null) {
                    int roomTypeId = rs.getInt("RoomTypeID");
                    roomType = roomTypeDAO.getRoomTypeById(roomTypeId);
                }

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

    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT RoomTypeID FROM roomtypes ORDER BY Name";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int roomTypeId = rs.getInt("RoomTypeID");
                RoomType roomType = roomTypeDAO.getRoomTypeById(roomTypeId);
                list.add(roomType);
            }
        }
        return list;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.RoomTypeID FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE r.RoomID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomType roomType = null;
                if (rs.getObject("RoomTypeID") != null) {
                    int roomTypeId = rs.getInt("RoomTypeID");
                    roomType = roomTypeDAO.getRoomTypeById(roomTypeId);
                }

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

    public boolean isRoomNumberExists(String roomNumber, Integer excludeRoomId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE RoomNumber = ?";
        if (excludeRoomId != null) {
            sql += " AND RoomID != ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            if (excludeRoomId != null) {
                ps.setInt(2, excludeRoomId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addRoom(String roomNumber, int floor, int roomTypeId, String status) {
        String sql = "INSERT INTO rooms (RoomNumber, Floor, RoomTypeID, Status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ps.setInt(2, floor);
            ps.setInt(3, roomTypeId);
            ps.setString(4, status);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoom(int roomId, String roomNumber, int floor, int roomTypeId, String status) {
        String sql = "UPDATE rooms SET RoomNumber = ?, Floor = ?, RoomTypeID = ?, Status = ? WHERE RoomID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ps.setInt(2, floor);
            ps.setInt(3, roomTypeId);
            ps.setString(4, status);
            ps.setInt(5, roomId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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

    public List<RoomInspectionReport> getFilteredPendingRequests(String keyword, String sort, int page, int size, int accountID) {
        List<RoomInspectionReport> list = new ArrayList<>();
        String sql = "SELECT * FROM roominspectionreports WHERE IsRoomOk IS NULL AND StaffID = ?";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND RoomID LIKE ?";
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
            sql += " AND RoomID LIKE ?";
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
            sql += " AND RoomID LIKE ?";
        }

        sql += " ORDER BY RequestDate " + ("asc".equalsIgnoreCase(sort) ? "ASC" : "DESC");
        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, accountID);

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
            sql += " AND RoomID LIKE ?";
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

    public List<Room> getRoomsByPage(Integer roomTypeId, String status, String keyword, Integer minFloor, Integer maxFloor, Double minPrice, Double maxPrice, Integer minGuests, Integer maxGuests, String sort, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, rt.RoomTypeID, rt.Name AS RoomTypeName, rt.BasePrice, rt.Description, rt.MaxGuests "
                + "FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (roomTypeId != null) {
            sql.append(" AND r.RoomTypeID = ?");
            params.add(roomTypeId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ?");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND r.RoomNumber LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (minFloor != null) {
            sql.append(" AND r.Floor >= ?");
            params.add(minFloor);
        }
        if (maxFloor != null) {
            sql.append(" AND r.Floor <= ?");
            params.add(maxFloor);
        }
        if (minPrice != null) {
            sql.append(" AND rt.BasePrice >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND rt.BasePrice <= ?");
            params.add(maxPrice);
        }
        if (minGuests != null) {
            sql.append(" AND rt.MaxGuests >= ?");
            params.add(minGuests);
        }
        if (maxGuests != null) {
            sql.append(" AND rt.MaxGuests <= ?");
            params.add(maxGuests);
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice ASC");
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice DESC");
        } else {
            sql.append(" ORDER BY r.RoomNumber ASC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType roomType = null;
                if (rs.getObject("RoomTypeID") != null) {
                    roomType = new RoomType(
                            rs.getInt("RoomTypeID"),
                            rs.getString("RoomTypeName"),
                            rs.getString("Description"),
                            rs.getDouble("BasePrice"),
                            null, // imageUrl
                            null, // roomDetail
                            rs.getInt("MaxGuests")
                    );
                }
                Room room = new Room(
                        rs.getInt("RoomID"),
                        rs.getString("RoomNumber"),
                        rs.getInt("Floor"),
                        rs.getString("Status"),
                        roomType
                );
                list.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countRooms(Integer roomTypeId, String status, String keyword, Integer minFloor, Integer maxFloor, Double minPrice, Double maxPrice, Integer minGuests, Integer maxGuests) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (roomTypeId != null) {
            sql.append(" AND r.RoomTypeID = ?");
            params.add(roomTypeId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ?");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND r.RoomNumber LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (minFloor != null) {
            sql.append(" AND r.Floor >= ?");
            params.add(minFloor);
        }
        if (maxFloor != null) {
            sql.append(" AND r.Floor <= ?");
            params.add(maxFloor);
        }
        if (minPrice != null) {
            sql.append(" AND rt.BasePrice >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND rt.BasePrice <= ?");
            params.add(maxPrice);
        }
        if (minGuests != null) {
            sql.append(" AND rt.MaxGuests >= ?");
            params.add(minGuests);
        }
        if (maxGuests != null) {
            sql.append(" AND rt.MaxGuests <= ?");
            params.add(maxGuests);
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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

    public Map<Integer, String> getRoomIdToRoomNumberMap() throws SQLException {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT RoomID, RoomNumber FROM rooms";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("RoomID"), rs.getString("RoomNumber"));
            }
        }
        return map;
    }
}
