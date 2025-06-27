package model;

public class RevenueStats {
    private String category;
    private double amount;

    // Constructor
    public RevenueStats() {}

    public RevenueStats(String category, double amount) {
        this.category = category;
        this.amount = amount;
    }

    // Getters and Setters
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
}