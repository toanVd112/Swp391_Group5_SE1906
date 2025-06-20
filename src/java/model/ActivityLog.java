package model;

import java.sql.Timestamp;

public class ActivityLog {
    private int logId;
    private int actorId;
    private String actionType;
    private String targetTable;
    private int targetId;
    private String description;
    private String ipAddress;
    private Timestamp actionTime;
    private String username;
    private String role;

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getActorId() { return actorId; }
    public void setActorId(int actorId) { this.actorId = actorId; }

    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }

    public String getTargetTable() { return targetTable; }
    public void setTargetTable(String targetTable) { this.targetTable = targetTable; }

    public int getTargetId() { return targetId; }
    public void setTargetId(int targetId) { this.targetId = targetId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Timestamp getActionTime() { return actionTime; }
    public void setActionTime(Timestamp actionTime) { this.actionTime = actionTime; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}