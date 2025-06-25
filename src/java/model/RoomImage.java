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
    private Integer roomTypeID;
    private String imageUrl;
    private boolean isPrimary;
    private String category;

    public RoomImage() {
    }

    public RoomImage(int imageID, Integer roomTypeID, String imageUrl, boolean isPrimary, String category) {
        this.imageID = imageID;
        this.roomTypeID = roomTypeID;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.category = category;
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
                ", roomTypeID=" + roomTypeID +
                ", imageUrl='" + imageUrl + '\'' +
                ", isPrimary=" + isPrimary +
                ", category='" + category + '\'' +
                '}';
    }
}