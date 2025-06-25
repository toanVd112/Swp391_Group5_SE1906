/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class RoomSuggestion {

    private RoomType roomType;
    private int quantity;

    public RoomSuggestion(RoomType roomType, int quantity) {
        this.roomType = roomType;
        this.quantity = quantity;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public int getQuantity() {
        return quantity;
    }
}
