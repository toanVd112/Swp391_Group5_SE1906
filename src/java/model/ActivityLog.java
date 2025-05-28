/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */


import java.sql.Timestamp;

public class ActivityLog {
    private int logID;
    private int actorID;
    private String actionType;
    private String targetTable;
    private int targetID;
    private Timestamp actionTime;

    public ActivityLog() {
    }

    public ActivityLog(int logID, int actorID, String actionType, String targetTable, int targetID, Timestamp actionTime) {
        this.logID = logID;
        this.actorID = actorID;
        this.actionType = actionType;
        this.targetTable = targetTable;
        this.targetID = targetID;
        this.actionTime = actionTime;
    }

    public int getLogID() {
        return logID;
    }

    public void setLogID(int logID) {
        this.logID = logID;
    }

    public int getActorID() {
        return actorID;
    }

    public void setActorID(int actorID) {
        this.actorID = actorID;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getTargetTable() {
        return targetTable;
    }

    public void setTargetTable(String targetTable) {
        this.targetTable = targetTable;
    }

    public int getTargetID() {
        return targetID;
    }

    public void setTargetID(int targetID) {
        this.targetID = targetID;
    }

    public Timestamp getActionTime() {
        return actionTime;
    }

    public void setActionTime(Timestamp actionTime) {
        this.actionTime = actionTime;
    }
}
