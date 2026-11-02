<template>
  <div class="faq-detail">
    <h2>자주 묻는 질문 상세보기</h2>
    <!-- 선택한 게시글의 상세 정보 -->
    <table>
      <tbody>
      <tr><th>제목</th><td>{{ faq.title }}</td></tr>
      <tr><th>작성자</th><td>{{ faq.id }}</td></tr>
      <tr><th>작성일</th><td>{{ formatDate(faq.wdate) }}</td></tr>
      <tr><th>내용</th><td class="content">{{ faq.content }}</td></tr>
    </tbody>
  </table>
    <div class="button-area">
      <button v-if="isAdmin" type="button" @click="updateFaq">수정</button>
      <button type="button" @click="goList">목록</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";

const getLoginData = () => {
  try {
    const value = sessionStorage.getItem("login");
    return value && value !== "null" ? JSON.parse(value) : null;
  } catch (error) {
    console.error("로그인 정보 확인 오류:", error);
    return null;
  }
};

export default {
  data() {
    return { faq: { seq: null, id: "", title: "", content: "", readcount: 0, ispinned: false, wdate: "" } };
  },
  computed: {
    isAdmin() { return Number(getLoginData()?.auth) === 1; }
  },
  mounted() { this.getFaq(); },
  
  methods: {
    getFaq() {
      const seq = this.$route.params.seq;
      axios.get(`http://localhost:8282/faq/${seq}`)
        .then((resp) => { this.faq = resp.data; })
        .catch((error) => {
          console.error(error);
          alert("게시글을 불러오지 못했습니다.");
          this.$router.push({ name: "faq" });
        });
    },
    updateFaq() {
      this.$router.push({ name: "faqupdate", params: { seq: this.faq.seq } });
    },
    goList() { this.$router.push({ name: "faq" }); },
    
    // 작성일 포맷팅 함수 (methods 내부 배치)
    formatDate(dateStr) {
      if (!dateStr) return "-";
      // T 구분자 제거 및 2026-07-16 10:10 분 단위까지만 깔끔하게 표기
      const cleanStr = dateStr.replace("T", " ");
      return cleanStr.substring(0, 16);
    }
  }
};
</script>

<style scoped src="@/components/Css/Faqdetail.styles.css"></style>
