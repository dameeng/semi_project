<template>
  <div class="faq-form-page">
    <h2>자주 묻는 질문 수정</h2>
    <!-- 관리자에게만 수정 양식 표시 -->
    <div v-if="isAdmin">
      <table><tbody>
        <tr>
            <th>제목</th>
            <td><input v-model="title" type="text" /></td>
        </tr>
        <tr>
            <th>내용</th>
            <td><textarea v-model="content"></textarea></td>
        </tr>
        <tr>
            <th>상단 고정</th>
            <td><label><input v-model="ispinned" type="checkbox" /> 상단에 고정</label></td>
        </tr>
      </tbody>
    </table>
      <div class="button-area">
        <button type="button" @click="updateFaq">수정 완료</button>
        <button type="button" @click="deleteFaq">삭제</button>
        <button type="button" @click="cancel">취소</button>
      </div>
    </div>
    <p v-else>관리자만 접근할 수 있습니다.</p>
  </div>
</template>

<script>
import axios from "axios";

// 세션에 저장된 로그인 정보 확인
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
  data() { return { title: "", content: "", ispinned: false }; },
  computed: {
    isAdmin() { return Number(getLoginData()?.auth) === 1; }
  },
  mounted() {
    if (!this.isAdmin) {
      alert("관리자만 접근할 수 있습니다.");
      this.$router.push({ name: "faq" });
      return;
    }
    this.getFaq();
  },
  methods: {
    // 기존 게시글 정보 조회
    getFaq() {
      const seq = this.$route.params.seq;
      axios.get(`http://localhost:8282/faq/${seq}`)
        .then((resp) => {
          this.title = resp.data.title;
          this.content = resp.data.content;
          this.ispinned = Boolean(resp.data.ispinned);
        })
        .catch((error) => {
          console.error(error);
          alert("게시글을 불러오지 못했습니다.");
          this.$router.push({ name: "faq" });
        });
    },
    // 제목, 내용, 상단 고정 여부 수정
    updateFaq() {
      if (!this.title.trim()) return alert("제목을 입력해주세요.");
      if (!this.content.trim()) return alert("내용을 입력해주세요.");
      const seq = this.$route.params.seq;
      const param = {
        title: this.title,
        content: this.content,
        ispinned: this.ispinned,
        isdeleted: false
      };
      axios.put(`http://localhost:8282/faq/${seq}`, param, { withCredentials: true })
        .then((resp) => {
          if (resp.data === true) {
            alert("수정되었습니다.");
            this.$router.push({ name: "faq" });
          } else alert("수정에 실패했습니다.");
        })
        .catch((error) => this.handleError(error, "수정"));
    },
    // isdeleted 값을 변경하는 논리 삭제
    deleteFaq() {
      if (!confirm("정말 삭제하시겠습니까?")) return;
      const seq = this.$route.params.seq;
      const param = {
        title: this.title,
        content: this.content,
        ispinned: this.ispinned,
        isdeleted: true
      };
      axios.put(`http://localhost:8282/faq/${seq}`, param, { withCredentials: true })
        .then((resp) => {
          if (resp.data === true) {
            alert("삭제되었습니다.");
            this.$router.push({ name: "faq" });
          } else alert("삭제에 실패했습니다.");
        })
        .catch((error) => this.handleError(error, "삭제"));
    },
    handleError(error, action) {
      console.error(error);
      if (error.response?.status === 401) alert("로그인이 필요합니다.");
      else if (error.response?.status === 403) alert(`관리자만 ${action}할 수 있습니다.`);
      else alert(`${action} 중 오류가 발생했습니다.`);
    },
    cancel() { this.$router.push({ name: "faq" }); }
  }
};
</script>

<style scoped src="@/components/Css/Faqupdate.styles.css"></style>
