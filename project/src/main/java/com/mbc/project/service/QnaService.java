package com.mbc.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mbc.project.dao.QnaDao;
import com.mbc.project.dto.QnaDto;

@Service
@Transactional
public class QnaService {

	@Autowired
	private QnaDao qnaDao;

	// 1. Q&A 목록 조회 (검색 + 페이징)
	@Transactional(readOnly = true)
	public List<QnaDto> getQnaList(String category, String keyword, Integer offset, Integer limit) {
		return qnaDao.allqna(category, keyword, offset, limit);
	}

	// 2. Q&A 전체 개수 조회 (검색 조건 포함)
	@Transactional(readOnly = true)
	public int getQnaCount(String category, String keyword) {
		return qnaDao.countqna(category, keyword);
	}

	// 3. 내 Q&A 목록 조회
	@Transactional(readOnly = true)
	public List<QnaDto> getMyQnaList(String writerId) {
		if (writerId == null || writerId.trim().isEmpty()) {
			return List.of();
		}
		return qnaDao.myqna(writerId);
	}

	// 4. Q&A 질문 등록
	public int writeQna(QnaDto dto) {
		return qnaDao.addqna(dto);
	}

	// 5. Q&A 상세 조회
	@Transactional(readOnly = true)
	public QnaDto getQnaDetail(Long seq) {
		return qnaDao.detailqna(seq);
	}

	// 6. Q&A 조회수 1 증가
	public int increaseReadCount(Long seq) {
		return qnaDao.updateqnacount(seq);
	}

	// 7. Q&A 관리자 답변 등록 / 수정 / 삭제
	public int answerQna(QnaDto dto) {
		return qnaDao.answerqna(dto);
	}

	// 8. Q&A 질문 삭제
	public int deleteQna(Long seq) {
		return qnaDao.deleteqna(seq);
	}

	// 관리자가 Q&A 문의글 수정
	public int updateQna(QnaDto dto) {
		return qnaDao.updateqna(dto);
	}
}