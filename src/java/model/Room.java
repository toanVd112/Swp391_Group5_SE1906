/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 * Model đại diện cho phòng trong khách sạn.
 *
 * @author Arcueid
 */
public class Room {

    private int roomID;
    private int roomTypeID;
    private String roomnumber;
    private int floor;
    private String status;

    private RoomType roomType;
    private List<Amenity> amenities;

    // === Constructors ===
    public Room() {
    }

    public Room(int roomID) {
        this.roomID = roomID;
    }

    public Room(int roomID, int roomTypeID, String roomnumber, int floor, String status) {
        this.roomID = roomID;
        this.roomTypeID = roomTypeID;
        this.roomnumber = roomnumber;
        this.floor = floor;
        this.status = status;

    }

    public Room(int roomID, String roomnumber, int floor, String status, RoomType roomType) {
        this.roomID = roomID;
        this.roomnumber = roomnumber;
        this.floor = floor;
        this.status = status;

        this.roomType = roomType;
        if (roomType != null) {
            this.roomTypeID = roomType.getRoomTypeID();
        }
    }

    // === Getters & Setters ===
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getRoomnumber() {
        return roomnumber;
    }

    public void setRoomnumber(String roomnumber) {
        this.roomnumber = roomnumber;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
        if (roomType != null) {
            this.roomTypeID = roomType.getRoomTypeID();
        }
    }

    private List<String> detailImageUrls;

    public List<String> getDetailImageUrls() {
        return detailImageUrls;
    }

    public void setDetailImageUrls(List<String> detailImageUrls) {
        this.detailImageUrls = detailImageUrls;
    }

    public List<Amenity> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        this.amenities = amenities;
    }

    // === ToString for debug ===
    @Override
    public String toString() {
        return "Room{"
                + "roomID=" + roomID
                + ", roomnumber='" + roomnumber + '\''
                + ", floor=" + floor
                + ", status='" + status + '\''
                + ", roomType=" + (roomType != null ? roomType.getName() : "null")
                + ", amenitiesCount=" + (amenities != null ? amenities.size() : 0)
                + '}';
    }
}
