/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author huuda
 */
public class PriceCategory {

    private int categoryId;
    private String categoryCode;
    private String categoryType;
    private String unit;
    private boolean isDeleted;

    public PriceCategory() {
    }

    public PriceCategory(int categoryId, String categoryCode, String categoryType, String unit, boolean isDeleted) {
        this.categoryId = categoryId;
        this.categoryCode = categoryCode;
        this.categoryType = categoryType;
        this.unit = unit;
        this.isDeleted = isDeleted;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryType() {
        return categoryType;
    }

    public void setCategoryType(String categoryType) {
        this.categoryType = categoryType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

}
