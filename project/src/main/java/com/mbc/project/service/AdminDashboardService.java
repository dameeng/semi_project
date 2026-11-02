package com.mbc.project.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbc.project.dao.AdminDashboardDao;
import com.mbc.project.dto.AdminDashboardDto;

@Service
public class AdminDashboardService {

    @Autowired
    AdminDashboardDao dao;

    public AdminDashboardDto getDashboardData() {
        // 1. 층별 주차 현황 데이터 가공
        List<Map<String, Object>> floorList = dao.getFloorParkingCount();
        List<String> pieLabels = new ArrayList<>();
        List<Integer> pieData = new ArrayList<>();

        if (floorList != null && !floorList.isEmpty()) {
            for (Map<String, Object> map : floorList) {
                Object floorObj = map.get("floor");
                Object countObj = map.get("count");

                String label = (floorObj != null ? floorObj.toString() : "0") + "층";
                Integer count = (countObj != null) ? Integer.parseInt(countObj.toString()) : 0;

                pieLabels.add(label);
                pieData.add(count);
            }
        } else {
            // 기본 예시 데이터
            pieLabels.add("1층");
            pieLabels.add("2층");
            pieLabels.add("3층");
            pieData.add(0);
            pieData.add(0);
            pieData.add(0);
        }

        // 2. 월별 매출액 데이터 가공
        List<Map<String, Object>> salesList = dao.getMonthlySales();
        List<String> barLabels = new ArrayList<>();
        List<Long> barData = new ArrayList<>();

        if (salesList != null && !salesList.isEmpty()) {
            for (Map<String, Object> map : salesList) {
                Object monthObj = map.get("month");
                Object salesObj = map.get("sales");

                String label = (monthObj != null ? monthObj.toString() : "");
                Long sales = (salesObj != null) ? Long.parseLong(salesObj.toString()) : 0L;

                barLabels.add(label);
                barData.add(sales);
            }
        } else {
            // 1월 ~ 12월 기본 0원 설정
            for (int i = 1; i <= 12; i++) {
                barLabels.add(i + "월");
                barData.add(0L);
            }
        }

        return new AdminDashboardDto(pieLabels, pieData, barLabels, barData);
    }
}
