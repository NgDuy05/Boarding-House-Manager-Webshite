package Models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ActivityLog {

    private String activityType;
    private int userId;
    private String username;
    private String fullName;
    private LocalDateTime activityDate;
    private String description;
    private Integer relatedId;

    public ActivityLog() {}

    public ActivityLog(String activityType, int userId, String username, String fullName,
                       LocalDateTime activityDate, String description, Integer relatedId) {
        this.activityType = activityType;
        this.userId       = userId;
        this.username     = username;
        this.fullName     = fullName;
        this.activityDate = activityDate;
        this.description  = description;
        this.relatedId    = relatedId;
    }

    // ---- icon / badge helpers used in JSP ----

    public String getIcon() {
        switch (activityType) {
            case "ACCOUNT_CREATED":  return "bi-person-plus-fill";
            case "CONTRACT_JOINED":  return "bi-file-earmark-check-fill";
            case "CONTRACT_LEFT":    return "bi-file-earmark-x-fill";
            case "BILL_CREATED":     return "bi-receipt";
            case "BILL_PAID":        return "bi-check-circle-fill";
            case "SERVICE_USED":     return "bi-tools";
            case "UTILITY_READING":  return "bi-lightning-charge-fill";
            default:                 return "bi-activity";
        }
    }

    public String getColorClass() {
        switch (activityType) {
            case "ACCOUNT_CREATED":  return "success";
            case "CONTRACT_JOINED":  return "primary";
            case "CONTRACT_LEFT":    return "secondary";
            case "BILL_CREATED":     return "warning";
            case "BILL_PAID":        return "success";
            case "SERVICE_USED":     return "info";
            case "UTILITY_READING":  return "warning";
            default:                 return "secondary";
        }
    }

    public String getLabel() {
        switch (activityType) {
            case "ACCOUNT_CREATED":  return "Account Created";
            case "CONTRACT_JOINED":  return "Contract Joined";
            case "CONTRACT_LEFT":    return "Contract Left";
            case "BILL_CREATED":     return "Bill Issued";
            case "BILL_PAID":        return "Bill Paid";
            case "SERVICE_USED":     return "Service Used";
            case "UTILITY_READING":  return "Utility Reading";
            default:                 return activityType;
        }
    }

    private static final DateTimeFormatter DATE_FMT     = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FMT     = DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    public String getFormattedDate()     { return activityDate != null ? activityDate.format(DATE_FMT)     : ""; }
    public String getFormattedTime()     { return activityDate != null ? activityDate.format(TIME_FMT)     : ""; }
    public String getFormattedDateTime() { return activityDate != null ? activityDate.format(DATETIME_FMT) : ""; }

    public String getActivityType()    { return activityType; }
    public void setActivityType(String t) { this.activityType = t; }

    public int getUserId()             { return userId; }
    public void setUserId(int id)      { this.userId = id; }

    public String getUsername()        { return username; }
    public void setUsername(String u)  { this.username = u; }

    public String getFullName()        { return fullName; }
    public void setFullName(String n)  { this.fullName = n; }

    public LocalDateTime getActivityDate()         { return activityDate; }
    public void setActivityDate(LocalDateTime d)   { this.activityDate = d; }

    public String getDescription()            { return description; }
    public void setDescription(String desc)   { this.description = desc; }

    public Integer getRelatedId()             { return relatedId; }
    public void setRelatedId(Integer id)      { this.relatedId = id; }
}
