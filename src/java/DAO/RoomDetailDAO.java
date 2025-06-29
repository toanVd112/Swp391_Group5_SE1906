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
                roomType.setCategoryList(getCategoriesByRoomTypeId(roomTypeId));

                // Kiểm tra đồng bộ categories
                syncImageCategories(roomTypeId);

                return roomType;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getCategoriesByRoomTypeId(int roomTypeId) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CategoryName FROM roomtype_categories WHERE RoomTypeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String name = rs.getString("CategoryName");
                if (name != null && !name.trim().isEmpty()) {
                    categories.add(name.trim());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    private List<String> getImageCategoriesByImageId(int imageId) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT CategoryName FROM roomimage_categories WHERE ImageID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String cat = rs.getString("CategoryName");
                if (cat != null && !cat.trim().isEmpty()) {
                    categories.add(cat.trim());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
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
                    List<String> categories = getImageCategoriesByImageId(img.getImageID());
                    img.setCategories(categories);
                    img.setCategoriesAsString(String.join(",", categories));
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

    // Đồng bộ roomimage_categories với roomtype_categories
    private void syncImageCategories(int roomTypeId) {
        String sql = "DELETE FROM roomimage_categories WHERE RoomTypeID = ? AND CategoryName NOT IN (SELECT CategoryName FROM roomtype_categories WHERE RoomTypeID = ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setInt(2, roomTypeId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Removed " + rowsAffected + " invalid categories from roomimage_categories for RoomTypeID=" + roomTypeId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getAvailableRoomsCount(int roomTypeId) {
       String sql = "SELECT COUNT(*) FROM rooms WHERE RoomTypeID = ? AND Status = 'Available'";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Có thể thay bằng ghi log nếu cần
        }
        return 0;
    }
}
