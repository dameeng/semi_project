package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbc.project.dto.FaqDto;

@Mapper
	public interface FaqDao {

	    List<FaqDto> faqlist();          // 전체 조회

	    FaqDto getfaq(Integer faqid);        // 상세 조회

	    int addfaq(FaqDto dto);          // 등록

	    int updatefaq(FaqDto dto);       // 수정

	    int deletefaq(int faqid);        // 삭제

	}
