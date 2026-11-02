<template>
  <div class="notice-page">
    <h2>공지사항</h2>

    <!-- 관리자에게만 공지사항 등록 버튼 표시 -->
    <div v-if="isAdmin" class="admin-menu">
      <button type="button" @click="writeNotice">공지사항 등록</button>
    </div>

    <!-- 공지사항 목록 테이블 -->
    <div class="bbslist">
      <table class="table table-hover">
        <colgroup>
          <col width="100" />
          <col width="500" />
          <col width="100" />
          <col width="170" />
          <col v-if="isAdmin" width="160" />
        </colgroup>

        <thead>
          <tr>
            <th>번호</th>
            <th>제목</th>
            <th>조회수</th>
            <th>작성일</th>
            <th v-if="isAdmin">관리</th>
          </tr>
        </thead>

        <tbody>
          <!-- 공지사항 목록 반복 -->
          <tr v-for="(notice, index) in noticelist" :key="notice.seq">
            <td>
              <span v-if="notice.ispinned">📌</span>
              {{ (page - 1) * pageSize + index + 1 }}
            </td>
            <td class="notice-title" @click="goNoticeDetail(notice.seq)">
              {{ notice.title }}
            </td>
            <td>{{ notice.readcount }}</td>
            <!-- 날짜 포맷 함수 호출 적용 -->
            <td>{{ formatDate(notice.wdate) }}</td>

            <!-- 관리자 전용 수정·삭제 버튼 -->
            <td v-if="isAdmin">
              <button type="button" @click.stop="updateNotice(notice.seq)">수정</button>
              <button type="button" @click.stop="deleteNotice(notice.seq)">삭제</button>
            </td>
          </tr>

          <!-- 공지사항이 없는 경우 -->
          <tr v-if="noticelist.length === 0">
            <td :colspan="isAdmin ? 5 : 4">등록된 공지사항이 없습니다.</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 하단 영역: 페이징 + 검색창 -->
    <div class="bottom-area">
      <!-- 가운데 정렬 페이징 버튼 -->
      <div v-if="totalPages > 0" class="pagination">
        <button type="button" :disabled="page === 1" @click="changePage(page - 1)">
          이전
        </button>
        <button
          v-for="p in totalPages"
          :key="p"
          type="button"
          :class="{ active: p === page }"
          @click="changePage(p)"
        >
          {{ p }}
        </button>
        <button type="button" :disabled="page === totalPages" @click="changePage(page + 1)">
          다음
        </button>
      </div>

      <!-- 하단 검색창 -->
      <div class="search-box">
        <select v-model="category">
          <option value="">전체</option>
          <option value="title">제목</option>
          <option value="content">내용</option>
        </select>
        <input
          type="text"
          v-model="keyword"
          placeholder="검색어를 입력하세요"
          @keyup.enter="searchNotice"
        />
        <button type="button" @click="searchNotice">검색</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

// sessionStorage에서 로그인 정보 가져오기
const getLoginData = () => {
  try {
    const loginData = sessionStorage.getItem("login");
    if (!loginData || loginData === "null") return null;
    return JSON.parse(loginData);
  } catch (error) {
    console.error("로그인 정보 확인 오류:", error);
    return null;
  }
};

export default {
  name: "Notice",

  data() {
    return {
      noticelist: [],
      page: 1,
      pageSize: 10,
      totalPages: 0,
      totalCount: 0,
      category: "",
      keyword: ""
    };
  },

  computed: {
    isAdmin() {
      const login = getLoginData();
      return Number(login?.auth) === 1;
    }
  },

  mounted() {
    this.getNoticeList();
  },

  methods: {
    // 날짜 포맷 함수 (YYYY-MM-DD HH:mm)
    formatDate(dateStr) {
      if (!dateStr) return "";
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr; // 유효하지 않은 날짜 문자열일 경우 원본 반환

      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");

      return `${year}-${month}-${day} ${hours}:${minutes}`;
    },

    // 공지사항 페이징 목록 조회
    getNoticeList() {
      axios
        .get("http://localhost:8282/allnotice", {
          params: {
            page: this.page,
            category: this.category,
            keyword: this.keyword
          }
        })
        .then((resp) => {
          this.noticelist = resp.data.noticelist || [];
          this.totalPages = resp.data.totalPages || 0;
          this.totalCount = resp.data.totalCount || 0;
        })
        .catch((error) => {
          console.error("공지사항 목록 조회 오류:", error);
        });
    },

    // 검색 실행
    searchNotice() {
      this.page = 1;
      this.getNoticeList();
    },

    // 페이지 변경
    changePage(p) {
      if (p < 1 || p > this.totalPages) return;
      this.page = p;
      this.getNoticeList();
    },

    // 상세 화면 이동
    goNoticeDetail(seq) {
      this.$router.push({
        name: "noticedetail",
        params: { seq: seq }
      });
    },

    // 등록 화면 이동
    writeNotice() {
      if (!this.isAdmin) return alert("관리자만 공지사항을 등록할 수 있습니다.");
      this.$router.push({ name: "noticewrite" });
    },

    // 수정 화면 이동
    updateNotice(seq) {
      if (!this.isAdmin) return alert("관리자만 공지사항을 수정할 수 있습니다.");
      this.$router.push({
        name: "noticeupdate",
        params: { seq: seq }
      });
    },

    // 공지사항 삭제
    deleteNotice(seq) {
      if (!this.isAdmin) return alert("관리자만 공지사항을 삭제할 수 있습니다.");
      if (!confirm("공지사항을 삭제하시겠습니까?")) return;

      const params = new URLSearchParams();
      params.append("seq", seq);

      axios
        .post("http://localhost:8282/deletenotice", params)
        .then((resp) => {
          if (resp.data > 0) {
            alert("공지사항이 삭제되었습니다.");
            this.getNoticeList();
          } else {
            alert("공지사항 삭제에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("공지사항 삭제 오류:", error);
          alert("삭제 중 오류가 발생했습니다.");
        });
    },

    goFaq() {
      this.$router.push({ name: "faq" });
    },
    goNotice() {
      this.$router.push({ name: "notice" });
    },
    goQna() {
      this.$router.push({ name: "qna" });
    }
  }
};
</script>

<style scoped src="@/components/Css/Notice.styles.css"></style>