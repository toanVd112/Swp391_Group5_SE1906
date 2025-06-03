// src/main/java/com/example/model/Service.java
package model;

import java.math.BigDecimal;
import java.sql.Timestamp; // Hoặc java.util.Date nếu bạn không cần độ chính xác cao

public class Service {
    private int serviceID;
    private String serviceName;
    private BigDecimal price;
    private String description;
    private String availabilityStatus;
    private String serviceType;
    private Timestamp createdDate; // Sử dụng Timestamp cho datetime
    private Timestamp lastUpdatedDate;
    private String createdBy;
    private String lastUpdatedBy;
    private String serviceImage;

    // Constructors
    public Service() {
    }

    public Service(int serviceID, String serviceName, BigDecimal price, String description, String availabilityStatus, String serviceType, Timestamp createdDate, Timestamp lastUpdatedDate, String createdBy, String lastUpdatedBy, String serviceImage) {
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

    // Getters and Setters
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

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    public void setLastUpdatedDate(Timestamp lastUpdatedDate) {
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

    @Override
    public String toString() {
        return "Service{" +
               "serviceID=" + serviceID +
               ", serviceName='" + serviceName + '\'' +
               ", price=" + price +
               ", availabilityStatus='" + availabilityStatus + '\'' +
               ", serviceType='" + serviceType + '\'' +
               '}';
    }
}