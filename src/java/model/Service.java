/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class Service {

    private int serviceID;
    private String serviceName;
    private BigDecimal price;
    private String description;
    private String availabilityStatus;
    private String serviceType;
    private LocalDateTime createdDate;
    private LocalDateTime lastUpdatedDate;
    private String createdBy;
    private String lastUpdatedBy;
    private String serviceImage;

    // Constructors
    public Service() {
    }

    public Service(int serviceID, String serviceName, BigDecimal price, String description,
            String availabilityStatus, String serviceType, LocalDateTime createdDate,
            LocalDateTime lastUpdatedDate, String createdBy, String lastUpdatedBy,
            String serviceImage) {
        this.serviceID = serviceID;
        this.serviceName = serviceName;
        this.price = price;
        this.description = description;
        this.availabilityStatus = availabilityStatus;
        this.serviceType = serviceType;
        this.createdDate = createdDate;
        this.lastUpdatedDate = lastUpdatedDate;
        this.createdBy = createdBy;
        this.lastUpdatedBy = lastUpdatedBy;
        this.serviceImage = serviceImage;
    }

    // Getters and setters
    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(String availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    public void setLastUpdatedDate(LocalDateTime lastUpdatedDate) {
        this.lastUpdatedDate = lastUpdatedDate;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getLastUpdatedBy() {
        return lastUpdatedBy;
    }

    public void setLastUpdatedBy(String lastUpdatedBy) {
        this.lastUpdatedBy = lastUpdatedBy;
    }

    public String getServiceImage() {
        return serviceImage;
    }

    public void setServiceImage(String serviceImage) {
        this.serviceImage = serviceImage;
    }

    public void setStatus(boolean status) {
        this.availabilityStatus = status ? "Available" : "Unavailable";
    }

}
