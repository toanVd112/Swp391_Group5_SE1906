/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.util.*;
import java.sql.*;
import model.Room;
import model.RoomType;

/**
 *
 * @author Admin
 */
public class MaintenanceRequestDAO {
    public void createRequest(int roomId, int staffId, String desc, Timestamp deadline) throws Exception {
        String sql = "INSERT INTO maintenanceRequests (RoomID, StaffID, RequestDate, Description, Resolved, ResolutionDate) VALUES (?, ?, NOW(), ?, 0, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, staffId);
            ps.setString(3, desc);
            ps.setTimestamp(4, deadline);
            ps.executeUpdate();
        }
    }

  
}
