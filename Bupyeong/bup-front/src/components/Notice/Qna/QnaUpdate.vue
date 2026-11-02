<template>
  <div class="qna-update">
    <h2>1:1 문의 수정</h2>

    <div v-if="canEdit">
      <table>
        <tbody>
          <tr>
            <th>작성자</th>
            <td>{{ qna.writerId }}</td>
          </tr>

          <tr>
            <th>제목</th>
            <td>
              <input
                v-model="qna.title"
                type="text"
                placeholder="제목을 입력해주세요."
              />
            </td>
          </tr>

          <tr>
            <th>문의 내용</th>
            <td>
              <textarea
                v-model="qna.content"
                rows="10"
                placeholder="문의 내용을 입력해주세요."
              ></textarea>
            </td>
          </tr>

          <tr>
            <th>공개 여부</th>
            <td>
              <label>
                <input
                  v-model="qna.issecret"
                  type="checkbox"
                />
                비공개 문의
              </label>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="button-area">
        <button type="button" @click="updateQna">
          수정 완료
        </button>

        <button type="button" @click="deleteQna">
          삭제
        </button>

        <button type="button" @click="cancel">
          취소
        </button>
      </div>
    </div>

    <p v-else>
      문의글을 수정할 권한이 없습니다.
    </p>
  </div>
</template>

<script>
import axios from "axios";

const getLoginData = () => {
  try {
    const loginData = sessionStorage.getItem("login");

    if (!loginData || loginData === "null") {
      return null;
    }

    return JSON.parse(loginData);
  } catch (error) {
    console.error("로그인 정보 확인 오류:", error);
    return null;
  }
};

export default {
  name: "qnaupdate",

  data() {
    return {
      login: null,

      qna: {
        seq: null,
        writerId: "",
        title: "",
        content: "",
        issecret: false,
        isdeleted: false
      }
    };
  },

  computed: {
    isAdmin() {
      return Number(this.login?.auth) === 1;
    },

    isWriter() {
      return (
        this.login &&
        this.login.id === this.qna.writerId
      );
    },

    canEdit() {
      return this.isAdmin || this.isWriter;
    }
  },

  mounted() {
    this.login = getLoginData();

    if (!this.login) {
      alert("로그인이 필요합니다.");
      this.$router.push({ name: "login" });
      return;
    }

    this.getQna();
  },

  methods: {
    getQna() {
      const seq = this.$route.params.seq;

      axios
        .post(
          "http://localhost:8282/detailqna",
          null,
          {
            params: { seq }
          }
        )
        .then((resp) => {
          if (!resp.data) {
            alert("문의글을 찾을 수 없습니다.");
            this.$router.push({ name: "qna" });
            return;
          }

          this.qna = {
            ...this.qna,
            ...resp.data,
            issecret: Boolean(resp.data.issecret)
          };

          if (!this.canEdit) {
            alert("문의글을 수정할 권한이 없습니다.");
            this.goDetail();
          }
        })
        .catch((error) => {
          console.error("문의글 조회 오류:", error);
          alert("문의글을 불러오지 못했습니다.");
          this.$router.push({ name: "qna" });
        });
    },

    updateQna() {
      if (!this.canEdit) {
        return alert("문의글을 수정할 권한이 없습니다.");
      }

      if (!this.qna.title.trim()) {
        return alert("제목을 입력해주세요.");
      }

      if (!this.qna.content.trim()) {
        return alert("문의 내용을 입력해주세요.");
      }

      const param = {
        seq: this.qna.seq,
        writerId: this.qna.writerId,
        title: this.qna.title.trim(),
        content: this.qna.content.trim(),
        issecret: this.qna.issecret,
        isdeleted: false
      };

      axios
        .post(
          "http://localhost:8282/updateqna",
          param,
          {
            withCredentials: true
          }
        )
        .then((resp) => {
          if (resp.data > 0 || resp.data === true) {
            alert("문의글이 수정되었습니다.");
            this.goDetail();
          } else {
            alert("문의글 수정에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("문의글 수정 오류:", error);
          alert("문의글 수정 중 오류가 발생했습니다.");
        });
    },

    deleteQna() {
  if (!this.canEdit) return alert("문의글을 삭제할 권한이 없습니다.");
  if (!confirm("문의글을 삭제하시겠습니까?")) return;

  const param = {
    seq: this.qna.seq,
    writerId: this.qna.writerId
  };

  axios
    .post("http://localhost:8282/deleteqna", param, { withCredentials: true })
    .then((resp) => {
      if (resp.data > 0 || resp.data === true) {
        alert("문의글이 삭제되었습니다.");
        this.$router.push({ name: "qna" });
      } else {
        alert("문의글 삭제에 실패했습니다.");
      }
    });
},

    goDetail() {
      this.$router.push({
        name: "qnadetail",
        params: {
          seq: this.$route.params.seq
        }
      });
    },

    cancel() {
      this.goDetail();
    }
  }
};
</script>

<style scoped src="@/components/Css/QnaUpdate.styles.css"></style>