package com.mbc.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mbc.project.dto.ParkingSpotDto;
import com.mbc.project.service.ParkingSpotService;

@RestController
public class ParkingSpotController {

    @Autowired
    private ParkingSpotService service;

    @GetMapping("/parkingspots")
    public List<ParkingSpotDto> getParkingSpots() {
        return service.getAllSpots();
    }
}
