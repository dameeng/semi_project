package com.mbc.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbc.project.dto.BoardDto;
import com.mbc.project.dto.StoresDto;

@Mapper // 스프링부트에 DB와의 소통한다고 알려주는 애노테이션(Annotation)
public interface StoresDao {
	// 1. 상가 전체 목록 (Stores)
    List<StoresDto> allstores();      // 상가 전체 목록 조회

    // 2. 층별 상가 위치
    List<StoresDto> storesfloor(int floor);   // 지정한 층의 상가 목록 조회

    // 3. 모든 권한 상가 상세 조회
    StoresDto storedetail(int storeNum);      // 상가 상세 조회

    // 4. 관리자가 상가 추가
    int addstore(StoresDto dto);              // 상가 등록

    // 5. 관리자가 상가 수정
    int updatestore(StoresDto dto);           // 상가 수정

    // 6. 관리자가 상가 삭제
    int deletestore(int storeNum);            // 상가 삭제

}