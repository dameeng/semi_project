package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.mbc.project.dto.QnaDto;

@Mapper
public interface QnaDao {

	// 1. Q&A 질문 목록 조회 (검색 조건 + 10개씩 페이징 통합)
	// XML의 <select id="allqna">와 매핑
	List<QnaDto> allqna(@Param("category") String category, @Param("keyword") String keyword,
			@Param("offset") Integer offset, @Param("limit") Integer limit);

	// 2. Q&A 게시글 개수 조회 (검색 조건 포함)
	// XML의 <select id="countqna">와 매핑
	int countqna(@Param("category") String category, @Param("keyword") String keyword);

	// 3. 내 Q&A 질문 목록 조회
	List<QnaDto> myqna(String writerId);

	// 4. Q&A 질문 등록
	int addqna(QnaDto dto);

	// 5. Q&A 상세 조회
	QnaDto detailqna(Long seq);

	// 6. Q&A 조회수 1 증가
	int updateqnacount(Long seq);

	// 7. Q&A 답변 등록/수정
	int answerqna(QnaDto dto);

	// 8. Q&A 삭제
	int deleteqna(Long seq);

	// 9. Q&A 검색 (XML에 남아있는 기존 searchqna와 매핑)
	List<QnaDto> searchqna(@Param("choice") String choice, @Param("keyword") String keyword);

	// 관리자가 Q&A 문의글 수정
	int updateqna(QnaDto dto);
}