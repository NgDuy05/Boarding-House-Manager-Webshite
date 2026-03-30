package Models;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Contract {

    private int contractId;
    private int roomId;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal deposit;
    private String status;
    private boolean isDeleted;

    // Denormalized fields from JOINs (populated by rich DAO queries)
    private String     roomNumber;
    private String     categoryName;
    private BigDecimal basePrice;
    private LocalDate  createdAt;
    private String     primaryTenantName;
    private String     primaryTenantUsername;
    private int        tenantCount;

    public Contract() {
    }

    public Contract(int contractId, int roomId, LocalDate startDate, LocalDate endDate, BigDecimal deposit, String status, boolean isDeleted) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.deposit = deposit;
        this.status = status;
        this.isDeleted = isDeleted;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }

    // ---- denormalized getters/setters ----
    public String     getRoomNumber()              { return roomNumber; }
    public void       setRoomNumber(String v)      { this.roomNumber = v; }

    public String     getCategoryName()            { return categoryName; }
    public void       setCategoryName(String v)    { this.categoryName = v; }

    public BigDecimal getBasePrice()               { return basePrice; }
    public void       setBasePrice(BigDecimal v)   { this.basePrice = v; }

    public LocalDate  getCreatedAt()               { return createdAt; }
    public void       setCreatedAt(LocalDate v)    { this.createdAt = v; }

    public String     getPrimaryTenantName()       { return primaryTenantName; }
    public void       setPrimaryTenantName(String v) { this.primaryTenantName = v; }

    public String     getPrimaryTenantUsername()   { return primaryTenantUsername; }
    public void       setPrimaryTenantUsername(String v) { this.primaryTenantUsername = v; }

    public int        getTenantCount()             { return tenantCount; }
    public void       setTenantCount(int v)        { this.tenantCount = v; }

    // ---- status helper ----
    public String getStatusLabel() {
        if (status == null) return "Unknown";
        switch (status.toLowerCase()) {
            case "active":     return "Active";
            case "terminated": return "Terminated";
            case "expired":    return "Expired";
            default:           return status;
        }
    }
    public String getStatusColor() {
        if (status == null) return "secondary";
        switch (status.toLowerCase()) {
            case "active":     return "success";
            case "terminated": return "danger";
            case "expired":    return "secondary";
            default:           return "warning";
        }
    }
}
