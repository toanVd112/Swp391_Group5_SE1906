/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */
public class Amenity {
    private int amenityId;
    private String amenityName;
    private String icon;                
    private RoomType roomType;

    public Amenity() {}

    public Amenity(int amenityId, String amenityName, String icon, RoomType roomType) {
        this.amenityId = amenityId;
        this.amenityName = amenityName;
        this.icon = icon;
        this.roomType = roomType;
    }

    public int getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(int amenityId) {
        this.amenityId = amenityId;
    }

    public String getAmenityName() {
        return amenityName;
    }

    public void setAmenityName(String amenityName) {
        this.amenityName = amenityName;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    @Override
    public String toString() {
        return "Amenity{" +
                "amenityId=" + amenityId +
                ", amenityName='" + amenityName + '\'' +
                ", icon='" + icon + '\'' +
                ", roomType=" + (roomType != null ? roomType.getName() : "null") +
                '}';
    }
}