package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Account implements Serializable{

    private int accountID;
    private String username;
    private String password;
    private String role;
    private boolean isActive;
    private Timestamp createdAt;
    private String email;
    
    public Account(){}

    public Account(int accountID, String username, String password, String role, boolean isActive, Timestamp createdAt, String email) {
        this.accountID = accountID;
        this.username = username;
        this.password = password;
        this.role = role;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.email = email;
    }

    public Account(int accountID, String username, String password, String role, boolean isActive, String email) {
        this.accountID = accountID;
        this.username = username;
        this.password = password;
        this.role = role;
        this.isActive = isActive;
        this.email = email;
    }
    

    // Getters và Setters////////////////////////////////
    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
