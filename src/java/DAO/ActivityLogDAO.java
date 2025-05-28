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
public class ActivityLogDAO {

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

}
