<template>
  <div class="faq-page">
    <h2>자주 묻는 질문</h2>

   

    <!-- 관리자에게만 글 등록 버튼 표시 -->
    <div v-if="isAdmin" class="admin-menu">
      <button type="button" @click="writeFaq">글 등록</button>
    </div>

    <div class="bbslist">
      <table class="table table-hover">
        <colgroup>
          <col width="100" />
          <col width="500" />
          <col width="100" />
          <col v-if="isAdmin" width="160" />
        </colgroup>
        <thead>
          <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th v-if="isAdmin">관리</th>
          </tr>
        </thead>
        <tbody>
          <!-- Faq 게시글 목록 -->
          <tr v-for="(bbs, index) in pagedBbsList" :key="bbs.seq">
            <td><span v-if="bbs.ispinned">📌</span>{{ (page - 1) * pageSize + index + 1 }}</td>
            <td class="faq-title" @click="goFaqDetail(bbs.seq)">{{ bbs.title }}</td>
            <td>{{ bbs.id }}</td>
            <td v-if="isAdmin">
              <button type="button" @click.stop="updateFaq(bbs.seq)">수정</button>
              <button type="button" @click.stop="deleteFaq(bbs.seq)">삭제</button>
            </td>
          </tr>
          <tr v-if="filteredBbsList.length === 0">
            <td :colspan="isAdmin ? 4 : 3">등록된 자주 묻는 질문이 없습니다.</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 📌 하단 영역: 페이징 + 검색창 추가 -->
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
        <button type="button" :disabled="page === totalPages || totalPages === 0" @click="changePage(page + 1)">
          다음
        </button>
      </div>

      <!-- 하단 검색창 -->
      <div class="search-box">
        <select v-model="category">
          <option value="all">전체</option>
          <option value="title">제목</option>
          <option value="content">내용</option>
        </select>
        <input
          type="text"
          v-model="keyword"
          placeholder="검색어를 입력하세요"
          @keyup.enter="searchFaq"
        />
        <button type="button" class="btn-search" @click="searchFaq">검색</button>
        <button v-if="isSearched" type="button" class="btn-reset" @click="resetSearch">전체목록</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

// 세션에 저장된 로그인 정보를 안전하게 가져온다.
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
  data() {
    return {
      bbslist: [],
      page: 1,
      pageSize: 10,
      category: "all",
      keyword: "",
      searchKeyword: "",
      searchCategory: "all",
      isSearched: false
    };
  },
  computed: {
    // auth가 1인 회원만 관리자로 판단한다.
    isAdmin() {
      const login = getLoginData();
      return Number(login?.auth) === 1;
    },
    // 검색 필터링된 데이터
    filteredBbsList() {
      if (!this.isSearched || !this.searchKeyword.trim()) {
        return this.bbslist;
      }
      const kw = this.searchKeyword.trim().toLowerCase();
      return this.bbslist.filter((item) => {
        const titleMatch = item.title ? item.title.toLowerCase().includes(kw) : false;
        const contentMatch = item.content ? item.content.toLowerCase().includes(kw) : false;

        if (this.searchCategory === "title") return titleMatch;
        if (this.searchCategory === "content") return contentMatch;
        return titleMatch || contentMatch;
      });
    },
    // 페이지수 계산
    totalPages() {
      return Math.ceil(this.filteredBbsList.length / this.pageSize) || 1;
    },
    // 현재 페이지에 노출될 목록 10개 slice
    pagedBbsList() {
      const start = (this.page - 1) * this.pageSize;
      return this.filteredBbsList.slice(start, start + this.pageSize);
    }
  },
  mounted() {
    // 화면 진입 시 목록을 불러온다.
    this.getFaqList();
  },
  methods: {
    // Faq 전체 목록 조회
    getFaqList() {
      axios.get("http://localhost:8282/faqlist")
        .then((resp) => { this.bbslist = resp.data; })
        .catch((error) => {
          console.error(error);
        });
    },
    searchFaq() {
      if (!this.keyword.trim()) {
        alert("검색어를 입력해주세요.");
        return;
      }
      this.searchKeyword = this.keyword;
      this.searchCategory = this.category;
      this.isSearched = true;
      this.page = 1;
    },
    resetSearch() {
      this.keyword = "";
      this.searchKeyword = "";
      this.category = "all";
      this.searchCategory = "all";
      this.isSearched = false;
      this.page = 1;
    },
    changePage(p) {
      if (p < 1 || p > this.totalPages) return;
      this.page = p;
    },
    goFaqDetail(seq) {
      this.$router.push({ name: "faqdetail", params: { seq } });
    },
    // 관리자 글 등록 화면 이동
    writeFaq() {
      if (!this.isAdmin) return alert("관리자만 글을 등록할 수 있습니다.");
      this.$router.push({ name: "faqwrite" });
    },
    updateFaq(seq) {
      if (!this.isAdmin) return alert("관리자만 글을 수정할 수 있습니다.");
      this.$router.push({ name: "faqupdate", params: { seq } });
    },
    // 행을 지우지 않고 isdeleted 값을 변경하는 논리 삭제 요청
    deleteFaq(seq) {
      if (!this.isAdmin) return alert("관리자만 글을 삭제할 수 있습니다.");
      if (!confirm("정말 삭제하시겠습니까?")) return;

      axios.put(
        `http://localhost:8282/faq/${seq}`,
        { isdeleted: true },
        { withCredentials: true }
      )
        .then((resp) => {
          if (resp.data === true) {
            alert("삭제되었습니다.");
            this.getFaqList();
          } else {
            alert("삭제에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error(error);
          if (error.response?.status === 401) {
            alert("로그인이 필요합니다.");
            this.$router.push({ name: "login" });
          } else if (error.response?.status === 403) {
            alert("관리자만 삭제할 수 있습니다.");
          } else {
            alert("삭제 중 오류가 발생했습니다.");
          }
        });
    },
    goFaq() { this.$router.push({ name: "faq" }); },
    goNotice() { this.$router.push({ name: "notice" }); },
    goQna() { this.$router.push({ name: "qna" }); }
  }
};
</script>

<style scoped src="@/components/Css/Faq.styles.css"></style>