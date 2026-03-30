/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;

/**
 *
 * @author huudanh
 */
public class BillItem {

    private int billItemId;
    private int billId;
    private int categoryId;
    private String description;
    private BigDecimal quantity;
    private BigDecimal unitPrice;

    public BillItem() {
    }

    public BillItem(int billItemId, int billId, int categoryId, String description, BigDecimal quantity, BigDecimal unitPrice) {
        this.billItemId = billItemId;
        this.billId = billId;
        this.categoryId = categoryId;
        this.description = description;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getBillItemId() {
        return billItemId;
    }

    public void setBillItemId(int billItemId) {
        this.billItemId = billItemId;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
}
