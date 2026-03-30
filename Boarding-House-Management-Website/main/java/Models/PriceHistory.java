/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author huuda
 */
public class PriceHistory {

    private int priceId;
    private int categoryId;
    private BigDecimal priceAmount;
    private LocalDate effectiveFrom;
    private LocalDateTime createdAt;
    private boolean isDeleted;

    public PriceHistory() {
    }

    public PriceHistory(int priceId, int categoryId, BigDecimal priceAmount, LocalDate effectiveFrom, LocalDateTime createdAt, boolean isDeleted) {
        this.priceId = priceId;
        this.categoryId = categoryId;
        this.priceAmount = priceAmount;
        this.effectiveFrom = effectiveFrom;
        this.createdAt = createdAt;
        this.isDeleted = isDeleted;
    }

    public int getPriceId() {
        return priceId;
    }

    public void setPriceId(int priceId) {
        this.priceId = priceId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getPriceAmount() {
        return priceAmount;
    }

    public void setPriceAmount(BigDecimal priceAmount) {
        this.priceAmount = priceAmount;
    }

    public LocalDate getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(LocalDate effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
}
