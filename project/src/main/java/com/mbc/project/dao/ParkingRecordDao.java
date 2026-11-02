package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbc.project.dto.ParkingRecordDto;

@Mapper
public interface ParkingRecordDao {
	List<ParkingRecordDto> allparkingrecords();            // 전체 조회
	List<ParkingRecordDto> findbycarnum(String carNum);    // 전체 차량 번호 조회
    int addparkingrecord(ParkingRecordDto dto);			  // 입차 시간 추가
    int exitparking(ParkingRecordDto dto);				  // 출차 시간 추가
    ParkingRecordDto findByRecordId(Long recordId);       // 할인 및 정산 수식 연동을 위한 주차 기록 단건 상세 조회 (추가됨)
	
	

}
