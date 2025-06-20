package model;

/**
 *
 * @author Arcueid
 */
public class RoomType {

    private int roomTypeID;
    private String name;
    private String description;
    private double basePrice;
    private String imageUrl; // Giữ để tương thích, nhưng ưu tiên dùng images
    private String roomDetail;
    private int availableRooms;
    private java.util.List<model.RoomImage> images; // Thêm danh sách ảnh

    public RoomType() {
    }

    public RoomType(int roomTypeID, String name, String description, double basePrice, String imageUrl, String roomDetail, int availableRooms) {
        this.roomTypeID = roomTypeID;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.imageUrl = imageUrl;
        this.roomDetail = roomDetail;
        this.availableRooms = availableRooms;
    }

    public RoomType(int roomTypeID, String name, String description, double basePrice, String imageUrl, String roomDetail) {
        this.roomTypeID = roomTypeID;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.imageUrl = imageUrl;
        this.roomDetail = roomDetail;
    }

    public RoomType(int roomTypeID, String name) {
        this.roomTypeID = roomTypeID;
        this.name = name;
    }

    // Getters and Setters
    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getRoomDetail() {
        return roomDetail;
    }

    public void setRoomDetail(String roomDetail) {
        this.roomDetail = roomDetail;
    }

    public int getAvailableRooms() {
        return availableRooms;
    }

    public void setAvailableRooms(int availableRooms) {
        this.availableRooms = availableRooms;
    }

    public java.util.List<model.RoomImage> getImages() {
        if (images == null) {
            images = new java.util.ArrayList<>(); // Khởi tạo nếu null
        }
        return images;
    }

    public void setImages(java.util.List<model.RoomImage> images) {
        this.images = images;
    }

    // Phương thức tiện ích để thêm ảnh
    public void addImage(RoomImage image) {
        if (images == null) {
            images = new java.util.ArrayList<>();
        }
        images.add(image);
    }

    private java.util.List<model.Amenity> amenities;

    public java.util.List<model.Amenity> getAmenities() {
        if (amenities == null) {
            amenities = new java.util.ArrayList<>();
        }
        return amenities;
    }

    public void setAmenities(java.util.List<model.Amenity> amenities) {
        this.amenities = amenities;
    }

    public void addAmenity(Amenity amenity) {
        if (amenities == null) {
            amenities = new java.util.ArrayList<>();
        }
        amenities.add(amenity);
    }
}
