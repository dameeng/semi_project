package com.mbc.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbc.project.dao.NoticeDao;
import com.mbc.project.dao.ParkingRecordDao;
import com.mbc.project.dto.ParkingRecordDto;

@Service
public class ParkingRecordService {

    @Autowired
    private ParkingRecordDao parkingRecordDao;

    // 전체 조회
    public List<ParkingRecordDto> allparkingrecords() {
        return parkingRecordDao.allparkingrecords();
    }

    // 차량 번호 조회
    public List<ParkingRecordDto> findbycarnum(String carNum) {
        return parkingRecordDao.findbycarnum(carNum);
    }

    // 입차 시간 등록
    public int addparkingrecord(ParkingRecordDto dto) {
        return parkingRecordDao.addparkingrecord(dto);
    }

    // 출차 시간 등록
    public int exitparking(ParkingRecordDto dto) {
        return parkingRecordDao.exitparking(dto);
    }
}