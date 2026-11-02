package com.mbc.project.dto;

import java.time.LocalDateTime;

public class FaqDto {

    private Integer faqid;          // FAQ 고유번호
    private Integer seq;            // 프론트엔드 호환용 글번호 (faqid 동일)
    private String title;           // 질문 제목
    private String content;         // 답변 내용
    private String id;              // 작성자 아이디
    private Integer readcount = 0;  // 조회수 (기본값 0)
    private Boolean ispinned = false; // 상단 고정 여부
    private Boolean isdeleted = false; // 삭제 여부
    private LocalDateTime wdate;    // 등록일

    public FaqDto() {
    }

    public FaqDto(Integer faqid, String title, String content, String id, LocalDateTime wdate) {
        super();
        this.faqid = faqid;
        this.seq = faqid;
        this.title = title;
        this.content = content;
        this.id = id;
        this.wdate = wdate;
    }

    public Integer getFaqid() {
        return faqid;
    }

    public void setFaqid(Integer faqid) {
        this.faqid = faqid;
        if (this.seq == null) {
            this.seq = faqid;
        }
    }

    public Integer getSeq() {
        return seq != null ? seq : faqid;
    }

    public void setSeq(Integer seq) {
        this.seq = seq;
        if (this.faqid == null) {
            this.faqid = seq;
        }
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getReadcount() {
        return readcount != null ? readcount : 0;
    }

    public void setReadcount(Integer readcount) {
        this.readcount = readcount;
    }

    public Boolean getIspinned() {
        return ispinned != null ? ispinned : false;
    }

    public void setIspinned(Boolean ispinned) {
        this.ispinned = ispinned;
    }

    public Boolean getIsdeleted() {
        return isdeleted != null ? isdeleted : false;
    }

    public void setIsdeleted(Boolean isdeleted) {
        this.isdeleted = isdeleted;
    }

    public LocalDateTime getWdate() {
        return wdate;
    }

    public void setWdate(LocalDateTime wdate) {
        this.wdate = wdate;
    }
}