/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.util.*;
import java.sql.*;
import model.Room;

/**
 *
 * @author Arcueid
 */
public class RoomsDAO {
    public List<Room> getAllroom(){
    List<Room> list = new ArrayList<>();
     String sql = "SELECT * FROM Product WHERE cateID = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Room(rs.getInt("RoomID"), 
                            rs.getInt("RoomTypeID"),
                            rs.getString("RoomNumber"),
                            rs.getInt("Floor"),
                            rs.getString("Status")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    } 
    
    
    
}
