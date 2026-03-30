package Models;

import java.sql.Date;

public class Utility {

    private int utilityId;
    private String utilityName;
    private String unit;
    private String description;
    private Date createdAt;
    private boolean isDeleted;

    public Utility() {
    }

    public Utility(int utilityId, String utilityName, String unit, String description, Date createdAt, boolean isDeleted) {
        this.utilityId = utilityId;
        this.utilityName = utilityName;
        this.unit = unit;
        this.description = description;
        this.createdAt = createdAt;
        this.isDeleted = isDeleted;
    }

    public int getUtilityId() { return utilityId; }
    public void setUtilityId(int utilityId) { this.utilityId = utilityId; }

    public String getUtilityName() { return utilityName; }
    public void setUtilityName(String utilityName) { this.utilityName = utilityName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public boolean isIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }
}
