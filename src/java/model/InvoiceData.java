package model;

import java.time.LocalDate;

public class InvoiceData {
    private int bookingId;
    private String customerName;
    private LocalDate issuedDate;

    private double roomTotal;
    private double serviceTotal;
    private String discountCode;
    private int discountPercent;
    private double totalAmount;

    // Getters & Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public LocalDate getIssuedDate() { return issuedDate; }
    public void setIssuedDate(LocalDate issuedDate) { this.issuedDate = issuedDate; }

    public double getRoomTotal() { return roomTotal; }
    public void setRoomTotal(double roomTotal) { this.roomTotal = roomTotal; }

    public double getServiceTotal() { return serviceTotal; }
    public void setServiceTotal(double serviceTotal) { this.serviceTotal = serviceTotal; }

    public String getDiscountCode() { return discountCode; }
    public void setDiscountCode(String discountCode) { this.discountCode = discountCode; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}
