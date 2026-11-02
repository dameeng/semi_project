package com.mbc.project.dto;

public class MyCarDto {
	private String id;
    private String carNum;     // 차량 번호
    private String carTypes;    // 차량 타입 (예: ev, pregnant 등)
    private boolean hasCar;    // 차량 등록 여부
    
    // 정기권(prepaid) 연동 정보
    private boolean isPrepaid; // 정기권 이용 여부
    private String startDate;  // 정기권 시작일
    private String endDate;    // 정기권 만료일

    // 기본 생성자
    public MyCarDto() {}

    // Getter & Setter
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCarNum() { return carNum; }
    public void setCarNum(String carNum) { this.carNum = carNum; }

    public String getCarTypes() { return carTypes; }
    public void setCarTypes(String carTypes) { this.carTypes = carTypes; }

    public boolean isHasCar() { return hasCar; }
    public void setHasCar(boolean hasCar) { this.hasCar = hasCar; }

    public boolean isPrepaid() { return isPrepaid; }
    public void setPrepaid(boolean prepaid) { isPrepaid = prepaid; }

    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }

    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
}