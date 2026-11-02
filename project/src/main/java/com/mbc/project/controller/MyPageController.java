package com.mbc.project.controller;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.mbc.project.dto.CarLocationDto;
import com.mbc.project.dto.MemberDto;
import com.mbc.project.dto.MyCarDto;
import com.mbc.project.dto.ParkingRecordDto;
import com.mbc.project.service.MyPageService;
@RestController
@RequestMapping("/mypage")
public class MyPageController {
	private final MyPageService service;
    public MyPageController(MyPageService service) {
        this.service = service;
    }
    
 // 1. 내 정보 & 내 차량 조회 (POST)
    @PostMapping("/info")
    public MemberDto getMember(@RequestBody Map<String, String> req) {
    	System.out.println("MyPageController getMember()" + new Date());
        String id = req.get("id");
        return service.getMember(id);
    }
    // 2. 내 정보 수정 (POST)
    @PostMapping("/updateMember")
    public Map<String, Object> updateMember(@RequestBody MemberDto dto) {
        System.out.println("MyPageController updateMember() " + new Date());
        System.out.println("수정할 회원 정보: " + dto.toString());
        
        return service.updateMember(dto);
    }
    // 3. 내 차량 위치 조회 (POST)
    // Request JSON: { "id": "user01" }
    @PostMapping("/carLocation")
    public CarLocationDto getCarLocation(@RequestBody Map<String, String> req) {
        System.out.println("MyPageController getCarLocation() " + new Date());
        String id = req.get("id");
        
        return service.getCarLocation(id);
    }
    // 4. 내 차량 정보 조회 (POST)
    @PostMapping("/myCar")
    public Map<String, Object> getMyCarInfo(@RequestBody Map<String, String> param) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = param.get("id");
        
        if (userId == null || userId.trim().isEmpty()) {
            result.put("status", "fail");
            result.put("message", "사용자 ID가 전달되지 않았습니다.");
            return result;
        }
        MyCarDto myCarDto = service.getMyCar(userId);
        result.put("status", "success");
        result.put("data", myCarDto);
        return result;
    }
    
    // 5 & 6. 차량 등록 및 변경 (POST)
    @PostMapping("/updateCar")
    public boolean updateCarNum(@RequestBody Map<String, String> req) {
    	System.out.println("MyPageController updateCarNum()" + new Date());
        String id = req.get("id");
        String carNum = req.get("carNum");
        String carTypes = req.get("carTypes");
        return service.updateCarNum(id, carNum, carTypes);
    }
    // 7. 차량 삭제 (POST)
    @PostMapping("/deleteCar")
    public boolean deleteCarNum(@RequestBody Map<String, String> req) {
    	System.out.println("MyPageController deleteCarNum()" + new Date());
        String id = req.get("id");
        return service.deleteCarNum(id);
    }
    
    // 8. 주차 시간, 비용 계산
    @PostMapping("/parkingCost")
    public ParkingRecordDto getParkingTime(@RequestBody Map<String, String> param) {
        System.out.println("MyPageController getParkingTime() " + new Date());
        String id = param.get("id");
        
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        return service.getParkingCost(id);
    }
    
}