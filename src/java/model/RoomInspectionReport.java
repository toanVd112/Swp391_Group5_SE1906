/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author MyPC
 */
public class RoomInspectionReport {
    private int reportID;
    private int bookingID;
    private int roomID;
    private int staffID;
    private Timestamp inspectionTime;
    private Boolean isRoomOk;
    private String notes;

    public RoomInspectionReport(int reportID, int bookingID, int roomID, int staffID, Timestamp inspectionTime, Boolean isRoomOk, String notes) {
        this.reportID = reportID;
        this.bookingID = bookingID;
        this.roomID = roomID;
        this.staffID = staffID;
        this.inspectionTime = inspectionTime;
        this.isRoomOk = isRoomOk;
        this.notes = notes;
    }

    public RoomInspectionReport(int bookingID, int roomID) {
        this.bookingID = bookingID;
        this.roomID = roomID;
    }

    public RoomInspectionReport() {
    }

    

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
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

    public Timestamp getInspectionTime() {
        return inspectionTime;
    }

    public void setInspectionTime(Timestamp inspectionTime) {
        this.inspectionTime = inspectionTime;
    }

    public Boolean getIsRoomOk() {
        return isRoomOk;
    }

    public void setIsRoomOk(Boolean isRoomOk) {
        this.isRoomOk = isRoomOk;
    }

    

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    
}
