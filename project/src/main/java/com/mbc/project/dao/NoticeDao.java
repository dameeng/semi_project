package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.mbc.project.dto.NoticeDto;

@Mapper // 스프링부트에 DB와의 소통한다고 알려주는 애노테이션
public interface NoticeDao {

    // 1. 공지사항 목록 조회 (검색 조건 + 페이징)
    List<NoticeDto> allnotice(@Param("category") String category, 
                             @Param("keyword") String keyword, 
                             @Param("offset") Integer offset, 
                             @Param("limit") Integer limit);

    // 2. 전체 게시글 개수 조회 (페이징 계산용)
    int countnotice(@Param("category") String category, 
                    @Param("keyword") String keyword);

    // 3. 공지사항 등록
    int addnotice(NoticeDto dto);

    // 4. 공지사항 상세 조회
    NoticeDto detailnotice(Long seq);

    // 5. 공지사항 조회수 1 증가
    int updatenoticecount(Long seq);

    // 6. 공지사항 수정
    int updatenotice(NoticeDto dto);

    // 7. 공지사항 삭제
    int deletenotice(Long seq);

}