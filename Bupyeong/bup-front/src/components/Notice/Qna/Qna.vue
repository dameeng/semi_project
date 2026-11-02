<template>
  <div>
    <h2>1:1 질의응답 </h2>

    
    <div>
      <table>
        <colgroup>
          <col width="100"/>
          <col width="500"/>
          <col width="100"/>
          <col width="100"/>
          <col width="100"/>
          <col width="100"/>
          <col width="100"/>
        </colgroup>

        <thead>
          <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>조회수</th>
            <th>작성일</th>
            <th>공개여부</th>
            <th>답변상태</th>
          </tr>
        </thead>

        <tbody>
          <!-- tr에 v-for를 적용하여 반복문 실행 -->
          <tr v-for="(qna, index) in qnalist" :key="qna.seq || index">
            <td>{{ (pageNumber - 1) * perPage + index + 1 }}</td>    
            <td @click="qnaDetail(qna)" class="text-underline-hover" style="cursor: pointer;">
              <span v-if="qna.issecret">🔒</span>
              {{ dot3(qna.title) }}   
            </td>
            <td>{{ qna.writerId }}</td>
            <td>{{ qna.readcount }}</td>
            <td>{{ formatDate(qna.wdate) }}</td>
            <td>
              <span v-if="qna.issecret">비공개</span>
              <span v-else>공개</span>
            </td>
            <td>
              <span v-if="qna.status === 'COMPLETED'" class="completed">답변완료</span>
              <span v-else class="waiting">답변대기</span>
            </td>
          </tr>

          <!-- 데이터가 없을 때 -->
          <tr v-if="qnalist.length === 0">
            <td colspan="7">등록된 응답이 없습니다</td>
          </tr>
        </tbody>
      </table>

      <!-- 페이징 -->
      <div class="overflow-auto my-3">
        <b-pagination 
          v-model="pageNumber" 
          :total-rows="cnt" 
          :per-page="perPage" 
          align="center"
          prev-text="이전"
          next-text="다음"
          hide-goto-end-buttons
          @page-click="pageClick" 
          aria-controls="my-table">
        </b-pagination>

        <div class="d-flex justify-content-center align-items-center">
          <!-- 검색 목록 -->
          <select v-model="category" class="form-select" style="width: auto">
            <option v-for="(option, index) in options" :value="option.value" :key="index">
              {{ option.text }}
            </option> 
          </select>&nbsp;&nbsp;

          <!-- 검색창 -->
          <div class="col-sm-3 my-1" style="width: auto">
            <input v-model="keyword" size="45" placeholder="검색어 입력" class="form-control" @keyup.enter="searchBtn"/>
          </div>&nbsp;&nbsp;

          <!-- 검색버튼 -->
          <button @click="searchBtn()" class="btn btn-primary">검색</button>&nbsp;

          <!-- 전체목록 돌아가기 버튼 -->
          <button v-if="isSearched" @click="resetSearch()" class="btn btn-secondary">전체목록</button>
        </div>
        <br>
        <router-link to="/QnaWrite" class="btn btn-primary">글추가</router-link>
        <br><br>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      qnalist: [],
      category: 'start',
      keyword: '',
      options: [
        { text: "선택", value: "start" },
        { text: "제목", value: "title" },
        { text: "내용", value: "content" },
        { text: "작성자", value: "writer" },
      ],
      pageNumber: 1,
      perPage: 10,
      cnt: 0,
      isSearched: false
    }
  },
  computed: {
    totalPage() {
      return Math.ceil(this.cnt / this.perPage);
    }
  },  
  mounted() {
    this.getQnalist();
  },
  methods: {
    getQnalist() {
      let params = {
        category: this.category === 'start' ? '' : this.category,
        keyword: this.keyword,
        page: this.pageNumber // 컨트롤러의 @RequestParam("page")에 맞춰 1부터 전송
      };

      axios.get("http://localhost:8282/allqna", { params: params })
        .then((resp) => {
          this.qnalist = resp.data.qnalist || [];
          this.cnt = resp.data.totalCount || 0; // 백엔드의 totalCount 매핑
        })
        .catch(error => {
          console.error("QnA 목록 조회 오류:", error);
        }); 
    },
    pageClick(button, page) {
      this.pageNumber = page;
      this.getQnalist();
    },
    dot3(title) {        
      if (!title) return '';
      return title.length >= 20 ? title.substring(0, 20) + "..." : title.trim();
    },
    searchBtn() {
      if (!this.keyword.trim()) {
        alert("검색어를 입력해주세요.");
        return;
      }
      this.isSearched = true;
      this.pageNumber = 1;
      this.getQnalist();
    },
    resetSearch() {
      this.keyword = '';
      this.category = 'start';
      this.isSearched = false;
      this.pageNumber = 1;
      this.getQnalist();
    },
    qnaDetail(qna) {
      const loginData = sessionStorage.getItem("login");
      let login = null;
      if (loginData && loginData !== "null") {
        try { login = JSON.parse(loginData); } catch(e) {}
      }
      
      const isWriter = login && login.id === qna.writerId;
      const isAdmin = login && Number(login.auth) === 1;

      if (qna.issecret && !isWriter && !isAdmin) {
        alert("비밀글은 작성자와 관리자만 볼 수 있습니다.");
        return;
      }

      this.$router.push({ name: 'qnadetail', params: { seq: qna.seq } });
    },
    goFaq() { this.$router.push({ name: "faq" }); },
    goNotice() { this.$router.push({ name: "notice" }); },
    goQna() { this.$router.push({ name: "Qna" }); },

    // 날짜 포맷 함수 (YYYY-MM-DD HH:mm)
    formatDate(dateStr) {
      if (!dateStr) return "";
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr;

      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");

      return `${year}-${month}-${day} ${hours}:${minutes}`;
    }
  }
}
</script>

<style scoped src="@/components/Css/Qna.styles.css"></style>
