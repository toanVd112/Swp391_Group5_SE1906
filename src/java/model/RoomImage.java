package model;

import java.util.ArrayList;
import java.util.List;

public class RoomImage {
    private int imageID;
    private Integer roomTypeID;
    private String imageUrl;
    private boolean isPrimary;
    private List<String> categories;

    public RoomImage() {
        this.categories = new ArrayList<>();
    }

    public RoomImage(int imageID, Integer roomTypeID, String imageUrl, boolean isPrimary) {
        this.imageID = imageID;
        this.roomTypeID = roomTypeID;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.categories = new ArrayList<>();
    }

    // Getters and Setters
    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public Integer getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(Integer roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    public void addCategory(String category) {
        if (category != null && !category.trim().isEmpty() && !this.categories.contains(category)) {
            this.categories.add(category);
        }
    }

    public void removeCategory(String category) {
        if (category != null && !category.trim().isEmpty()) {
            this.categories.remove(category);
        }
    }

    public String getCategoriesAsString() {
        if (categories == null || categories.isEmpty()) return "";
        return String.join(",", categories);
    }

    @Override
    public String toString() {
        return "RoomImage{" +
                "imageID=" + imageID +
                ", roomTypeID=" + roomTypeID +
                ", imageUrl='" + imageUrl + '\'' +
                ", isPrimary=" + isPrimary +
                '}';
    }
}
