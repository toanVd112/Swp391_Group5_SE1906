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
    private int RoomID;
    private int RoomTypeID;
    private String RoomNumber;
    private int Floor;
    private String Status;

    public Room(int aInt, String string, String string1, double aDouble, String string2, String string3) {
    }

    public Room(int RoomID, int RoomTypeID, String RoomNumber, int Floor, String Status) {
        this.RoomID = RoomID;
        this.RoomTypeID = RoomTypeID;
        this.RoomNumber = RoomNumber;
        this.Floor = Floor;
        this.Status = Status;
    }

    public int getRoomID() {
        return RoomID;
    }

    public void setRoomID(int RoomID) {
        this.RoomID = RoomID;
    }

    public int getRoomTypeID() {
        return RoomTypeID;
    }

    public void setRoomTypeID(int RoomTypeID) {
        this.RoomTypeID = RoomTypeID;
    }

    public String getRoomNumber() {
        return RoomNumber;
    }

    public void setRoomNumber(String RoomNumber) {
        this.RoomNumber = RoomNumber;
    }

    public int getFloor() {
        return Floor;
    }

    public void setFloor(int Floor) {
        this.Floor = Floor;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    @Override
    public String toString() {
        return "Rooms{" + "RoomID=" + RoomID + ", RoomTypeID=" + RoomTypeID + ", RoomNumber=" + RoomNumber + ", Floor=" + Floor + ", Status=" + Status + '}';
    }
    
   
}
