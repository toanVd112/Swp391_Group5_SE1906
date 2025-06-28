package model;

import java.util.ArrayList;
import java.util.List;

public class RoomType {

    private int roomTypeID;
    private String name;
    private String description;
    private double basePrice;
    private String imageUrl;
    private String roomDetail;
    private int maxGuests;
    private int availableRooms;

    private List<RoomImage> images;
    private List<String> categoryList;
    private List<Amenity> amenities;

    // Constructor mặc định – khởi tạo list để tránh null
    public RoomType() {
        this.images = new ArrayList<>();
        this.categoryList = new ArrayList<>();
        this.amenities = new ArrayList<>();
    }

    // Constructor thường dùng
    public RoomType(int roomTypeID, String name, String description, double basePrice, String imageUrl, String roomDetail, int maxGuests) {
        this();
        this.roomTypeID = roomTypeID;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.imageUrl = imageUrl;
        this.roomDetail = roomDetail;
        this.maxGuests = maxGuests;
    }

    public RoomType(int roomTypeID, String name, String description, double basePrice, String imageUrl, String roomDetail, int maxGuests, int availableRooms) {
        this(roomTypeID, name, description, basePrice, imageUrl, roomDetail, maxGuests);
        this.availableRooms = availableRooms;
    }

    public RoomType(int roomTypeID, String name) {
        this();
        this.roomTypeID = roomTypeID;
        this.name = name;
    }

    // Getters và Setters
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

    public int getMaxGuests() {
        return maxGuests;
    }

    public void setMaxGuests(int maxGuests) {
        this.maxGuests = maxGuests;
    }

    public int getAvailableRooms() {
        return availableRooms;
    }

    public void setAvailableRooms(int availableRooms) {
        this.availableRooms = availableRooms;
    }

    public List<RoomImage> getImages() {
        if (images == null) {
            images = new ArrayList<>();
        }
        return images;
    }

    public void setImages(List<RoomImage> images) {
        this.images = images;
    }

    public void addImage(RoomImage image) {
        if (this.images == null) {
            this.images = new ArrayList<>();
        }
        this.images.add(image);
    }

    public List<String> getCategoryList() {
        if (categoryList == null) {
            categoryList = new ArrayList<>();
        }
        return categoryList;
    }

    public void setCategoryList(List<String> categoryList) {
        this.categoryList = categoryList;
    }

    public void addCategory(String category) {
        if (this.categoryList == null) {
            this.categoryList = new ArrayList<>();
        }
        this.categoryList.add(category);
    }

    public List<Amenity> getAmenities() {
        if (amenities == null) {
            amenities = new ArrayList<>();
        }
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        this.amenities = amenities;
    }

    public void addAmenity(Amenity amenity) {
        if (this.amenities == null) {
            this.amenities = new ArrayList<>();
        }
        this.amenities.add(amenity);
    }
}
