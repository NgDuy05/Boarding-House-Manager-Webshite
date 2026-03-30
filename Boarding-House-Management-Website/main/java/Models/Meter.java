/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;

/**
 *
 * @author huuda
 */
public class Meter {

    private int meterId;
    private int roomId;
    private LocalDate period;
    private Integer electricityOld;
    private Integer electricityNew;
    private Integer waterOld;
    private Integer waterNew;

    public Meter() {
    }

    public Meter(int meterId, int roomId, LocalDate period, Integer electricityOld, Integer electricityNew, Integer waterOld, Integer waterNew) {
        this.meterId = meterId;
        this.roomId = roomId;
        this.period = period;
        this.electricityOld = electricityOld;
        this.electricityNew = electricityNew;
        this.waterOld = waterOld;
        this.waterNew = waterNew;
    }

    public int getMeterId() {
        return meterId;
    }

    public void setMeterId(int meterId) {
        this.meterId = meterId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public LocalDate getPeriod() {
        return period;
    }

    public void setPeriod(LocalDate period) {
        this.period = period;
    }

    public Integer getElectricityOld() {
        return electricityOld;
    }

    public void setElectricityOld(Integer electricityOld) {
        this.electricityOld = electricityOld;
    }

    public Integer getElectricityNew() {
        return electricityNew;
    }

    public void setElectricityNew(Integer electricityNew) {
        this.electricityNew = electricityNew;
    }

    public Integer getWaterOld() {
        return waterOld;
    }

    public void setWaterOld(Integer waterOld) {
        this.waterOld = waterOld;
    }

    public Integer getWaterNew() {
        return waterNew;
    }

    public void setWaterNew(Integer waterNew) {
        this.waterNew = waterNew;
    }
    
}
