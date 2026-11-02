package com.mbc.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbc.project.dao.ParkingSpotDao;
import com.mbc.project.dto.ParkingSpotDto;

@Service
public class ParkingSpotService {

	@Autowired
	private ParkingSpotDao dao;

    public List<ParkingSpotDto> getAllSpots() {
        return dao.selectAllSpots();
    }
}
