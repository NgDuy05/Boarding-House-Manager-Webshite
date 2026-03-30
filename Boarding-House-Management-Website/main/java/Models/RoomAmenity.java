package Models;

/**
 * DTO combining facility info + quantity for a specific room.
 */
public class RoomAmenity {

    private int    facilityId;
    private String facilityName;
    private String description;
    private String image;
    private int    quantity;

    public RoomAmenity() {}

    public RoomAmenity(int facilityId, String facilityName,
                       String description, String image, int quantity) {
        this.facilityId   = facilityId;
        this.facilityName = facilityName;
        this.description  = description;
        this.image        = image;
        this.quantity     = quantity;
    }

    public int    getFacilityId()   { return facilityId; }
    public String getFacilityName() { return facilityName; }
    public String getDescription()  { return description; }
    public String getImage()        { return image; }
    public int    getQuantity()     { return quantity; }

    public void setFacilityId(int facilityId)       { this.facilityId = facilityId; }
    public void setFacilityName(String facilityName){ this.facilityName = facilityName; }
    public void setDescription(String description)  { this.description = description; }
    public void setImage(String image)              { this.image = image; }
    public void setQuantity(int quantity)           { this.quantity = quantity; }
}
