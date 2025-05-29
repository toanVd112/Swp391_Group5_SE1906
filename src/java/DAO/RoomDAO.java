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
 * @author Arcueid
 */
public class RoomDAO {

    public List<Room> getAllRooms() throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage " +
                     "FROM rooms r " +
                     "JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID";

        Connection conn = DBConnect.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType(
                    rs.getInt("RoomTypeID"),
                    rs.getString("TypeName"),
                    rs.getString("Description"),
                    rs.getDouble("BasePrice"),
                    rs.getString("RoomTypeImage")
                );

                Room room = new Room();
                room.setRoomnumber(rs.getString("RoomNumber"));
                room.setFloor(rs.getInt("Floor"));
                room.setStatus(rs.getString("Status"));
                room.setRoomType(roomType);

                list.add(room);
            }
        }

        return list;
    }

    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM roomtypes";
        Connection conn = DBConnect.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType roomType = new RoomType(
                    rs.getInt("RoomtypeID"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getDouble("BasePrice"),
                    rs.getString("RoomTypeImage")
                );
                list.add(roomType);
            }
        }

        return list;
    }

    
    public Room getLatestRoom() {
    String sql = "SELECT r.*, rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.RoomTypeImage " +
                 "FROM rooms r " +
                 "JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                 "ORDER BY r.RoomID DESC LIMIT 1";

    try {
        Connection conn = DBConnect.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            RoomType roomType = new RoomType(
                rs.getInt("RoomTypeID"),
                rs.getString("Name"),
                rs.getString("Description"),
                rs.getDouble("BasePrice"),
                rs.getString("RoomTypeImage")
            );

            Room room = new Room(
                rs.getInt("RoomID"),
                rs.getString("RoomNumber"),
                rs.getInt("Floor"),
                rs.getString("Status"),
                roomType
            );

            return room;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}
    }
    
    
    

