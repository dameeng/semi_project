package com.mbc.project.dto;

import java.security.Timestamp;

public class ParkingSpotDto {
    private String spotId;
    private Integer parkingFloor;
    private String section;
    private String parkingType;
    private Long recordId;
    private Timestamp updatedAt;
    
    // 조인용 필드 (차량번호)
    private String carNum;

    // Getter & Setter
    public String getSpotId() { return spotId; }
    public void setSpotId(String spotId) { this.spotId = spotId; }

    public Integer getParkingFloor() { return parkingFloor; }
    public void setParkingFloor(Integer parkingFloor) { this.parkingFloor = parkingFloor; }

    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }

    public String getParkingType() { return parkingType; }
    public void setParkingType(String parkingType) { this.parkingType = parkingType; }

    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCarNum() { return carNum; }
    public void setCarNum(String carNum) { this.carNum = carNum; }
}