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
    private int roomtypeID;
    private String roomnumber;
    private int floor;
    private String status;

    public Room(int aInt, String string, String string1, double aDouble, String string2, String string3) {
    }

    public Room(int roomID, int roomtypeID, String roomnumber, int floor, String status) {
        this.roomID = roomID;
        this.roomtypeID = roomtypeID;
        this.roomnumber = roomnumber;
        this.floor = floor;
        this.status = status;
    }

    public int getroomid() {
        return roomID;
    }

    public void setroomid(int roomID) {
        this.roomID = roomID;
    }

    public int getroomtypeid() {
        return roomtypeID;
    }

    public void setroomtypeid(int roomtypeID) {
        this.roomtypeID = roomtypeID;
    }

    public String getroomnumber() {
        return roomnumber;
    }

    public void setroomnumber(String roomnumber) {
        this.roomnumber = roomnumber;
    }

    public int getfloor() {
        return floor;
    }

    public void setfloor(int floor) {
        this.floor = floor;
    }

    public String getstatus() {
        return status;
    }

    public void setstatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "room{" + "roomID=" + roomID + ", roomtypeID=" + roomtypeID + ", roomnumber=" + roomnumber + ", floor=" + floor + ", status=" + status + '}';
    }
    
   
}
