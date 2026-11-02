package com.mbc.project.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mbc.project.dto.QnaDto;
import com.mbc.project.service.QnaService;

@CrossOrigin(originPatterns = "*", allowedHeaders = "*")
@RestController
public class QnaController {

	@Autowired
	private QnaService qnaService;

	// Q&A 목록 조회 (검색 + 10개씩 페이징)
	@RequestMapping(value = "/allqna", method = { RequestMethod.GET, RequestMethod.POST })
	public Map<String, Object> allqna(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "category", required = false) String category,
			@RequestParam(value = "keyword", required = false) String keyword) {

		System.out.println("QnaController allqna() page=" + page + ", category=" + category + ", keyword=" + keyword
				+ " " + new Date());

		int pageSize = 10;
		int offset = (page - 1) * pageSize;

		// 1. 목록 조회 (10개씩)
		List<QnaDto> list = qnaService.getQnaList(category, keyword, offset, pageSize);

		// 2. 전체 게시글 수 조회
		int totalCount = qnaService.getQnaCount(category, keyword);

		// 3. 전체 페이지 수 계산
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		Map<String, Object> map = new HashMap<>();
		map.put("qnalist", list);
		map.put("page", page);
		map.put("pageSize", pageSize);
		map.put("totalCount", totalCount);
		map.put("totalPages", totalPages);

		return map;
	}

	// Q&A 등록
	@PostMapping("/addqna")
	public int addqna(@RequestBody QnaDto dto) {
		System.out.println("QnaController addqna() " + new Date());
		return qnaService.writeQna(dto);
	}

	// 내 Q&A 목록 조회
	@PostMapping("/myqna")
	public List<QnaDto> myqna(@RequestBody(required = false) Map<String, String> body,
			@RequestParam(value = "writerId", required = false) String paramWriterId) {
		System.out.println("QnaController myqna() " + new Date());
		String writerId = (body != null && body.containsKey("writerId")) ? body.get("writerId") : paramWriterId;
		return qnaService.getMyQnaList(writerId);
	}

	// Q&A 상세 조회 (조회수 증가 로직 포함)
	@PostMapping("/detailqna")
	public QnaDto detailqna(@RequestParam("seq") Long seq) {
		System.out.println("QnaController detailqna() seq=" + seq + " " + new Date());

		// 1. 조회수 1 증가 실행
		qnaService.increaseReadCount(seq);

		// 2. Q&A 상세 정보 조회 및 반환
		return qnaService.getQnaDetail(seq);
	}

	// Q&A 답변 등록 및 수정, 삭제 처리
	@PostMapping("/answerqna")
	public int answerqna(@RequestBody QnaDto dto) {
		System.out.println("QnaController answerqna() seq=" + dto.getSeq() + " " + new Date());
		return qnaService.answerQna(dto);
	}

	// 2. Q&A 삭제 (JSON Body 받도록 @RequestBody 적용 또는 Query Param 전송으로 변경)
	@PostMapping("/deleteqna")
	public int deleteqna(@RequestBody QnaDto dto) {
		System.out.println("QnaController deleteqna() seq=" + dto.getSeq() + " " + new Date());
		return qnaService.deleteQna(dto.getSeq());
	}

	// 관리자가 Q&A 문의글  수정 
	@PostMapping("/updateqna")
	public int updateqna(@RequestBody QnaDto dto) {
		System.out.println("QnaController updateqna() seq=" + dto.getSeq() + " " + new Date());
		return qnaService.updateQna(dto);
	}
}