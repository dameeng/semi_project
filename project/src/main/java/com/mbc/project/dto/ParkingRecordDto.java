package com.mbc.project.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ParkingRecordDto implements Serializable {

    // 1. 기존 parking_records 테이블 관련 필드
    private Long recordId;              // 입출차 기록 고유 ID (PK)
    private String carNum;              // 차량 번호
    private Integer parkingFloor;       // 주차 층수
    private LocalDateTime entryTime;    // 입차 시간
    private LocalDateTime exitTime;     // 출차 시간 (미출차 시 null)
    private Integer totalMin;           // 총 주차 시간 (분)
    private Integer rawFee;             // 정산 전 요금
    private Integer discountFee;        // 총 할인받은 금액
    private Integer finalFee;           // 최종 결제 금액
    private String parkingType;         // 주차구역 구분 (general, ev, disabled, pregnant)

    // 2. [추가] 요금 정책(fee_policies) 및 상가 할인(store_discounts) 연산용 필드
    private Integer gracePeriod;        // 회차 무료 시간 (분)
    private Integer baseTime;           // 기본 시간 (분)
    private Integer baseFee;            // 기본 요금 (원)
    private Integer extraTime;          // 추가 단위 시간 (분)
    private Integer extraFee;           // 추가 단위 요금 (원)
    private Integer dailyMax;           // 일일 최대 요금 (원)
    private Integer storeDiscountMin;   // 상가 할인 제공 시간 합계 (분)
    private boolean isPass; // 정기권 등록 유무

    // 기본 생성자
    public ParkingRecordDto() {}

    // 전체 필드 생성자
    public ParkingRecordDto(Long recordId, String carNum, Integer parkingFloor, LocalDateTime entryTime,
                            LocalDateTime exitTime, Integer totalMin, Integer rawFee, Integer discountFee,
                            Integer finalFee, String parkingType, Integer gracePeriod, Integer baseTime,
                            Integer baseFee, Integer extraTime, Integer extraFee, Integer dailyMax,
                            Integer storeDiscountMin) {
        this.recordId = recordId;
        this.carNum = carNum;
        this.parkingFloor = parkingFloor;
        this.entryTime = entryTime;
        this.exitTime = exitTime;
        this.totalMin = totalMin;
        this.rawFee = rawFee;
        this.discountFee = discountFee;
        this.finalFee = finalFee;
        this.parkingType = parkingType;
        this.gracePeriod = gracePeriod;
        this.baseTime = baseTime;
        this.baseFee = baseFee;
        this.extraTime = extraTime;
        this.extraFee = extraFee;
        this.dailyMax = dailyMax;
        this.storeDiscountMin = storeDiscountMin;
    }
    public boolean isPass() {
        return isPass;
    }
    
    public void setPass(boolean isPass) {
        this.isPass = isPass;
    }

    // --- 기존 Getter / Setter ---
    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }

    public String getCarNum() { return carNum; }
    public void setCarNum(String carNum) { this.carNum = carNum; }

    public Integer getParkingFloor() { return parkingFloor; }
    public void setParkingFloor(Integer parkingFloor) { this.parkingFloor = parkingFloor; }

    public LocalDateTime getEntryTime() { return entryTime; }
    public void setEntryTime(LocalDateTime entryTime) { this.entryTime = entryTime; }

    public LocalDateTime getExitTime() { return exitTime; }
    public void setExitTime(LocalDateTime exitTime) { this.exitTime = exitTime; }

    public Integer getTotalMin() { return totalMin; }
    public void setTotalMin(Integer totalMin) { this.totalMin = totalMin; }

    public Integer getRawFee() { return rawFee; }
    public void setRawFee(Integer rawFee) { this.rawFee = rawFee; }

    public Integer getDiscountFee() { return discountFee; }
    public void setDiscountFee(Integer discountFee) { this.discountFee = discountFee; }

    public Integer getFinalFee() { return finalFee; }
    public void setFinalFee(Integer finalFee) { this.finalFee = finalFee; }

    public String getParkingType() { return parkingType; }
    public void setParkingType(String parkingType) { this.parkingType = parkingType; }

    // --- [추가] 연산용 필드 Getter / Setter ---
    public Integer getGracePeriod() { return gracePeriod; }
    public void setGracePeriod(Integer gracePeriod) { this.gracePeriod = gracePeriod; }

    public Integer getBaseTime() { return baseTime; }
    public void setBaseTime(Integer baseTime) { this.baseTime = baseTime; }

    public Integer getBaseFee() { return baseFee; }
    public void setBaseFee(Integer baseFee) { this.baseFee = baseFee; }

    public Integer getExtraTime() { return extraTime; }
    public void setExtraTime(Integer extraTime) { this.extraTime = extraTime; }

    public Integer getExtraFee() { return extraFee; }
    public void setExtraFee(Integer extraFee) { this.extraFee = extraFee; }

    public Integer getDailyMax() { return dailyMax; }
    public void setDailyMax(Integer dailyMax) { this.dailyMax = dailyMax; }

    public Integer getStoreDiscountMin() { return storeDiscountMin; }
    public void setStoreDiscountMin(Integer storeDiscountMin) { this.storeDiscountMin = storeDiscountMin; }
}