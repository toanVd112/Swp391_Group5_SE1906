package model;

public class RevenueStats {
    private String category;
    private double amount;
    private String type; // Room or Service

    public RevenueStats() {}

    public RevenueStats(String category, double amount, String type) {
        this.category = category;
        this.amount = amount;
        this.type = type;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // Thêm phương thức toLocaleString cho JSP
    public String getAmountFormatted() {
        return String.format("%,.0f", amount).replace(",", ".") + " VND";
    }
}