package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.MaintenanceRequest;

public class MaintenanceRequestDAO1 {

    public List<MaintenanceRequest> getPendingRequests(String search, String sort, int offset, int limit) {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceRequests WHERE IsResolved = false";
        if (search != null && !search.isEmpty()) {
            sql += " AND Description LIKE ? ";
        }
        if ("asc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY RequestDate ASC";
        } else {
            sql += " ORDER BY RequestDate DESC";
        }
        sql += " LIMIT ? OFFSET ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceRequest req = new MaintenanceRequest();
                    req.setRequestID(rs.getInt("RequestID"));
                    req.setRoomID(rs.getInt("RoomID"));
                    req.setStaffID(rs.getInt("StaffID"));
                    req.setRequestDate(rs.getTimestamp("RequestDate"));
                    req.setDescription(rs.getString("Description"));
                    req.setIsResolved(rs.getBoolean("IsResolved"));
                    req.setResolutionDate(rs.getTimestamp("ResolutionDate"));
                    list.add(req);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int getTotalPendingRequests(String search) {
        String sql = "SELECT COUNT(*) FROM MaintenanceRequests WHERE IsResolved = false";
        if (search != null && !search.isEmpty()) {
            sql += " AND Description LIKE ?";
        }
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (search != null && !search.isEmpty()) {
                ps.setString(1, "%" + search + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
//    public List<MaintenanceRequest> getAllRequests() {
//        List<MaintenanceRequest> list = new ArrayList<>();
//        String sql = "SELECT * FROM MaintenanceRequests ORDER BY RequestDate DESC";
//
//        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                MaintenanceRequest req = new MaintenanceRequest();
//                req.setRequestID(rs.getInt("RequestID"));
//                req.setRoomID(rs.getInt("RoomID"));
//                req.setStaffID(rs.getInt("StaffID"));
//                req.setRequestDate(rs.getTimestamp("RequestDate"));
//                req.setDescription(rs.getString("Description"));
//                req.setIsResolved(rs.getBoolean("IsResolved"));
//                req.setResolutionDate(rs.getTimestamp("ResolutionDate"));
//                list.add(req);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }

    public List<Account> getAccountsByRole(String role) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT AccountID, Username, Role FROM Accounts WHERE Role = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountID(rs.getInt("AccountID"));
                acc.setUsername(rs.getString("Username"));
                acc.setRole(rs.getString("Role"));
                list.add(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertRequest(int roomID, int staffID, String description) throws SQLException {
        String sql = "INSERT INTO MaintenanceRequests (RoomID, StaffID, Description, RequestDate, Status) VALUES (?, ?, ?, NOW(), 'Pending')";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            ps.setInt(2, staffID);
            ps.setString(3, description);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    public boolean resolveRequest(int requestID) {
        String sql = "UPDATE MaintenanceRequests SET IsResolved = true, ResolutionDate = ? WHERE RequestID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, requestID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- Lấy tất cả yêu cầu bảo trì ---
    public List<MaintenanceRequest> getAllRequests() throws SQLException {
        List<MaintenanceRequest> requests = new ArrayList<>();
        String sql = "SELECT mr.*, r.RoomNumber " +
                 "FROM MaintenanceRequests mr " +
                 "JOIN rooms r ON mr.RoomID = r.RoomID";
        try (Connection conn = DBConnect.getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql); 
            ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaintenanceRequest request = new MaintenanceRequest(
                    rs.getInt("RequestID"),
                    rs.getInt("RoomID"),
                    rs.getInt("StaffID"),
                        rs.getTimestamp("RequestDate"),
                    rs.getString("Description"),
                    rs.getBoolean("isResolved"),
                    rs.getTimestamp("resolutionDate"),
                    rs.getInt("RoomNumber") // Thêm RoomNumber
                );
                requests.add(request);
            }
        }
        return requests;
    }
    
    public List<MaintenanceRequest> getPendingRequestsForStaff(String search, String sort, int offset, int limit, int staffID) throws SQLException {
        List<MaintenanceRequest> requests = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT mr.*, r.RoomNumber " +
            "FROM MaintenanceRequests mr " +
            "JOIN rooms r ON mr.RoomID = r.RoomID " +
            "WHERE mr.StaffID = ? AND mr.IsResolved = FALSE "
        );

        // Thêm điều kiện tìm kiếm
        if (search != null && !search.isEmpty()) {
            sql.append("AND (mr.Description LIKE ? OR r.RoomNumber LIKE ?) ");
        }

        // Thêm sắp xếp theo RequestDate
        if (sort != null && !sort.isEmpty()) {
            sql.append("ORDER BY mr.RequestDate ").append(sort.equals("asc") ? "ASC" : "DESC ");
        }

        // Thêm phân trang
        sql.append("LIMIT ? OFFSET ?");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, staffID);

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }

            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceRequest request = new MaintenanceRequest(
                        rs.getInt("RequestID"),
                        rs.getInt("RoomID"),
                        rs.getInt("StaffID"),
                        rs.getTimestamp("RequestDate"),
                        rs.getString("Description"),
                        rs.getBoolean("IsResolved"),
                        rs.getTimestamp("resolutionDate"),
                        rs.getInt("RoomNumber")
                    );
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public int countPendingRequestsForStaff(String search, int staffID) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM MaintenanceRequests mr " +
            "JOIN rooms r ON mr.RoomID = r.RoomID " +
            "WHERE mr.StaffID = ? AND mr.IsResolved = FALSE "
        );

        if (search != null && !search.isEmpty()) {
            sql.append("AND (mr.Description LIKE ? OR r.RoomNumber LIKE ?) ");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, staffID);

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getRequestRoomID(int requestID) throws SQLException {
        String sql = "SELECT RoomID FROM MaintenanceRequests WHERE RequestID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("RoomID");
            }
            return -1; // Hoặc throw exception nếu cần
        }
    }

    public boolean completeRequest(int requestID) throws SQLException {
        String sql = "UPDATE MaintenanceRequests SET IsResolved = TRUE, resolutionDate = NOW() WHERE RequestID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
