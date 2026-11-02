package com.mbc.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mbc.project.dto.AdminDashboardDto;
import com.mbc.project.service.AdminDashboardService;

@RestController
@RequestMapping("/admin")
public class AdminDashboardController {

    @Autowired
    AdminDashboardService service;

    // 관리자 대시보드 통계 데이터 조회 (GET /admin/dashboard)
    @GetMapping("/dashboard")
    public AdminDashboardDto getDashboardData() {
        return service.getDashboardData();
    }
}
