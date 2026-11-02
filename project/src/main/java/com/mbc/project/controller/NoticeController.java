package com.mbc.project.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.mbc.project.dto.NoticeDto;
import com.mbc.project.service.NoticeService;

@CrossOrigin(originPatterns = "*", allowedHeaders = "*")
@RestController
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    // 공지사항 페이징 및 검색 목록 조회
    @GetMapping("/allnotice")
    public Map<String, Object> allnotice(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "keyword", required = false) String keyword) {

        System.out.println("NoticeController allnotice() " + new Date());

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        // 1. 목록 조회
        List<NoticeDto> list = noticeService.getNoticeList(category, keyword, offset, pageSize);

        // 2. 전체 게시글 수 조회
        int totalCount = noticeService.getNoticeCount(category, keyword);

        // 3. 응답 데이터 구성
        Map<String, Object> map = new HashMap<>();
        map.put("noticelist", list);
        map.put("page", page);
        map.put("pageSize", pageSize);
        map.put("totalCount", totalCount);
        map.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));

        return map;
    }

    // 공지사항 등록 (관리자용)
    @PostMapping("/addnotice")
    public int addnotice(@RequestBody NoticeDto dto) {
        System.out.println("NoticeController addnotice() " + new Date());
        return noticeService.writeNotice(dto);
    }

    // 공지사항 상세보기 (조회수 증가 포함)
    @PostMapping("/detailnotice")
    public NoticeDto detailnotice(@RequestParam("seq") Long seq) {
        System.out.println("NoticeController detailnotice() " + new Date());
        return noticeService.getNoticeDetail(seq);
    }

    // 공지사항 수정 (관리자용)
    @PostMapping("/updatenotice")
    public int updatenotice(@RequestBody NoticeDto dto) {
        System.out.println("NoticeController updatenotice() " + new Date());
        return noticeService.updateNotice(dto);
    }

    // 공지사항 삭제 (관리자용)
    @PostMapping("/deletenotice")
    public int deletenotice(@RequestParam("seq") Long seq) {
        System.out.println("NoticeController deletenotice() " + new Date());
        return noticeService.deleteNotice(seq);
    }

}