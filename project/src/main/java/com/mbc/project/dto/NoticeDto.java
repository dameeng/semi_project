package com.mbc.project.dto;

import java.time.LocalDateTime;

public class NoticeDto {
    private Long seq;
    private String writerId;
    private String title;
    private String content;
    private Integer readcount;
    private LocalDateTime wdate;
    private String boardType;
    private Boolean ispinned;  
// 기본 생성자
public NoticeDto() {
	}
public NoticeDto(Long seq, String writerId, String title, String content, Integer readcount, LocalDateTime wdate,
		String boardType, Boolean ispinned) {
	super();
	this.seq = seq;
	this.writerId = writerId;
	this.title = title;
	this.content = content;
	this.readcount = readcount;
	this.wdate = wdate;
	this.boardType = boardType;
	this.ispinned = ispinned;
}
public Long getSeq() {
	return seq;
}
public void setSeq(Long seq) {
	this.seq = seq;
}
public String getWriterId() {
	return writerId;
}
public void setWriterId(String writerId) {
	this.writerId = writerId;
}
public String getTitle() {
	return title;
}
public void setTitle(String title) {
	this.title = title;
}
public String getContent() {
	return content;
}
public void setContent(String content) {
	this.content = content;
}
public Integer getReadcount() {
	return readcount;
}
public void setReadcount(Integer readcount) {
	this.readcount = readcount;
}
public LocalDateTime getWdate() {
	return wdate;
}
public void setWdate(LocalDateTime wdate) {
	this.wdate = wdate;
}
public String getBoardType() {
	return boardType;
}
public void setBoardType(String boardType) {
	this.boardType = boardType;
}
public Boolean getIspinned() {
	return ispinned;
}
public void setIspinned(Boolean ispinned) {
	this.ispinned = ispinned;
}
}

