package model;

import java.time.LocalDate;

public class DiscountCode {
    private int discountCodeID;
    private String code;
    private double discountPercent;
    private LocalDate expiryDate;
    private String type; // "1" for percentage, "2" for fixed amount
    private String status; // "Active" or "Inactive"

    // Constructor
    public DiscountCode() {
    }

    public DiscountCode(int discountCodeID, String code, double discountPercent, LocalDate expiryDate, String type, String status) {
        this.discountCodeID = discountCodeID;
        this.code = code;
        this.discountPercent = discountPercent;
        this.expiryDate = expiryDate;
        this.type = type;
        this.status = status;
    }

    // Getters and Setters
    public int getDiscountCodeID() {
        return discountCodeID;
    }

    public void setDiscountCodeID(int discountCodeID) {
        this.discountCodeID = discountCodeID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
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
}