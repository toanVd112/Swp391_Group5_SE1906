package model;

import java.sql.Timestamp;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author MyPC
 */
public class MaintenanceRequest {
    private int requestID;
    private int roomID;
    private int staffID;
    private Timestamp requestDate;
    private String description;
    private boolean isResolved;
    private Timestamp resolutionDate;

    public MaintenanceRequest(int requestID, int roomID, int staffID, Timestamp requestDate, String description, boolean isResolved, Timestamp resolutionDate) {
        this.requestID = requestID;
        this.roomID = roomID;
        this.staffID = staffID;
        this.requestDate = requestDate;
        this.description = description;
        this.isResolved = isResolved;
        this.resolutionDate = resolutionDate;
    }

    public MaintenanceRequest() {
    }
    

    public int getRequestID() {
        return requestID;
    }

    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsResolved() {
        return isResolved;
    }

    public void setIsResolved(boolean isResolved) {
        this.isResolved = isResolved;
    }

    public Timestamp getResolutionDate() {
        return resolutionDate;
    }

    public void setResolutionDate(Timestamp resolutionDate) {
        this.resolutionDate = resolutionDate;
    }
    
    
}
