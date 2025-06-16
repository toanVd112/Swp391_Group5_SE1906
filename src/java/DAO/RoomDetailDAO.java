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
import model.Amenity;
import model.Room;
import model.RoomImage;
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
                        rs.getString("RoomImage"),
                        roomType
                );
            }

        } catch (Exception e) {
        }

        return null;
    }


public List<RoomImage> getImagesByRoomOrType(int roomID) {
    List<RoomImage> list = new ArrayList<>();
    String sql = """
        SELECT * FROM roomimages
        WHERE RoomID = ? 
        UNION
        SELECT * FROM roomimages
        WHERE RoomTypeID = (
            SELECT RoomTypeID FROM rooms WHERE RoomID = ?
        ) AND RoomID IS NULL
        ORDER BY IsPrimary DESC
        """;

    try (java.sql.Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, roomID);
        ps.setInt(2, roomID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomImage img = new RoomImage();
                img.setImageID(rs.getInt("ImageID"));
                img.setRoomID(rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null);
                img.setRoomTypeID(rs.getObject("RoomTypeID") != null ? rs.getInt("RoomTypeID") : null);
                img.setImageUrl(rs.getString("ImageUrl"));
                img.setCategory(rs.getString("Category"));
                img.setPrimary(rs.getBoolean("IsPrimary"));
                list.add(img);
            }
        }

    } catch (Exception e) {
    }

    return list;
}
public List<Amenity> getAmenitiesByRoomTypeId(int roomTypeID) {
    List<Amenity> list = new ArrayList<>();
    String sql = "SELECT * FROM roomamenities WHERE RoomTypeID = ?";

    try (java.sql.Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, roomTypeID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Amenity a = new Amenity();
                a.setAmenityId(rs.getInt("RoomAmenityID"));
                a.setAmenityName(rs.getString("AmenityName"));
                a.setIcon(rs.getString("Icon"));
                list.add(a);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}
