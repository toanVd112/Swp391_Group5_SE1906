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

    public List<MaintenanceRequest> getAllRequests() {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceRequests ORDER BY RequestDate DESC";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Account> getAccountsByRole(String role) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Accounts WHERE Role = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountID(rs.getInt("AccountID"));
                acc.setUsername(rs.getString("Username"));
                list.add(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertRequest(int roomID, int staffID, String description) {
        String sql = "INSERT INTO MaintenanceRequests (RoomID, StaffID, Description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            ps.setInt(2, staffID);
            ps.setString(3, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
