/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author admin
 */
public class Service {
    private int serviceID;
    private String serviceName;
    private String description;
    private double price;
    private boolean status;

    // Constructors
    public Service() {}

    public Service(int id, String name, String description, double price, boolean status) {
        this.serviceID = id;
        this.serviceName = name;
        this.description = description;
        this.price = price;
        this.status = status;
    }

    // Getters and setters
    public int getServiceID() { return serviceID; }
    public void setServiceID(int serviceID) { this.serviceID = serviceID; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}

