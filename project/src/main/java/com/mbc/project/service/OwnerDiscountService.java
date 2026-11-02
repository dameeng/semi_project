package com.mbc.project.service;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import com.mbc.project.dao.OwnerDiscountDao;
import com.mbc.project.dto.OwnerDiscountDto;

@Service
public class OwnerDiscountService {

    private static final int FREE_MIN = 120;

    private final OwnerDiscountDao dao;

    public OwnerDiscountService(OwnerDiscountDao dao) {
        this.dao = dao;
    }

    public OwnerDiscountDto applyDiscount(String ownerId, String carNum) {
        Integer storeNum = dao.findStoreNumByOwnerId(ownerId);
        if (storeNum == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "등록된 매장 정보가 없습니다.");
        }

        Long recordId = dao.findActiveRecordByCarNum(carNum);
        if (recordId == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "현재 주차 중인 차량을 찾을 수 없습니다.");
        }

        if (dao.countDuplicate(recordId, storeNum) > 0) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "이미 2시간 할인이 등록된 차량입니다.");
        }

        dao.insertDiscount(recordId, storeNum, FREE_MIN, ownerId);

        OwnerDiscountDto dto = new OwnerDiscountDto();
        dto.setRecordId(recordId);
        dto.setStoreNum(storeNum);
        dto.setFreeMin(FREE_MIN);
        dto.setId(ownerId);
        dto.setCarNum(carNum);
        return dto;
    }

    public List<OwnerDiscountDto> getHistory(String ownerId) {
        Integer storeNum = dao.findStoreNumByOwnerId(ownerId);
        if (storeNum == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "등록된 매장 정보가 없습니다.");
        }
        return dao.selectDiscountHistory(storeNum);
    }
}