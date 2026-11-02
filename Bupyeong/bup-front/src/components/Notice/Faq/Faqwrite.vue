<template>
  <div class="faq-form-page">
    <h2>자주 묻는 질문 등록</h2>
    <!-- 관리자에게만 등록 양식 표시 -->
    <div v-if="isAdmin">
      <table>
        <tbody>
        <tr><th>제목</th><td><input v-model="title" type="text" placeholder="제목을 입력해주세요." /></td></tr>
        <tr>
            <th>내용</th>
            <td><textarea v-model="content" placeholder="내용을 입력해주세요."></textarea></td>
        </tr>
        <tr>
            <th>상단 고정</th>
            <td>
                <label><input v-model="ispinned" type="checkbox" /> 상단에 고정</label>
            </td>
        </tr>
      </tbody>
    </table>
      <div class="button-area">
        <button type="button" @click="writeFaq">등록</button>
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
    }
  },
  methods: {
    // 입력값 검사 후 Faq 등록
    writeFaq() {
      //if (!this.isAdmin) return alert("관리자만 글을 등록할 수 있습니다.");
      if (!this.title.trim()) return alert("제목을 입력해주세요.");
      if (!this.content.trim()) return alert("내용을 입력해주세요.");

      const param = { title: this.title, content: this.content, ispinned: this.ispinned };
      axios.post("http://localhost:8282/faq", param, { withCredentials: true })
        .then((resp) => {
          if (resp.data === true) {
            alert("등록되었습니다.");
            this.$router.push({ name: "faq" });
          } else alert("등록에 실패했습니다.");
        })
        .catch((error) => {
          console.error(error);
          if (error.response?.status === 401) alert("로그인이 필요합니다.");
          else if (error.response?.status === 403) alert("관리자만 등록할 수 있습니다.");
          else alert("등록 중 오류가 발생했습니다.");
        });
    },
    cancel() { this.$router.push({ name: "faq" }); }
  }
};
</script>

<style scoped src="@/components/Css/Faqwrite.styles.css"></style>
