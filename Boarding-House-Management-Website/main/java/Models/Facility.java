/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author huudanh
 */
public class Facility {

    private int facilityId;
    private String facilityName;
    private int categoryId;
    private String description;
    private String image;
    private boolean isDeleted;

    public Facility() {
    }

    public Facility(int facilityId, String facilityName, int categoryId, String description, String image, boolean isDeleted) {
        this.facilityId = facilityId;
        this.facilityName = facilityName;
        this.categoryId = categoryId;
        this.description = description;
        this.image = image;
        this.isDeleted = isDeleted;
    }

    public int getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(int facilityId) {
        this.facilityId = facilityId;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

}
