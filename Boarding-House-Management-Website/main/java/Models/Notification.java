package Models;

import java.sql.Timestamp;

public class Notification {

    private int       notificationId;
    private int       createdBy;
    private String    createdByName;   // populated by JOIN with [user]
    private String    title;
    private String    content;
    private Integer   targetContractId; // null = broadcast to all
    private Timestamp createdAt;
    private boolean   isDeleted;

    public Notification() {}

    public Notification(int createdBy, String title, String content,
                        Integer targetContractId, boolean isDeleted) {
        this.createdBy       = createdBy;
        this.title           = title;
        this.content         = content;
        this.targetContractId = targetContractId;
        this.isDeleted       = isDeleted;
    }

    // ── Getters ──────────────────────────────────────────────────────────────
    public int       getNotificationId()    { return notificationId; }
    public int       getCreatedBy()         { return createdBy; }
    public String    getCreatedByName()     { return createdByName; }
    public String    getTitle()             { return title; }
    public String    getContent()           { return content; }
    public Integer   getTargetContractId()  { return targetContractId; }
    public Timestamp getCreatedAt()         { return createdAt; }
    public boolean   isIsDeleted()          { return isDeleted; }

    /** Convenience: true when targetContractId is null (broadcast to everyone). */
    public boolean isBroadcast() { return targetContractId == null; }

    // ── Setters ──────────────────────────────────────────────────────────────
    public void setNotificationId(int notificationId)       { this.notificationId = notificationId; }
    public void setCreatedBy(int createdBy)                 { this.createdBy = createdBy; }
    public void setCreatedByName(String createdByName)      { this.createdByName = createdByName; }
    public void setTitle(String title)                      { this.title = title; }
    public void setContent(String content)                  { this.content = content; }
    public void setTargetContractId(Integer id)             { this.targetContractId = id; }
    public void setCreatedAt(Timestamp createdAt)           { this.createdAt = createdAt; }
    public void setIsDeleted(boolean isDeleted)             { this.isDeleted = isDeleted; }
}
