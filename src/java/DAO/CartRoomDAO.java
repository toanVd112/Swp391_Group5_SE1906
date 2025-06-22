/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.util.*;
import java.sql.*;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;

/**
 *
 * @author Admin
 */
public class CartRoomDAO {

    public void insertIfNotExists(int userId, int roomId) {
        String checkSQL = "SELECT 1 FROM CartRooms WHERE AccountID = ? AND RoomID = ?";
        String insertSQL = "INSERT INTO CartRooms(AccountID, RoomID) VALUES (?, ?)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement check = con.prepareStatement(checkSQL)) {

            check.setInt(1, userId);
            check.setInt(2, roomId);
            ResultSet rs = check.executeQuery();

            if (!rs.next()) {
                try (PreparedStatement insert = con.prepareStatement(insertSQL)) {
                    insert.setInt(1, userId);
                    insert.setInt(2, roomId);
                    insert.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getRoomIdsByAccount(int accountId) {
        List<Integer> roomIds = new ArrayList<>();
        String sql = "SELECT RoomID FROM CartRooms WHERE AccountID = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                roomIds.add(rs.getInt("RoomID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return roomIds;
    }

    public void deleteRoomFromCart(int accountId, int roomId) {
        String sql = "DELETE FROM CartRooms WHERE AccountID = ? AND RoomID = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            stmt.setInt(2, roomId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void clearCart(int accountId) {
        String sql = "DELETE FROM CartRooms WHERE AccountID = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Room> getRoomsByIds(List<Integer> roomIds) {
        List<Room> rooms = new ArrayList<>();
        if (roomIds == null || roomIds.isEmpty()) {
            return rooms;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < roomIds.size(); i++) {
            placeholders.append("?");
            if (i < roomIds.size() - 1) {
                placeholders.append(",");
            }
        }

        String sql = "SELECT r.RoomID, r.RoomNumber, r.Floor, r.RoomImage, r.Status, "
                + "rt.Name AS RoomTypeName, rt.BasePrice "
                + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                + "WHERE r.RoomID IN (" + placeholders + ")";

        try (Connection con = DBConnect.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            for (int i = 0; i < roomIds.size(); i++) {
                stmt.setInt(i + 1, roomIds.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomnumber(rs.getString("RoomNumber"));
                room.setFloor(rs.getInt("Floor"));
                room.setRoomImage(rs.getString("RoomImage"));
               room.setStatus(rs.getString("Status"));
                RoomType rt = new RoomType();
                rt.setBasePrice(rs.getDouble("BasePrice"));
                rt.setName(rs.getString("RoomTypeName"));
                room.setRoomType(rt);

                rooms.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public static void main(String[] args) {
        CartRoomDAO o = new CartRoomDAO();
        List<Integer> roomIds = o.getRoomIdsByAccount(28);
        List<Room> selectedRooms = o.getRoomsByIds(roomIds);
        System.out.println(selectedRooms);
    }
}
