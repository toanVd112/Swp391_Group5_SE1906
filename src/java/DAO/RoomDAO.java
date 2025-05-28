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
public class RoomDAO {
    
    public List<Room> getAllroom(){
    List<Room> list = new ArrayList<>();
     String sql = "SELECT * FROM rooms ";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Room(rs.getInt("roomID"), 
                            rs.getInt("roomtypeID"),
                            rs.getString("roomnumber"),
                            rs.getInt("floor"),
                            rs.getString("status")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    } 
    
    
     public static void main(String[] args) {
        RoomDAO dao = new RoomDAO();
        List<Room> list = dao.getAllroom();
        for (Room Room : list) {
            System.out.println(Room);
        }
    }
}
