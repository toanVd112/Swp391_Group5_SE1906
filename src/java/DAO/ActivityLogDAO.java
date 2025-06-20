package dao;

import model.ActivityLog;
import java.sql.*;
import java.util.*;

public class ActivityLogDAO {
    private Connection conn;

    public ActivityLogDAO(Connection conn) {
        this.conn = conn;
    }

    public void insertLog(int actorId, String actionType, String targetTable, int targetId, String description, String ipAddress) throws SQLException {
        String sql = "INSERT INTO activitylogs (ActorID, ActionType, TargetTable, TargetID, Description, IpAddress, ActionTime) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, actorId);
            ps.setString(2, actionType);
            ps.setString(3, targetTable);
            ps.setInt(4, targetId);
            ps.setString(5, description);
            ps.setString(6, ipAddress);
            ps.executeUpdate();
        }
    }

    public List<ActivityLog> getLogs(String username, String actionType, Date startDate, Date endDate, String sortBy, String sortOrder, int page, int pageSize) throws SQLException {
        List<ActivityLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT al.*, acc.Username, acc.Role FROM activitylogs al " +
            "JOIN accounts acc ON al.ActorID = acc.AccountID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND acc.Username LIKE ?");
            params.add("%" + username + "%");
        }
        if (actionType != null && !actionType.equals("All")) {
            sql.append(" AND al.ActionType = ?");
            params.add(actionType);
        }
        if (startDate != null) {
            sql.append(" AND al.ActionTime >= ?");
            params.add(new Timestamp(startDate.getTime()));
        }
        if (endDate != null) {
            sql.append(" AND al.ActionTime <= ?");
            params.add(new Timestamp(endDate.getTime()));
        }

        String safeSortBy = "al.ActionTime";
        if (sortBy != null && !sortBy.isEmpty()) {
            if ("username".equalsIgnoreCase(sortBy)) safeSortBy = "acc.Username";
            else if ("role".equalsIgnoreCase(sortBy)) safeSortBy = "acc.Role";
            else if ("actionType".equalsIgnoreCase(sortBy)) safeSortBy = "al.ActionType";
            else safeSortBy = "al.ActionTime";
        }
        String safeSortOrder = "DESC";
        if (sortOrder != null && sortOrder.equalsIgnoreCase("ASC")) {
            safeSortOrder = "ASC";
        }
        sql.append(" ORDER BY ").append(safeSortBy).append(" ").append(safeSortOrder);

        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("LogID"));
                log.setActorId(rs.getInt("ActorID"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetId(rs.getInt("TargetID"));
                log.setDescription(rs.getString("Description"));
                log.setIpAddress(rs.getString("IpAddress"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                log.setUsername(rs.getString("Username"));
                log.setRole(rs.getString("Role"));
                logs.add(log);
            }
        }
        return logs;
    }

    public int countLogs(String username, String actionType, Date startDate, Date endDate) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM activitylogs al JOIN accounts acc ON al.ActorID = acc.AccountID WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND acc.Username LIKE ?");
            params.add("%" + username + "%");
        }
        if (actionType != null && !actionType.equals("All")) {
            sql.append(" AND al.ActionType = ?");
            params.add(actionType);
        }
        if (startDate != null) {
            sql.append(" AND al.ActionTime >= ?");
            params.add(new Timestamp(startDate.getTime()));
        }
        if (endDate != null) {
            sql.append(" AND al.ActionTime <= ?");
            params.add(new Timestamp(endDate.getTime()));
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public ActivityLog getLogById(int logId) throws SQLException {
        String sql = "SELECT al.*, acc.Username, acc.Role FROM activitylogs al " +
                     "JOIN accounts acc ON al.ActorID = acc.AccountID WHERE al.LogID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, logId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("LogID"));
                log.setActorId(rs.getInt("ActorID"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetId(rs.getInt("TargetID"));
                log.setDescription(rs.getString("Description"));
                log.setIpAddress(rs.getString("IpAddress"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                log.setUsername(rs.getString("Username"));
                log.setRole(rs.getString("Role"));
                return log;
            }
        }
        return null;
    }
}