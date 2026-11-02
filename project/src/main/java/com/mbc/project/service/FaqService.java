package com.mbc.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbc.project.dao.FaqDao;
import com.mbc.project.dto.FaqDto;

@Service
public class FaqService {

    @Autowired
    FaqDao dao;

    // 1. FAQ 전체 조회
    public List<FaqDto> faqlist() {
        return dao.faqlist();
    }

    // 💡 2. FAQ 상세 조회 (컨트롤러 연동을 위해 누락된 메서드 보완)
    public FaqDto getfaq(int faqid) {
        return dao.getfaq(faqid);
    }

    // 3. FAQ 등록
    public boolean addfaq(FaqDto dto) {
        return dao.addfaq(dto) > 0;
    }

    // 4. FAQ 수정
    public boolean updatefaq(FaqDto dto) {
        return dao.updatefaq(dto) > 0;
    }

    // 5. FAQ 삭제
    public boolean deletefaq(int faqid) {
        return dao.deletefaq(faqid) > 0;
    }

}
