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
public class RoomInspectionDAO {

    public void assignInspection(int roomId, int staffId, Timestamp time, String note) throws Exception {
        String sql = "INSERT INTO roominspectionreports (RoomID, StaffID, InspectionTime, Notes) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, staffId);
            ps.setTimestamp(3, time);
            ps.setString(4, note);
            ps.executeUpdate();
        }
    }
}
