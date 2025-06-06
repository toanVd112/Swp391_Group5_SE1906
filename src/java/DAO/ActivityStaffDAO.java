/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ActivityLog;

/**
 *
 * @author Admin
 */
public class ActivityStaffDAO {

    public void logAction(int actorID, String actionType, String targetTable, int targetID) throws SQLException {
        String sql = "INSERT INTO activitylogs (ActorID, ActionType, TargetTable, TargetID, ActionTime) VALUES (?, ?, ?, ?, NOW())";
        Connection conn = DBConnect.getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, actorID);
            ps.setString(2, actionType);
            ps.setString(3, targetTable);
            ps.setInt(4, targetID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ActivityLog> getAllLogs() {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = """
        SELECT l.LogID, l.ActorID, a.Username, l.ActionType, l.TargetTable, l.TargetID, l.ActionTime
        FROM activitylogs l
        JOIN accounts a ON l.ActorID = a.AccountID
        ORDER BY l.ActionTime DESC
    """;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogID(rs.getInt("LogID"));
                log.setActorID(rs.getInt("ActorID"));
                log.setUsername(rs.getString("Username")); // Phải có setUsername trong model
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetID(rs.getInt("TargetID"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                logs.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return logs;
    }

    public List<ActivityLog> getFilteredLogs(String username, String actionType, String targetTable,
            String fromDate, String toDate, String targetID) {
        List<ActivityLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT al.*, a.Username FROM activitylogs al "
                + "JOIN accounts a ON al.ActorID = a.AccountID WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (username != null && !username.isEmpty()) {
            sql.append(" AND a.Username LIKE ?");
            params.add("%" + username + "%");
        }
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND al.ActionType = ?");
            params.add(actionType);
        }
        if (targetTable != null && !targetTable.isEmpty()) {
            sql.append(" AND al.TargetTable LIKE ?");
            params.add("%" + targetTable + "%");
        }
        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            sql.append(" AND al.ActionTime BETWEEN ? AND ?");
            params.add(fromDate + " 00:00:00");
            params.add(toDate + " 23:59:59");
        }
        if (targetID != null && !targetID.isEmpty()) {
            sql.append(" AND al.TargetID = ?");
            params.add(Integer.parseInt(targetID));
        }

        sql.append(" ORDER BY al.ActionTime DESC");

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogID(rs.getInt("LogID"));
                log.setActorID(rs.getInt("ActorID"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetID(rs.getInt("TargetID"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                log.setUsername(rs.getString("Username"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countFilteredLogs(String username, String actionType, String targetTable,
            String fromDate, String toDate, String targetID) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM activitylogs al JOIN accounts a ON al.ActorID = a.AccountID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (username != null && !username.isEmpty()) {
            sql.append(" AND a.Username LIKE ?");
            params.add("%" + username + "%");
        }
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND al.ActionType = ?");
            params.add(actionType);
        }
        if (targetTable != null && !targetTable.isEmpty()) {
            sql.append(" AND al.TargetTable LIKE ?");
            params.add("%" + targetTable + "%");
        }
        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            sql.append(" AND al.ActionTime BETWEEN ? AND ?");
            params.add(fromDate + " 00:00:00");
            params.add(toDate + " 23:59:59");
        }
        if (targetID != null && !targetID.isEmpty()) {
            sql.append(" AND al.TargetID = ?");
            params.add(Integer.parseInt(targetID));
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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

    public List<ActivityLog> getFilteredLogsPaginated(String username, String actionType, String targetTable,
            String fromDate, String toDate, String targetID, int offset, int limit) {

        StringBuilder sql = new StringBuilder(
                "SELECT al.*, a.Username FROM activitylogs al "
                + "JOIN accounts a ON al.ActorID = a.AccountID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (username != null && !username.isEmpty()) {
            sql.append(" AND a.Username LIKE ?");
            params.add("%" + username + "%");
        }
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND al.ActionType = ?");
            params.add(actionType);
        }
        if (targetTable != null && !targetTable.isEmpty()) {
            sql.append(" AND al.TargetTable LIKE ?");
            params.add("%" + targetTable + "%");
        }
        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            sql.append(" AND al.ActionTime BETWEEN ? AND ?");
            params.add(fromDate + " 00:00:00");
            params.add(toDate + " 23:59:59");
        }
        if (targetID != null && !targetID.isEmpty()) {
            sql.append(" AND al.TargetID = ?");
            params.add(Integer.parseInt(targetID));
        }

        sql.append(" ORDER BY al.ActionTime DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        List<ActivityLog> list = new ArrayList<>();
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogID(rs.getInt("LogID"));
                log.setActorID(rs.getInt("ActorID"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetID(rs.getInt("TargetID"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                log.setUsername(rs.getString("Username"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
