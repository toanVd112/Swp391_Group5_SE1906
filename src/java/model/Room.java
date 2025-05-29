/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Arcueid
 */

public class Room {
    private int roomID;
    private String roomnumber;
    private int floor;
    private String status;

    private RoomType roomType; // Thay cho roomtypeID

    // Constructor đầy đủ
    public Room(int roomID, String roomnumber, int floor, String status, RoomType roomType) {
        this.roomID = roomID;
        this.roomnumber = roomnumber;
        this.floor = floor;
        this.status = status;
        this.roomType = roomType;
    }

    // Constructor rút gọn nếu cần
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

    @Override
    public String toString() {
        return "Room{" +
                "roomID=" + roomID +
                ", roomnumber='" + roomnumber + '\'' +
                ", floor=" + floor +
                ", status='" + status + '\'' +
                ", roomType=" + (roomType != null ? roomType.getName() : "null") +
                '}';
    }
}

