package com.mbc.project.controller;

import java.util.Date;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mbc.project.dto.StoresDto;
import com.mbc.project.service.StoresService;

@RestController
public class StoresController {

    private final StoresService service;

    public StoresController(StoresService service) {
        this.service = service;
    }

    // 전체 상가 조회
    @GetMapping("/allstores")
    public List<StoresDto> allstores() {
        System.out.println("StoresController allstores() " + new Date());

        return service.getStoresDto();
    }
    
    
    // 층별 상가 위치
    @GetMapping("/storesfloor")
    public List<StoresDto> storesfloor(@RequestParam int floor) { // @RequestParam은 URL의 파라미터 값을 메서드 매개변수로 받는 어노테이션
        System.out.println("StoresController storesfloor() " + new Date());

        return service.getStoresFloor(floor);
    }
    
    // 상가 상세 조회
    @GetMapping("/storedetail")
    public StoresDto storedetail(@RequestParam int storeNum) {
    	 System.out.println("StoresController storeNum() " + new Date());
    	 
    	    return service.storedetail(storeNum);
    }
    
    
    // 관리자가 상가 추가
    @PostMapping("/addstore")
    public boolean addstore(@RequestBody StoresDto dto) {
        System.out.println("StoresController addstore() " + new Date());

        return service.addstore(dto);
    }
    
    // 관리자가 상가 수정
    @PostMapping("/updatestore")
    public boolean updatestore(@RequestBody StoresDto dto) {
        System.out.println("StoresController updatestore() " + new Date());

        return service.updatestore(dto);
    }
        
    
    // 관리자가 상가 삭제    
 @PostMapping("/deletestore")
public boolean deletestore(@RequestParam int storeNum) {
    System.out.println("StoresController deletestore() " + new Date());

    return service.deletestore(storeNum);
}
} 