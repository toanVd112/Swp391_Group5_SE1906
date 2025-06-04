/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import model.PageContent;
import java.sql.ResultSet;
import model.Room;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
public class RoomDetailDAO {

    public List<PageContent> getPageContent() {
        List<PageContent> list = new ArrayList<>();
        String sql = "SELECT * FROM pagecontents WHERE RoomID IS NULL";

        try (java.sql.Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PageContent pc = new PageContent(
                    rs.getInt("ContentID"),
                    null,
                    rs.getString("PageSection"),
                    rs.getString("Title"),
                    rs.getString("Content")
                );
                list.add(pc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // --- Thêm hàm getRoomById ---
    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.RoomTypeID, rt.Name AS TypeName, rt.Description, rt.BasePrice, rt.RoomTypeImage, rt.RoomDetail "
                   + "FROM rooms r JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID "
                   + "WHERE r.RoomID = ?";
        try (java.sql.Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomType roomType = new RoomType(
                    rs.getInt("RoomTypeID"),
                    rs.getString("TypeName"),
                    rs.getString("Description"),
                    rs.getDouble("BasePrice"),
                    rs.getString("RoomTypeImage"),
                    rs.getString("RoomDetail")
                );

                return new Room(
                    rs.getInt("RoomID"),
                    rs.getString("RoomNumber"),
                    rs.getInt("Floor"),
                    rs.getString("Status"),
                    roomType
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}