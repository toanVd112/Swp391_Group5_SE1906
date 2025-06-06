/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Room2 {
    private int roomID;
    private String roomNumber;
    private int floor;
    private String status;
    private int roomTypeID;
    private String roomTypeName;
    private double basePrice;

    // Constructor
    public Room2(int roomID, String roomNumber, int floor, String status, int roomTypeID, String roomTypeName, double basePrice) {
        this.roomID = roomID;
        this.roomNumber = roomNumber;
        this.floor = floor;
        this.status = status;
        this.roomTypeID = roomTypeID;
        this.roomTypeName = roomTypeName;
        this.basePrice = basePrice;
    }

    // Getters and Setters
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
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

    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    @Override
    public String toString() {
        return "Room2{" +
                "roomID=" + roomID +
                ", roomNumber='" + roomNumber + '\'' +
                ", floor=" + floor +
                ", status='" + status + '\'' +
                ", roomTypeID=" + roomTypeID +
                ", roomTypeName='" + roomTypeName + '\'' +
                ", basePrice=" + basePrice +
                '}';
    }
    
    
}

