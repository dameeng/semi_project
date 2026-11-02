package com.mbc.project.dto;

import java.time.LocalDateTime;

public class OwnerDiscountDto {
    private Long discountId;
    private Long recordId;
    private Integer storeNum;
    private Integer freeMin;
    private String id;          // 할인을 적용한 점주 id
    private LocalDateTime createdAt;

    // 조인용 필드 프라이빗으로 묶어둠
    private String carNum;
    private LocalDateTime entryTime;

    
    public Long getDiscountId() { return discountId; }
    public void setDiscountId(Long discountId) { this.discountId = discountId; }
    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }
    public Integer getStoreNum() { return storeNum; }
    public void setStoreNum(Integer storeNum) { this.storeNum = storeNum; }
    public Integer getFreeMin() { return freeMin; }
    public void setFreeMin(Integer freeMin) { this.freeMin = freeMin; }
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCarNum() { return carNum; }
    public void setCarNum(String carNum) { this.carNum = carNum; }
    public LocalDateTime getEntryTime() { return entryTime; }
    public void setEntryTime(LocalDateTime entryTime) { this.entryTime = entryTime; }
}