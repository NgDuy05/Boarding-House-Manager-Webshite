/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 *
 * @author huuda
 */
public class Bill {

    private int billId;
    private int contractId;
    private LocalDate period;
    private LocalDate dueDate;
    private BigDecimal totalAmount;
    private String status;
    private boolean isDeleted;

    // joined / display field (not persisted)
    private String roomNumber;

    public Bill() {
    }

    public Bill(int billId, int contractId, LocalDate period, LocalDate dueDate, BigDecimal totalAmount, String status, boolean isDeleted) {
        this.billId = billId;
        this.contractId = contractId;
        this.period = period;
        this.dueDate = dueDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.isDeleted = isDeleted;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public LocalDate getPeriod() {
        return period;
    }

    public void setPeriod(LocalDate period) {
        this.period = period;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

}
