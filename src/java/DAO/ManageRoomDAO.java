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

    // === EXISTING METHODS (Updated for better functionality) ===
    
    public List<Room> getRoomsByPage(String search, String sort, int offset, int limit) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail " +
            "FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID WHERE 1=1"
        );

        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql.append(" AND r.RoomNumber LIKE ?");
        }

        // Fix the sorting - need to reference the correct table aliases
        if ("asc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice ASC");
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY rt.BasePrice DESC");
        } else {
            sql.append(" ORDER BY r.RoomNumber ASC");
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (hasSearch) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Create RoomType object if exists
                RoomType roomType = null;
                if (rs.getObject("RoomTypeID") != null) {
                    roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("TypeName"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                    );
                }

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

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // === NEW METHODS FOR ADD/EDIT FUNCTIONALITY ===

    /**
     * Get all room types for dropdown
     */
    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM roomtypes ORDER BY Name";
        
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                RoomType roomType = new RoomType(
                    rs.getInt("RoomTypeID"),
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

    /**
     * Get a room by ID for editing
     */
    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail " +
                    "FROM rooms r LEFT JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                    "WHERE r.RoomID = ?";
        
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Create RoomType object if exists
                RoomType roomType = null;
                if (rs.getObject("RoomTypeID") != null) {
                    roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("TypeName"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                    );
                }
                
                Room room = new Room(
                    rs.getInt("RoomID"),
                    rs.getString("RoomNumber"),
                    rs.getInt("Floor"),
                    rs.getString("Status"),
                    rs.getString("RoomImage"),
                    roomType
                );
                
                // Load detail images
               room.setRoomImage(rs.getString("RoomImage"));
                room.setDetailImageUrls(getRoomDetailImages(roomId));
                
                return room;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Check if room number already exists
     */
    public boolean isRoomNumberExists(String roomNumber, Integer excludeRoomId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE RoomNumber = ?";
        if (excludeRoomId != null) {
            sql += " AND RoomID != ?";
        }
        
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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

    /**
     * Add a new room with image URLs (Updated method)
     */
    public boolean addRoom(String roomNumber, int floor, int roomTypeId, String status, 
                          String mainImageUrl, List<String> detailImageUrls) {
        String sql = "INSERT INTO rooms (RoomNumber, Floor, RoomTypeID, Status, RoomImage) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            
            // Insert room
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, roomNumber);
                ps.setInt(2, floor);
                ps.setInt(3, roomTypeId);
                ps.setString(4, status);
                ps.setString(5, mainImageUrl);
                
                int result = ps.executeUpdate();
                
                if (result > 0) {
                    // Get generated room ID
                    ResultSet generatedKeys = ps.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int roomId = generatedKeys.getInt(1);
                        
                        // Insert detail images if any
                        if (detailImageUrls != null && !detailImageUrls.isEmpty()) {
                            insertRoomDetailImages(conn, roomId, detailImageUrls);
                        }
                        
                        conn.commit();
                        return true;
                    }
                }
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing room (Updated method)
     */
    public boolean updateRoom(int roomId, String roomNumber, int floor, int roomTypeId, String status, 
                             String mainImageUrl, List<String> detailImageUrls) {
        String sql = "UPDATE rooms SET RoomNumber = ?, Floor = ?, RoomTypeID = ?, Status = ?, RoomImage = ? WHERE RoomID = ?";
        
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            
            // Update room
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, roomNumber);
                ps.setInt(2, floor);
                ps.setInt(3, roomTypeId);
                ps.setString(4, status);
                ps.setString(5, mainImageUrl);
                ps.setInt(6, roomId);
                
                int result = ps.executeUpdate();
                
                if (result > 0) {
                    // Delete existing detail images
                    deleteRoomDetailImages(conn, roomId);
                    
                    // Insert new detail images
                    if (detailImageUrls != null && !detailImageUrls.isEmpty()) {
                        insertRoomDetailImages(conn, roomId, detailImageUrls);
                    }
                    
                    conn.commit();
                    return true;
                }
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete room (Updated method)
     */
    public boolean deleteRoom(int roomId) {
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            
            // Delete room images first
            deleteRoomDetailImages(conn, roomId);
            
            // Delete room
            String sql = "DELETE FROM rooms WHERE RoomID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, roomId);
                int result = ps.executeUpdate();
                
                if (result > 0) {
                    conn.commit();
                    return true;
                }
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // === HELPER METHODS FOR IMAGE MANAGEMENT ===

    /**
     * Get room detail images
     */
    private List<String> getRoomDetailImages(int roomId) {
        List<String> imageUrls = new ArrayList<>();
        String sql = "SELECT ImageUrl FROM room_images WHERE RoomID = ? AND IsPrimary = false ORDER BY ImageID";
        
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                imageUrls.add(rs.getString("ImageUrl"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imageUrls;
    }

    /**
     * Insert room detail images
     */
    private void insertRoomDetailImages(Connection conn, int roomId, List<String> imageUrls) throws SQLException {
        String sql = "INSERT INTO room_images (RoomID, ImageUrl, IsPrimary) VALUES (?, ?, false)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String imageUrl : imageUrls) {
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    ps.setInt(1, roomId);
                    ps.setString(2, imageUrl.trim());
                    ps.addBatch();
                }
            }
            ps.executeBatch();
        }
    }

    /**
     * Delete room detail images
     */
    private void deleteRoomDetailImages(Connection conn, int roomId) throws SQLException {
        String sql = "DELETE FROM room_images WHERE RoomID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.executeUpdate();
        }
    }

    // === LEGACY METHODS (Updated for compatibility) ===

    /**
     * Legacy addRoom method - kept for backward compatibility
     */
    public void addRoom(int roomTypeID, String roomnumber, int floor, String status, String roomImage) {
        addRoom(roomnumber, floor, roomTypeID, status, roomImage, null);
    }

    /**
     * Legacy editRoom method - kept for backward compatibility
     */
    public void editRoom(int roomTypeID, String roomnumber, int floor, String status, String roomImage, String rid) {
        try {
            int roomId = Integer.parseInt(rid);
            updateRoom(roomId, roomnumber, floor, roomTypeID, status, roomImage, null);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    /**
     * Legacy deleteRoom method - kept for backward compatibility
     */
    public void deleteRoom(String rid) {
        try {
            int roomId = Integer.parseInt(rid);
            deleteRoom(roomId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    // === KEEP ALL YOUR EXISTING METHODS ===

    public int getRoomIdByNumber(int roomNumber) throws Exception {
        String sql = "SELECT RoomID FROM rooms WHERE RoomNumber = ?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
            sql += " AND Description LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}