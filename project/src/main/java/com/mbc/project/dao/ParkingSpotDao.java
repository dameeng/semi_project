package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbc.project.dto.ParkingSpotDto;

@Mapper
public interface ParkingSpotDao {
    List<ParkingSpotDto> selectAllSpots();
}
