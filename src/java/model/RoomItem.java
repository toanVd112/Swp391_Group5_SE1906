/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Admin
 */
public class RoomItem {

    public int roomTypeId;
    public String roomName;
    public double basePrice;
    public int roomCapacity;
    public int roomId,quantity;            // ✅ Thêm field này để giữ RoomID cụ thể
    public List<RoomItem> rooms;

    public RoomItem(int roomTypeId, String roomName,  double basePrice, int roomCapacity, List<RoomItem> rooms) {
        this.roomTypeId = roomTypeId;
        this.roomName = roomName;
       
        this.basePrice = basePrice;
        this.roomCapacity = roomCapacity;
        this.rooms = rooms;
    }

    public RoomItem() {
      
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

   

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public int getRoomCapacity() {
        return roomCapacity;
    }

    public void setRoomCapacity(int roomCapacity) {
        this.roomCapacity = roomCapacity;
    }

    public List<RoomItem> getRooms() {
        return rooms;
    }

    public void setRooms(List<RoomItem> rooms) {
        this.rooms = rooms;
    }

}
