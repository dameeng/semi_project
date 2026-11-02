package com.mbc.project.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mbc.project.dao.StoresDao;
import com.mbc.project.dto.StoresDto;

@Service
public class StoresService {

    private final StoresDao dao;

    // Service 와 Dao 연결
    public StoresService(StoresDao dao) {
        this.dao = dao;
    }

    // 상가 전체 목록 조회
    public List<StoresDto> getStoresDto() {
        return dao.allstores();
    }

    // 층별 상가 조회
    public List<StoresDto> getStoresFloor(int floor) {
        return dao.storesfloor(floor);
    }
    
    // 상가 상세 조회
    public StoresDto storedetail(int storeNum){
    	return dao.storedetail(storeNum);
    }

    // 관리자가 상가 추가
    public boolean addstore(StoresDto dto) {
        return dao.addstore(dto) > 0;
    }
    
    // 관리자가 상가 수정
    public boolean updatestore(StoresDto dto)  {
        return dao.updatestore(dto) > 0;
    }
    
    // 관리자가 상가 삭제
    public boolean deletestore(int storeNum) {
        return dao.deletestore(storeNum) > 0;
    }
}

