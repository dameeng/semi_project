package com.mbc.project.controller;

import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
import com.mbc.project.dto.OwnerDiscountDto;
import com.mbc.project.service.OwnerDiscountService;

@RestController
@RequestMapping("/store")
public class OwnerDiscountController {

    private final OwnerDiscountService service;

    public OwnerDiscountController(OwnerDiscountService service) {
        this.service = service;
    }

    @PostMapping("/discount/apply")
    public OwnerDiscountDto apply(@RequestBody Map<String, String> body) {
        return service.applyDiscount(body.get("id"), body.get("carNum"));
    }

    @PostMapping("/discount/history")
    public List<OwnerDiscountDto> history(@RequestBody Map<String, String> body) {
        return service.getHistory(body.get("id"));
    }
}