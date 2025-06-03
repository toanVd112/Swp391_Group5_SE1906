package model;

import java.time.LocalDateTime;

public class Service {
    private int id;
    private String name;
    private int price;
    private String type;
    private String status;
    private String createdBy;
    private LocalDateTime createDate;

    // Constructor
    public Service(int id, String name, int price, String type, String status, String createdBy, LocalDateTime createDate) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.type = type;
        this.status = status;
        this.createdBy = createdBy;
        this.createDate = createDate;
    }

    // Getters and Setters
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }
}