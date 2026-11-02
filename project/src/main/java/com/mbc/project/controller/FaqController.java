package com.mbc.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.mbc.project.dto.FaqDto;
import com.mbc.project.service.FaqService;

@RestController
public class FaqController {

    @Autowired
    FaqService service;

    // FAQ 전체 조회
    @GetMapping("faqlist")
    public List<FaqDto> faqlist() {
        return service.faqlist();
    }

    // FAQ 상세 조회 (GET /faq/{seq} 및 GET /faqdetail)
    @GetMapping({"faq/{seq}", "faqdetail"})
    public FaqDto getfaq(@PathVariable(value = "seq", required = false) Integer seq,
                         @RequestParam(value = "seq", required = false) Integer paramSeq) {
        int targetSeq = (seq != null) ? seq : (paramSeq != null ? paramSeq : 0);
        return service.getfaq(targetSeq);
    }

    // FAQ 등록 (POST /faq 및 POST /faqwrite)
    @PostMapping({"faq", "faqwrite", "addfaq"})
    public boolean addfaq(@RequestBody FaqDto dto) {
        if (dto.getId() == null || dto.getId().isEmpty()) {
            dto.setId("admin"); // 관리자 기본 ID 지정
        }
        return service.addfaq(dto);
    }

    // FAQ 수정 (POST/PUT /faq/{seq} 및 POST /faqupdate)
    @RequestMapping(value = {"faq/{seq}", "faqupdate", "updatefaq"}, method = {RequestMethod.POST, RequestMethod.PUT})
    public boolean updatefaq(@PathVariable(value = "seq", required = false) Integer seq,
                             @RequestBody(required = false) FaqDto dto) {
        if (dto == null) dto = new FaqDto();
        if (seq != null) {
            dto.setFaqid(seq);
            dto.setSeq(seq);
        }
        
        // 논리 삭제 요청이 들어왔을 경우
        if (Boolean.TRUE.equals(dto.getIsdeleted())) {
            int deleteId = (dto.getFaqid() != null) ? dto.getFaqid() : (seq != null ? seq : 0);
            return service.deletefaq(deleteId);
        }
        
        return service.updatefaq(dto);
    }

    // FAQ 삭제
    @DeleteMapping({"faq/{seq}", "deletefaq"})
    public boolean deletefaq(@PathVariable(value = "seq", required = false) Integer seq,
                             @RequestParam(value = "faqid", required = false) Integer faqid) {
        int targetId = (seq != null) ? seq : (faqid != null ? faqid : 0);
        return service.deletefaq(targetId);
    }

}