package Models;

import java.math.BigDecimal;

public class RoomCategory {

    private int        categoryId;
    private String     categoryName;
    private String     description;
    private BigDecimal basePrice;
    private boolean    isDeleted;

    // transient — filled by JOIN query
    private int roomCount;

    public RoomCategory() {}

    public RoomCategory(int categoryId, String categoryName,
                        String description, BigDecimal basePrice, boolean isDeleted) {
        this.categoryId   = categoryId;
        this.categoryName = categoryName;
        this.description  = description;
        this.basePrice    = basePrice;
        this.isDeleted    = isDeleted;
    }

    public int        getCategoryId()   { return categoryId; }
    public String     getCategoryName() { return categoryName; }
    public String     getDescription()  { return description; }
    public BigDecimal getBasePrice()    { return basePrice; }
    public boolean    isIsDeleted()     { return isDeleted; }
    public int        getRoomCount()    { return roomCount; }

    public void setCategoryId(int categoryId)       { this.categoryId = categoryId; }
    public void setCategoryName(String n)           { this.categoryName = n; }
    public void setDescription(String d)            { this.description = d; }
    public void setBasePrice(BigDecimal p)          { this.basePrice = p; }
    public void setIsDeleted(boolean b)             { this.isDeleted = b; }
    public void setRoomCount(int roomCount)         { this.roomCount = roomCount; }
}
