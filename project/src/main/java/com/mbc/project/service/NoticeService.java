package com.mbc.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbc.project.dao.NoticeDao;
import com.mbc.project.dto.NoticeDto;

@Service
public class NoticeService {

    @Autowired
    private NoticeDao noticeDao;

    // ==========================================
    // 2. 공지사항 (notice) 기능
    // ==========================================

    // 1. 공지사항 페이징 & 검색 목록 가져오기
    public List<NoticeDto> getNoticeList(String category, String keyword, int offset, int limit) {
        return noticeDao.allnotice(category, keyword, offset, limit);
    }

    // 2. 공지사항 전체 게시글 개수 조회 (페이징용)
    public int getNoticeCount(String category, String keyword) {
        return noticeDao.countnotice(category, keyword);
    }

    // 3. 공지사항 글쓰기
    public int writeNotice(NoticeDto dto) {
        return noticeDao.addnotice(dto);
    }

    // 4. 공지사항 상세보기 (조회수 증가 + 글 가져오기)
    public NoticeDto getNoticeDetail(Long seq) {
        noticeDao.updatenoticecount(seq);   // 1. 먼저 공지사항 조회수를 1 올리고
        return noticeDao.detailnotice(seq); // 2. 그 다음 공지글 내용을 가져온다
    }

    // 5. 공지사항 수정
    public int updateNotice(NoticeDto dto) {
        return noticeDao.updatenotice(dto);
    }

    // 6. 공지사항 삭제
    public int deleteNotice(Long seq) {
        return noticeDao.deletenotice(seq);
    }

}