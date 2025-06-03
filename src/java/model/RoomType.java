/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */
public class RoomType {
    private int roomtypeID;
    private String name;
    private String description;
    private double basePrice;
    private String imageUrl;
    private String roomDetail; // mới thêm

    public RoomType() {
    }

    public RoomType(int roomtypeID, String name, String description, double basePrice, String imageUrl, String roomDetail) {
        this.roomtypeID = roomtypeID;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.imageUrl = imageUrl;
        this.roomDetail = roomDetail;
    }

    public int getRoomtypeID() {
        return roomtypeID;
    }

    public void setRoomtypeID(int roomtypeID) {
        this.roomtypeID = roomtypeID;
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
}