package Models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Maps to the deposit_transaction table.
 * Tracks deposit, refund, and deduction events for a contract.
 */
public class DepositTransaction {

    // ── transaction_type constants ────────────────────────────────────────
    public static final String TYPE_DEPOSIT   = "deposit";
    public static final String TYPE_REFUND    = "refund";
    public static final String TYPE_DEDUCTION = "deduction";

    private int            depositId;
    private int            contractId;
    private BigDecimal     amount;
    private String         transactionType;  // deposit | refund | deduction
    private String         note;
    private LocalDateTime  createdAt;
    private int            createdBy;        // FK -> user

    // ── joined / display fields (not persisted) ───────────────────────────
    private String         roomNumber;
    private String         createdByName;

    public DepositTransaction() {}

    // ── Getters / Setters ─────────────────────────────────────────────────

    public int getDepositId()                          { return depositId; }
    public void setDepositId(int depositId)            { this.depositId = depositId; }

    public int getContractId()                         { return contractId; }
    public void setContractId(int contractId)          { this.contractId = contractId; }

    public BigDecimal getAmount()                      { return amount; }
    public void setAmount(BigDecimal amount)           { this.amount = amount; }

    public String getTransactionType()                 { return transactionType; }
    public void setTransactionType(String type)        { this.transactionType = type; }

    public String getNote()                            { return note; }
    public void setNote(String note)                   { this.note = note; }

    public LocalDateTime getCreatedAt()                { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)  { this.createdAt = createdAt; }

    public int getCreatedBy()                          { return createdBy; }
    public void setCreatedBy(int createdBy)            { this.createdBy = createdBy; }

    public String getRoomNumber()                      { return roomNumber; }
    public void setRoomNumber(String roomNumber)       { this.roomNumber = roomNumber; }

    public String getCreatedByName()                   { return createdByName; }
    public void setCreatedByName(String name)          { this.createdByName = name; }

    /** Human-readable label for the transaction type */
    public String getTypeLabel() {
        if (transactionType == null) return "";
        switch (transactionType) {
            case TYPE_DEPOSIT:   return "Deposit";
            case TYPE_REFUND:    return "Refund";
            case TYPE_DEDUCTION: return "Deduction";
            default:             return transactionType;
        }
    }
}
