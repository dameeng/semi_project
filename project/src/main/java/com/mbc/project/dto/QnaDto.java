package com.mbc.project.dto;

import java.time.LocalDateTime;

public class QnaDto {
	
	
    // 기본 생성자
public QnaDto() {

	}
private Long seq;
private String writerId;
private String title;
private String content;
private Integer readcount;
private LocalDateTime wdate;
private String boardType;
private Boolean issecret;       // 비밀글 여부
private String status;          // 답변 상태 (WAITING / COMPLETED)
private String replycontent;    // 관리자 답변 내용
private LocalDateTime replydate;// 관리자 답변 작성 시간
public QnaDto(Long seq, String writerId, String title, String content, Integer readcount, LocalDateTime wdate,
		String boardType, Boolean issecret, String status, String replycontent, LocalDateTime replydate) {
	super();
	this.seq = seq;
	this.writerId = writerId;
	this.title = title;
	this.content = content;
	this.readcount = readcount;
	this.wdate = wdate;
	this.boardType = boardType;
	this.issecret = issecret;
	this.status = status;
	this.replycontent = replycontent;
	this.replydate = replydate;
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
public Boolean getIssecret() {
	return issecret;
}
public void setIssecret(Boolean issecret) {
	this.issecret = issecret;
}
public String getStatus() {
	return status;
}
public void setStatus(String status) {
	this.status = status;
}
public String getReplycontent() {
	return replycontent;
}
public void setReplycontent(String replycontent) {
	this.replycontent = replycontent;
}
public LocalDateTime getReplydate() {
	return replydate;
}
public void setReplydate(LocalDateTime replydate) {
	this.replydate = replydate;
}

}
