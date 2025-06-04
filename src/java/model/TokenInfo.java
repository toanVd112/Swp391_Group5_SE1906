/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author AD
 */
public class TokenInfo {
    private int id;
    private String token;
    private Timestamp expiryTime;
    private boolean isUsed;
    private int accountId;

    // Constructors
    public TokenInfo() {}

    public TokenInfo(int id, String token, Timestamp expiryTime, boolean isUsed, int accountId) {
        this.id = id;
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.accountId = accountId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
    public Timestamp getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Timestamp expiryTime) {
        this.expiryTime = expiryTime;
    }
    
    public boolean isUsed() {
        return isUsed;
    }
    public void setUsed(boolean used) {
        isUsed = used;
    }
    public int getAccountId() {
        return accountId;
    }
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
    
    
}
