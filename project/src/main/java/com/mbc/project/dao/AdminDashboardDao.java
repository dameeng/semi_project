package com.mbc.project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminDashboardDao {

    // 층별 주차 중인 차량 수 조회 ({parkingfloor: 1, count: 5})
    List<Map<String, Object>> getFloorParkingCount();

    // 월별 매출 금액 조회 ({month: '08월', sales: 150000})
    List<Map<String, Object>> getMonthlySales();

}
