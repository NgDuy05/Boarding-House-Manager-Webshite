package Models;

import java.sql.Date;

public class Amenity {

    private int amenityId;
    private String amenityName;
    private String description;
    private Date createdAt;
    private boolean isDeleted;

    public Amenity() {
    }

    public Amenity(int amenityId, String amenityName, String description, Date createdAt, boolean isDeleted) {
        this.amenityId = amenityId;
        this.amenityName = amenityName;
        this.description = description;
        this.createdAt = createdAt;
        this.isDeleted = isDeleted;
    }

    public int getAmenityId() { return amenityId; }
    public void setAmenityId(int amenityId) { this.amenityId = amenityId; }

    public String getAmenityName() { return amenityName; }
    public void setAmenityName(String amenityName) { this.amenityName = amenityName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public boolean isIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }
}
