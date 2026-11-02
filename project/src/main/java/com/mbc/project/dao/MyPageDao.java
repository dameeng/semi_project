package com.mbc.project.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.mbc.project.dto.CarLocationDto;
import com.mbc.project.dto.MemberDto;
import com.mbc.project.dto.MyCarDto;
import com.mbc.project.dto.ParkingRecordDto;

@Mapper
@Repository
public interface MyPageDao {
	// 1. 내 정보 / 내 차량 조회 (ID 기반)
    MemberDto getMember(@Param("id") String id);
    // 2. 내 정보 수정 (비밀번호, 이름, 이메일 등)
    int updateMember(MemberDto dto);
    // 3. 내 차량 위치 조회 (로그인 id 기준으로 usermember.carNum 변환 후, exitTime이 NULL인 최근 주차 기록)
    CarLocationDto getCarLocation(@Param("id") String id);
    
    // 4. 내 차량 및 정기권 정보 조회 
    MyCarDto getMyCar(@Param("id") String id);
    // 5 & 6. 차량 등록 / 변경 (회원의 carNum 업데이트)
    int updateCarNum(@Param("id") String id, @Param("carNum") String carNum, @Param("carTypes") String carTypes);
    // 7. 차량 삭제 (회원의 carNum을 NULL로 처리)
    int deleteCarNum(@Param("id") String id);
    
    // 8. 주차 시간 및 요금 계산
    ParkingRecordDto parkingCost(@Param("id") String id);

    // 9. 오늘 기준 주차중 여부 확인
    boolean isCurrentlyParked(@Param("carNum") String carNum);

    // 10. 현재 유효한 정기권 보유 여부 확인
    boolean hasActivePrepaid(@Param("carNum") String carNum);
}