package com.mbc.project.dto;

import java.util.List;

public class AdminDashboardDto {

    // 층별 주차 현황 (Pie 차트용)
    private List<String> pieLabels;
    private List<Integer> pieData;

    // 월별 매출 (Bar 차트용)
    private List<String> barLabels;
    private List<Long> barData;

    public AdminDashboardDto() {
    }

    public AdminDashboardDto(List<String> pieLabels, List<Integer> pieData, List<String> barLabels, List<Long> barData) {
        this.pieLabels = pieLabels;
        this.pieData = pieData;
        this.barLabels = barLabels;
        this.barData = barData;
    }

    public List<String> getPieLabels() {
        return pieLabels;
    }

    public void setPieLabels(List<String> pieLabels) {
        this.pieLabels = pieLabels;
    }

    public List<Integer> getPieData() {
        return pieData;
    }

    public void setPieData(List<Integer> pieData) {
        this.pieData = pieData;
    }

    public List<String> getBarLabels() {
        return barLabels;
    }

    public void setBarLabels(List<String> barLabels) {
        this.barLabels = barLabels;
    }

    public List<Long> getBarData() {
        return barData;
    }

    public void setBarData(List<Long> barData) {
        this.barData = barData;
    }
}
