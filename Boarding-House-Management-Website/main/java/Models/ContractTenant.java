package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents a person living in a rented room under a contract.
 * May or may not have a system account (unlike ContractUser which requires user_id).
 */
public class ContractTenant {

    private int           tenantId;
    private int           contractId;
    private String        fullName;
    private String        phone;
    private String        cccd;         // CCCD / citizen ID
    private LocalDate     birthDate;
    private boolean       isPrimary;    // true = main renter
    private LocalDateTime createdAt;

    // Extra fields populated when querying resident history across contracts
    private LocalDate contractStartDate;
    private LocalDate contractEndDate;
    private String    contractStatus;

    public ContractTenant() {}

    // ── Getters / Setters ─────────────────────────────────────────────────

    public int getTenantId()                     { return tenantId; }
    public void setTenantId(int tenantId)        { this.tenantId = tenantId; }

    public int getContractId()                   { return contractId; }
    public void setContractId(int contractId)    { this.contractId = contractId; }

    public String getFullName()                  { return fullName; }
    public void setFullName(String fullName)     { this.fullName = fullName; }

    public String getPhone()                     { return phone; }
    public void setPhone(String phone)           { this.phone = phone; }

    public String getCccd()                      { return cccd; }
    public void setCccd(String cccd)             { this.cccd = cccd; }

    public LocalDate getBirthDate()              { return birthDate; }
    public void setBirthDate(LocalDate birthDate){ this.birthDate = birthDate; }

    public boolean isPrimary()                   { return isPrimary; }
    public void setPrimary(boolean isPrimary)    { this.isPrimary = isPrimary; }

    public LocalDateTime getCreatedAt()          { return createdAt; }
    public void setCreatedAt(LocalDateTime v)    { this.createdAt = v; }

    public LocalDate getContractStartDate()                      { return contractStartDate; }
    public void setContractStartDate(LocalDate contractStartDate){ this.contractStartDate = contractStartDate; }

    public LocalDate getContractEndDate()                        { return contractEndDate; }
    public void setContractEndDate(LocalDate contractEndDate)    { this.contractEndDate = contractEndDate; }

    public String getContractStatus()                            { return contractStatus; }
    public void setContractStatus(String contractStatus)         { this.contractStatus = contractStatus; }

    /** "Owner" for primary, "Co-tenant" for others — for display */
    public String getRoleLabel() {
        return isPrimary ? "Primary Renter" : "Co-tenant";
    }
}
