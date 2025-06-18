package dao;

import model.ActivityLog;
import java.sql.*;
import java.util.*;

public class ActivityLogDAO {
    private Connection conn;

    public ActivityLogDAO(Connection conn) {
        this.conn = conn;
    }

    public void insertLog(int actorId, String actionType, String targetTable, int targetId, String description) throws SQLException {
        String sql = "INSERT INTO activitylogs (ActorID, ActionType, TargetTable, TargetID, Description, ActionTime) VALUES (?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, actorId);
            ps.setString(2, actionType);
            ps.setString(3, targetTable);
            ps.setInt(4, targetId);
            ps.setString(5, description);
            ps.executeUpdate();
        }
    }

    public List<ActivityLog> getAllLogs(int page, int pageSize) throws SQLException {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT al.*, acc.Username, acc.Role FROM activitylogs al " +
                     "JOIN accounts acc ON al.ActorID = acc.AccountID " +
                     "ORDER BY al.ActionTime DESC LIMIT ? OFFSET ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("LogID"));
                log.setUsername(rs.getString("Username"));
                log.setRole(rs.getString("Role"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetId(rs.getInt("TargetID"));
                log.setDescription(rs.getString("Description"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                logs.add(log);
            }
        }
        return logs;
    }

    public int countAllLogs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM activitylogs";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
}