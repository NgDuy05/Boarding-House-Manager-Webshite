package Models;

import java.sql.Date;

public class UtilityUsage {

    private int usageId;
    private int roomId;
    private int utilityId;
    private Date period;
    private int oldValue;
    private int newValue;
    private Date createdAt;

    // joined fields
    private String roomNumber;
    private String utilityName;
    private String unit;

    public UtilityUsage() {
    }

    public UtilityUsage(int usageId, int roomId, int utilityId, Date period, int oldValue, int newValue, Date createdAt) {
        this.usageId = usageId;
        this.roomId = roomId;
        this.utilityId = utilityId;
        this.period = period;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.createdAt = createdAt;
    }

    public int getUsageId() { return usageId; }
    public void setUsageId(int usageId) { this.usageId = usageId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public int getUtilityId() { return utilityId; }
    public void setUtilityId(int utilityId) { this.utilityId = utilityId; }

    public Date getPeriod() { return period; }
    public void setPeriod(Date period) { this.period = period; }

    public int getOldValue() { return oldValue; }
    public void setOldValue(int oldValue) { this.oldValue = oldValue; }

    public int getNewValue() { return newValue; }
    public void setNewValue(int newValue) { this.newValue = newValue; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getUtilityName() { return utilityName; }
    public void setUtilityName(String utilityName) { this.utilityName = utilityName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public int getConsumption() {
        return newValue - oldValue;
    }
}
