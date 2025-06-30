/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class BookingDetail {
     private int bookingDetailID;
    private int bookingID;
    private int roomTypeID;
    private String roomTypeName; // JOIN lấy tên room type
    private int quantity;
    private double pricePerNight;
    private int guestsCount;

    // Constructors
    public BookingDetail() {}

    public BookingDetail(int bookingDetailID, int bookingID, int roomTypeID, String roomTypeName, int quantity, double pricePerNight, int guestsCount) {
        this.bookingDetailID = bookingDetailID;
        this.bookingID = bookingID;
        this.roomTypeID = roomTypeID;
        this.roomTypeName = roomTypeName;
        this.quantity = quantity;
        this.pricePerNight = pricePerNight;
        this.guestsCount = guestsCount;
    }

    // Getters & Setters
    public int getBookingDetailID() { return bookingDetailID; }
    public void setBookingDetailID(int bookingDetailID) { this.bookingDetailID = bookingDetailID; }

    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public int getRoomTypeID() { return roomTypeID; }
    public void setRoomTypeID(int roomTypeID) { this.roomTypeID = roomTypeID; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }

    public int getGuestsCount() { return guestsCount; }
    public void setGuestsCount(int guestsCount) { this.guestsCount = guestsCount; }
}
