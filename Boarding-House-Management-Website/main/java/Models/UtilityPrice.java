package Models;

import java.math.BigDecimal;
import java.sql.Date;

public class UtilityPrice {

    private int priceId;
    private int utilityId;
    private BigDecimal price;
    private Date effectiveFrom;
    private Date createdAt;

    // joined field
    private String utilityName;

    public UtilityPrice() {
    }

    public UtilityPrice(int priceId, int utilityId, BigDecimal price, Date effectiveFrom, Date createdAt) {
        this.priceId = priceId;
        this.utilityId = utilityId;
        this.price = price;
        this.effectiveFrom = effectiveFrom;
        this.createdAt = createdAt;
    }

    public int getPriceId() { return priceId; }
    public void setPriceId(int priceId) { this.priceId = priceId; }

    public int getUtilityId() { return utilityId; }
    public void setUtilityId(int utilityId) { this.utilityId = utilityId; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Date getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(Date effectiveFrom) { this.effectiveFrom = effectiveFrom; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getUtilityName() { return utilityName; }
    public void setUtilityName(String utilityName) { this.utilityName = utilityName; }
}
