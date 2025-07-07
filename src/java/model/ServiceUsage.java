/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class ServiceUsage {
    
   private int bookingID;
    private int serviceID;
    private String serviceName; // JOIN dịch vụ
    private int price;
    private int quantity;

    public ServiceUsage() {}

    public ServiceUsage(int bookingID, int serviceID, String serviceName, int price, int quantity) {
        this.bookingID = bookingID;
        this.serviceID = serviceID;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters & Setters
    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public int getServiceID() { return serviceID; }
    public void setServiceID(int serviceID) { this.serviceID = serviceID; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public double getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}