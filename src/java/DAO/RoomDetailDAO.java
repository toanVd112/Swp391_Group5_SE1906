package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Amenity;
import model.RoomImage;
import model.RoomType;

public class RoomDetailDAO {

    public RoomType getRoomTypeDetailById(int roomTypeId) {
        String sql = "SELECT * FROM roomtypes WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("RoomTypeID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("BasePrice"),
                        rs.getString("RoomTypeImage"),
                        rs.getString("RoomDetail"),
                        rs.getInt("MaxGuests")
                );

                roomType.setImages(getImagesByRoomTypeId(roomTypeId));
                roomType.setAmenities(getAmenitiesByRoomTypeId(roomTypeId));

                return roomType;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RoomImage> getImagesByRoomTypeId(int roomTypeID) {
        List<RoomImage> list = new ArrayList<>();
        String sql = "SELECT * FROM roomimages WHERE RoomTypeID = ? ORDER BY IsPrimary DESC";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomImage img = new RoomImage(
                            rs.getInt("ImageID"),
                            rs.getInt("RoomTypeID"),
                            rs.getString("ImageUrl"),
                            rs.getBoolean("IsPrimary")
                    );
                    list.add(img);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Amenity> getAmenitiesByRoomTypeId(int roomTypeID) {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT * FROM roomamenities WHERE RoomTypeID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
