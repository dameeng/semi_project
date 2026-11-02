<template>
  <div>
    <h2>1대1 문의 상세</h2>

 

    <!-- 문의 상세 정보 -->
    <div>
      <table>
        <colgroup>
          <col width="150" />
          <col width="600" />
        </colgroup>

        <tbody>
          <tr>
            <th>제목</th>
            <td>{{ qna.title }}</td>
          </tr>

          <tr>
            <th>작성자</th>
            <td>{{ qna.writerId }}</td>
          </tr>

          <tr>
            <th>작성일</th>
            <!-- 작성일 포맷팅 적용 -->
            <td>{{ formatDate(qna.wdate) }}</td>
          </tr>

          <tr>
            <th>조회수</th>
            <td>{{ qna.readcount }}</td>
          </tr>

          <tr>
            <th>공개 여부</th>
            <td>
              <span v-if="qna.issecret">🔒 비공개</span>
              <span v-else>공개</span>
            </td>
          </tr>

          <tr>
            <th>답변 상태</th>
            <td>
              <span v-if="qna.status === 'COMPLETED'">답변완료</span>
              <span v-else>답변대기</span>
            </td>
          </tr>

          <tr>
            <th>문의 내용</th>
            <td class="content-cell">{{ qna.content }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 관리자 답변 -->
    <div>
      <h3>관리자 답변</h3>

      <!-- 관리자 답변 작성·수정창 -->
      <div v-if="isAdmin && answerEditing">
        <textarea
          v-model="answerContent"
          rows="7"
          cols="70"
          placeholder="답변 내용을 입력해주세요."
        ></textarea>

        <br />

        <button type="button" @click="saveAnswer">답변 저장</button>
        <button type="button" @click="cancelAnswer">취소</button>
      </div>

      <!-- 답변 작성·수정 중이 아닐 때 -->
      <div v-else>
        <!-- 등록된 답변 표시 -->
        <p v-if="qna.replycontent" class="content-cell">
          {{ qna.replycontent }}
        </p>

        <!-- 답변이 없는 경우 -->
        <p v-else>
          아직 등록된 답변이 없습니다.
        </p>

        <!-- 관리자에게만 표시되는 버튼 -->
        <div v-if="isAdmin">
          <!-- 답변이 없으면 등록 버튼 -->
          <button
            v-if="!qna.replycontent"
            type="button"
            @click="writeAnswer"
          >
            답변 등록
          </button>

          <!-- 답변이 있으면 수정·삭제 버튼 -->
          <template v-else>
            <button type="button" @click="updateAnswer">답변 수정</button>
            <button type="button" @click="deleteAnswer">답변 삭제</button>
          </template>
        </div>
      </div>
    </div>

    <!-- 하단 버튼 -->
    <div>
      <button type="button" @click="goQna">목록</button>

      <!-- 작성자 또는 관리자에게 표시 -->
      <template v-if="canEdit">
        <button type="button" @click="goQnaUpdate">문의 수정</button>
        <button type="button" @click="deleteQna">문의 삭제</button>
      </template>
    </div>
  </div>
</template>

<script>
import axios from "axios";

const getLoginData = () => {
  const loginData = sessionStorage.getItem("login");

  if (!loginData || loginData === "null") {
    return null;
  }

  try {
    return JSON.parse(loginData);
  } catch (error) {
    console.error("로그인 정보 확인 오류:", error);
    return null;
  }
};

export default {
  name: "qnadetail",

  data() {
    return {
      login: null,
      answerEditing: false,
      answerContent: "",
      seq: null,
      qna: {
        seq: null,
        title: "",
        content: "",
        writerId: "",
        wdate: "",
        readcount: 0,
        issecret: false,
        status: "WAITING",
        replycontent: ""
      }
    };
  },

  computed: {
    isAdmin() {
      return Number(this.login?.auth) === 1;
    },

    isWriter() {
      return (
        this.login?.id &&
        this.qna?.writerId &&
        String(this.login.id).trim() === String(this.qna.writerId).trim()
      );
    },

    canEdit() {
      return this.isAdmin || this.isWriter;
    }
  },

  mounted() {
    this.login = getLoginData();
    this.seq = this.$route.params.seq;
    
    if (this.seq) {
      this.getQnaDetail();
    } else {
      alert("올바르지 않은 접근입니다.");
      this.goQna();
    }
  },

  methods: {
    getQnaDetail() {
      const params = new URLSearchParams();
      params.append("seq", this.seq);

      axios
        .post("http://localhost:8282/detailqna", params)
        .then((resp) => {
          if (resp.data) {
            // 비밀글 권한 체크
            if (resp.data.issecret && !this.isAdmin && this.login?.id !== resp.data.writerId) {
              alert("비공개 글은 작성자 및 관리자만 조회 가능합니다.");
              this.goQna();
              return;
            }
            this.qna = resp.data;
          } else {
            alert("게시글을 불러올 수 없습니다.");
            this.goQna();
          }
        })
        .catch((error) => {
          console.error("QnA 상세 정보 조회 오류:", error);
        });
    },

    writeAnswer() {
      if (!this.isAdmin) return alert("관리자만 답변을 작성할 수 있습니다.");
      this.answerContent = "";
      this.answerEditing = true;
    },

    updateAnswer() {
      if (!this.isAdmin) return alert("관리자만 답변을 수정할 수 있습니다.");
      this.answerContent = this.qna.replycontent;
      this.answerEditing = true;
    },

    saveAnswer() {
      if (!this.isAdmin) return alert("관리자만 답변을 저장할 수 있습니다.");
      if (!this.answerContent.trim()) return alert("답변 내용을 입력해주세요.");

      const dto = {
        seq: this.seq,
        replycontent: this.answerContent,
        status: "COMPLETED"
      };

      axios
        .post("http://localhost:8282/answerqna", dto)
        .then((resp) => {
          if (resp.data > 0) {
            alert("답변이 성공적으로 저장되었습니다.");
            this.answerEditing = false;
            this.getQnaDetail();
          } else {
            alert("답변 저장에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("답변 저장 오류:", error);
          alert("답변 저장 중 오류가 발생했습니다.");
        });
    },

    cancelAnswer() {
      this.answerContent = "";
      this.answerEditing = false;
    },

    deleteAnswer() {
      if (!this.isAdmin) return alert("관리자만 답변을 삭제할 수 있습니다.");
      if (!confirm("관리자 답변을 삭제하시겠습니까?")) return;

      const dto = {
        seq: this.seq,
        replycontent: "",
        status: "WAITING"
      };

      axios
        .post("http://localhost:8282/answerqna", dto)
        .then((resp) => {
          if (resp.data > 0) {
            alert("답변이 삭제되었습니다.");
            this.getQnaDetail();
          } else {
            alert("답변 삭제에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("답변 삭제 오류:", error);
          alert("답변 삭제 중 오류가 발생했습니다.");
        });
    },

    goQnaUpdate() {
      this.$router.push({
        name: "qnaupdate",
        params: { seq: this.qna.seq }
      });
    },

    deleteQna() {
      if (!this.canEdit) {
        alert("문의글을 삭제할 권한이 없습니다.");
        return;
      }
      if (!confirm("문의글을 삭제하시겠습니까?")) {
        return;
      }

      axios
        .post("http://localhost:8282/deleteqna", { seq: Number(this.qna.seq) })
        .then((resp) => {
          if (resp.data > 0) {
            alert("문의글이 삭제되었습니다.");
            this.goQna();
          } else {
            alert("문의글 삭제에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("문의글 삭제 오류:", error);

          if (error.response) {
            console.error("HTTP 상태:", error.response.status);
            console.error("서버 응답:", error.response.data);
          }

          alert("문의글 삭제 중 오류가 발생했습니다.");
        });
    },

    goFaq() {
      this.$router.push({ name: "faq" });
    },

    goNotice() {
      this.$router.push({ name: "notice" });
    },

    goQna() {
      this.$router.push({name:'qna'})
    },

    // 서버에서 받은 시간을 읽기 편하게 바꿈
    formatDate(dateStr) {
      if (!dateStr) return "-";
      return String(dateStr).replace("T", " ").substring(0, 16);
    }
  }
};
</script>

<style scoped src="@/components/Css/QnaDetail.styles.css"></style>