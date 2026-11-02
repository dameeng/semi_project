package com.mbc.project.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.mbc.project.dao.MyPageDao;
import com.mbc.project.dto.CarLocationDto;
import com.mbc.project.dto.MemberDto;
import com.mbc.project.dto.MyCarDto;
import com.mbc.project.dto.ParkingRecordDto;

@Service
public class MyPageService {

    private final MyPageDao dao;

    public MyPageService(MyPageDao dao) {
        this.dao = dao;
    }

    // 1. 내 정보 조회
    public MemberDto getMember(String id) {
        return dao.getMember(id);
    }

    // 2. 내 정보 수정
    // - 차량번호가 실제로 변경 요청된 경우, 원본 carNum 기준으로
    //   (1) 오늘 주차중인지, (2) 유효한 정기권이 있는지 체크
    // - 둘 중 하나라도 해당되면 차량번호/차량유형은 원래 값으로 되돌려서
    //   업데이트에서 제외시키고(이름/이메일 등은 정상 반영), 사유를 응답에 담아 반환
    public Map<String, Object> updateMember(MemberDto dto) {
        Map<String, Object> result = new HashMap<>();

        MemberDto origin = dao.getMember(dto.getId());

        boolean carNumChangeRequested =
                origin != null
                && dto.getCarNum() != null
                && !dto.getCarNum().equals(origin.getCarNum());

        String blockReason = null;

        if (carNumChangeRequested) {
            if (dao.isCurrentlyParked(origin.getCarNum())) {
                blockReason = "PARKING";   // 오늘 입차 후 미출차(주차중)
            } else if (dao.hasActivePrepaid(origin.getCarNum())) {
                blockReason = "PREPAID";   // 이용중인 정기권 존재
            }
        }

        if (blockReason != null) {
            dto.setCarNum(origin.getCarNum());
            dto.setCarTypes(origin.getCarTypes());
        }

        int updated = dao.updateMember(dto);

        result.put("success", updated > 0);
        result.put("carNumBlocked", blockReason != null);
        result.put("blockReason", blockReason);
        result.put("data", dto);
        return result;
    }

    // 3. 내 차량 위치 조회 (파라미터는 로그인 id)
    public CarLocationDto getCarLocation(String id) {
        return dao.getCarLocation(id);
    }

    // 4. 내 차량 및 정기권 정보 조회
    public MyCarDto getMyCar(String id) {
        return dao.getMyCar(id);
    }

    // 5 & 6. 차량 등록 / 변경
    public boolean updateCarNum(String id, String carNum, String carTypes) {
        return dao.updateCarNum(id, carNum, carTypes) > 0;
    }

    // 7. 차량 삭제
    public boolean deleteCarNum(String id) {
        return dao.deleteCarNum(id) > 0;
    }

    // 8. 주차 시간, 비용 계산
    public ParkingRecordDto getParkingCost(String id) {
        ParkingRecordDto dto = dao.parkingCost(id);
        if (dto == null) {
            return null;
        }

        int totalMin = dto.getTotalMin() != null ? dto.getTotalMin() : 0;
        int gracePeriod = dto.getGracePeriod() != null ? dto.getGracePeriod() : 15;
        int baseTime = dto.getBaseTime() != null ? dto.getBaseTime() : 30;
        int baseFee = dto.getBaseFee() != null ? dto.getBaseFee() : 1000;
        int extraTime = dto.getExtraTime() != null ? dto.getExtraTime() : 10;
        int extraFee = dto.getExtraFee() != null ? dto.getExtraFee() : 1000;
        int dailyMax = dto.getDailyMax() != null ? dto.getDailyMax() : 30000;
        int storeDiscountMin = dto.getStoreDiscountMin() != null ? dto.getStoreDiscountMin() : 0;
        boolean isPass = dto.isPass();

        // 1. 기본 정산 전 요금 (rawFee) 계산
        int rawFee = calculateRawFee(totalMin, gracePeriod, baseTime, baseFee, extraTime, extraFee, dailyMax);

        // 2. 할인 금액 (discountFee) 계산
        int discountFee = 0;
        if (isPass) {
            // 정기권 이용 회원의 경우 전액 할인 처리
            discountFee = rawFee;
        } else if (storeDiscountMin > 0 && rawFee > 0) {
            int remainingMin = Math.max(0, totalMin - storeDiscountMin);
            int feeAfterDiscount = calculateRawFee(remainingMin, gracePeriod, baseTime, baseFee, extraTime, extraFee, dailyMax);
            discountFee = Math.max(0, rawFee - feeAfterDiscount);
        }

        // 3. 최종 결제 금액 (finalFee) 계산
        int finalFee = Math.max(0, rawFee - discountFee);

        dto.setRawFee(rawFee);
        dto.setDiscountFee(discountFee);
        dto.setFinalFee(finalFee);

        return dto;
    }

    private int calculateRawFee(int minutes, int gracePeriod, int baseTime, int baseFee, int extraTime, int extraFee, int dailyMax) {
        if (minutes <= gracePeriod) {
            return 0;
        }
        if (minutes <= baseTime) {
            return baseFee;
        }
        int extraMin = minutes - baseTime;
        int extraUnits = (int) Math.ceil((double) extraMin / extraTime);
        int fee = baseFee + (extraUnits * extraFee);
        return Math.min(fee, dailyMax);
    }
}