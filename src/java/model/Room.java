/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Arcueid
 */

public class Room {
    private int roomID;
    private String roomnumber;
    private int floor;
    private String status;   
    private String roomImage;
    private RoomType roomType; // Liên kết với RoomType
    private List<Amenity> amenities;         // Danh sách tiện ích
    private List<PageContent> contents;       // Danh sách nội dung trang
    public Room(int roomID) {
        this.roomID = roomID;
    }

   public Room(int roomID, String roomnumber, int floor, String status, String roomImage, RoomType roomType) {
    this.roomID = roomID;
    this.roomnumber = roomnumber;
    this.floor = floor;
    this.status = status;
    this.roomImage = roomImage;
    this.roomType = roomType;
}
    public Room() {}

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
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
    }

    public List<Amenity> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<Amenity> amenities) {
        this.amenities = amenities;
    }

    public List<PageContent> getContents() {
        return contents;
    }

    public void setContents(List<PageContent> contents) {
        this.contents = contents;
    }
    public String getRoomImage() {
    return roomImage;
}

public void setRoomImage(String roomImage) {
    this.roomImage = roomImage;
}

    @Override
    public String toString() {
        return "Room{" +
                "roomID=" + roomID +
                ", roomnumber='" + roomnumber + '\'' +
                ", floor=" + floor +
                ", status='" + status + '\'' +
                ", roomType=" + (roomType != null ? roomType.getName() : "null") +
                ", amenitiesCount=" + (amenities != null ? amenities.size() : 0) +
                ", contentsCount=" + (contents != null ? contents.size() : 0) +
                '}';
    }
}

