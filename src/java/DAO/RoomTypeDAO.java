/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
public class RoomTypeDAO {

    public RoomType getRoomTypeById(int id) {
        String sql = "SELECT * FROM roomtypes WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertRoomType(RoomType type) {
        String sql = "INSERT INTO roomtypes (Name, Description, BasePrice, RoomTypeImage, RoomDetail) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateRoomType(RoomType type) {
        String sql = "UPDATE roomtypes SET Name = ?, Description = ?, BasePrice = ?, RoomTypeImage = ?, RoomDetail = ? WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setString(2, type.getDescription());
            ps.setDouble(3, type.getBasePrice());
            ps.setString(4, type.getImageUrl());
            ps.setString(5, type.getRoomDetail());
            ps.setInt(6, type.getRoomTypeID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

   public List<RoomType> searchRoomTypes(String keyword, double minPrice, double maxPrice, String sortBy, int offset, int limit) {
    List<RoomType> list = new ArrayList<>();

    boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

    StringBuilder sql = new StringBuilder(
        "SELECT rt.*, COUNT(r.RoomID) AS roomCount " +
        "FROM roomtypes rt " +
        "LEFT JOIN rooms r ON rt.RoomTypeID = r.RoomTypeID " +
        "WHERE rt.BasePrice BETWEEN ? AND ?"
    );

    if (hasKeyword) {
        sql.append(" AND rt.Name LIKE ?");
    }

    sql.append(" GROUP BY rt.RoomTypeID, rt.Name, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail ");

    switch (sortBy != null ? sortBy : "") {
        case "name":
            sql.append(" ORDER BY rt.Name ASC");
            break;
        case "price":
            sql.append(" ORDER BY rt.BasePrice ASC");
            break;
        case "roomCount":
            sql.append(" ORDER BY roomCount DESC");
            break;
        default:
            sql.append(" ORDER BY rt.RoomTypeID DESC");
    }

    sql.append(" LIMIT ?, ?");

    try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int index = 1;
        ps.setDouble(index++, minPrice);
        ps.setDouble(index++, maxPrice);

        if (hasKeyword) {
            ps.setString(index++, "%" + keyword.trim() + "%");
        }

        ps.setInt(index++, offset);
        ps.setInt(index, limit);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            RoomType rt = new RoomType(
                    rs.getInt("RoomTypeID"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getDouble("BasePrice"),
                    rs.getString("RoomTypeImage"),
                    rs.getString("RoomDetail"),
                    rs.getInt("roomCount") // cần constructor hỗ trợ
            );
            list.add(rt);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    public int countRoomTypes(String keyword, double minPrice, double maxPrice) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM roomtypes WHERE BasePrice BETWEEN ? AND ?");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND Name LIKE ?");
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setDouble(index++, minPrice);
            ps.setDouble(index++, maxPrice);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }
}