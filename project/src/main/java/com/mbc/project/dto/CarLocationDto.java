package com.mbc.project.dto;

import java.time.LocalDateTime;

public class CarLocationDto {
	private String carNum;
    private Integer parkingFloor;
    private LocalDateTime entryTime;
    private Boolean isParking = true; // 현재 주차 중 여부
    private String parkingZone; // 👈 추가 (예: "A-05")

    // Getter & Setter
    public String getCarNum() { return carNum; }
    public void setCarNum(String carNum) { this.carNum = carNum; }
    public Integer getParkingFloor() { return parkingFloor; }
    public void setParkingFloor(Integer parkingFloor) { this.parkingFloor = parkingFloor; }
    public LocalDateTime getEntryTime() { return entryTime; }
    public void setEntryTime(LocalDateTime entryTime) { this.entryTime = entryTime; }
    public Boolean getIsParking() { return isParking; }
    public void setIsParking(Boolean isParking) { this.isParking = isParking; }
    public String getParkingZone() { return parkingZone; }
    public void setParkingZone(String parkingZone) { this.parkingZone = parkingZone; }
}
