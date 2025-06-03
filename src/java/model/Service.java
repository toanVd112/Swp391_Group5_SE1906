package model;

import java.time.LocalDateTime;

public class Service {
    private int id;
    private String name;
    private int price;
    private String description;
    private String status;
    private String type;
    private LocalDateTime createDate;
    private LocalDateTime lastUpdateDate;
    private String createdBy;
    private String lastUpdateBy;
    private String serviceImage;

    public Service() {
    }

    public Service(int id, String name, int price, String description, String status, String type, LocalDateTime createDate, LocalDateTime lastUpdateDate, String createdBy, String lastUpdateBy, String serviceImage) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.status = status;
        this.type = type;
        this.createDate = createDate;
        this.lastUpdateDate = lastUpdateDate;
        this.createdBy = createdBy;
        this.lastUpdateBy = lastUpdateBy;
        this.serviceImage = serviceImage;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }

    public LocalDateTime getLastUpdateDate() {
        return lastUpdateDate;
    }

    public void setLastUpdateDate(LocalDateTime lastUpdateDate) {
        this.lastUpdateDate = lastUpdateDate;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getLastUpdateBy() {
        return lastUpdateBy;
    }

    public void setLastUpdateBy(String lastUpdateBy) {
        this.lastUpdateBy = lastUpdateBy;
    }

    public String getServiceImage() {
        return serviceImage;
    }

    public void setServiceImage(String serviceImage) {
        this.serviceImage = serviceImage;
    }

    
}