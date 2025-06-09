/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */
public class RoomImage {
    private int imageID;
    private Integer roomID;       // Dùng Integer để cho phép null
    private Integer roomTypeID;
    private String imageUrl;
    private boolean isPrimary;
    private String category;

    public RoomImage() {
    }

    public RoomImage(int imageID, Integer roomID, Integer roomTypeID, String imageUrl, boolean isPrimary, String category) {
        this.imageID = imageID;
        this.roomID = roomID;
        this.roomTypeID = roomTypeID;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.category = category;
    }

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public Integer getRoomID() {
        return roomID;
    }

    public void setRoomID(Integer roomID) {
        this.roomID = roomID;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "RoomImage{" +
                "imageID=" + imageID +
                ", roomID=" + roomID +
                ", roomTypeID=" + roomTypeID +
                ", imageUrl='" + imageUrl + '\'' +
                ", isPrimary=" + isPrimary +
                ", category='" + category + '\'' +
                '}';
    }
}

