package com.mbc.project.controller;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.mbc.project.dto.ParkingRecordDto;
import com.mbc.project.service.ParkingRecordService;

@RestController
@RequestMapping("/parking")
public class ParkingRecordController {

    private final ParkingRecordService service;

    // 생성자 주입
    public ParkingRecordController(ParkingRecordService service) {
        this.service = service;
    }

    // 전체 조회
    @GetMapping("/list")
    public List<ParkingRecordDto> allparkingrecords() {
        return service.allparkingrecords();
    }

    // 차량번호 조회
    @GetMapping("/{carNum}")
    public List<ParkingRecordDto> findbycarnum(@PathVariable String carNum) {
        return service.findbycarnum(carNum);
    }

    // 입차 등록
    @PostMapping("/entry")
    public int entry(@RequestBody ParkingRecordDto dto) {
        return service.addparkingrecord(dto);
    }

    // 출차 등록
    @PutMapping("/exit")
    public int exit(@RequestBody ParkingRecordDto dto) {
        return service.exitparking(dto);
    }
}