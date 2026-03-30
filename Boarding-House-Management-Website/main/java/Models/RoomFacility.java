/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author huudanh
 */
public class RoomFacility {

    private int roomId;
    private int facilityId;
    private int quantity;
    private boolean isDeleted;

    public RoomFacility() {
    }

    public RoomFacility(int roomId, int facilityId, int quantity, boolean isDeleted) {
        this.roomId = roomId;
        this.facilityId = facilityId;
        this.quantity = quantity;
        this.isDeleted = isDeleted;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(int facilityId) {
        this.facilityId = facilityId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

}
