<template>
  <div>
    <h2>공지사항 수정</h2>

    <!-- 관리자에게만 수정 폼 표시 -->
    <div v-if="isAdmin">
      <table>
        <tbody>
          <tr>
            <th>제목</th>
            <td>
              <input v-model="title" type="text" />
            </td>
          </tr>

          <tr>
            <th>내용</th>
            <td>
              <textarea
                v-model="content"
                rows="10"
                cols="60"
              ></textarea>
            </td>
          </tr>

          <tr>
            <th>상단 고정</th>
            <td>
              <label>
                <input v-model="ispinned" type="checkbox" />
                공지사항 상단에 고정
              </label>
            </td>
          </tr>
        </tbody>
      </table>

      <div>
        <button type="button" @click="updateNotice">
          수정 완료
        </button>

        <button type="button" @click="deleteNotice">
          삭제
        </button>

        <button type="button" @click="cancel">
          취소
        </button>
      </div>
    </div>

    <p v-else>관리자만 접근할 수 있습니다.</p>
  </div>
</template>

<script>
// 백엔드 API 요청에 사용하는 라이브러리
import axios from "axios";

// 세션에 저장된 로그인 정보 가져오기
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
  name: "NoticeUpdate",

  data() {
      return {
        // 수정 폼에 연결되는 공지사항 데이터
        title: "",
        content: "",
        ispinned: false,
        isdeleted: false
    };
  },

  computed: {
    // auth가 1인 회원인지 확인
    isAdmin() {
      return Number(getLoginData()?.auth) === 1;
    }
  },

  mounted() {
    // 관리자가 아니면 목록으로 이동
    if (!this.isAdmin) {
      alert("관리자만 접근할 수 있습니다.");
      this.$router.push({ name: "notice" });
      return;
    }

    // 기존 공지사항 정보를 수정 폼에 표시
    this.getNotice();
  },

  methods: {
    // URL의 seq를 이용해 기존 공지사항 조회
    getNotice() {
      const seq = this.$route.params.seq;

      axios
        .post("http://localhost:8282/detailnotice", null, {
          params: { seq: seq }
        })
        .then((resp) => {
          this.title = resp.data.title;
          this.content = resp.data.content;
          this.ispinned = Boolean(resp.data.ispinned);
          this.isdeleted = Boolean(resp.data.isdeleted);
        })
        .catch((error) => {
          console.error("공지사항 조회 오류:", error);
          alert("공지사항을 불러오지 못했습니다.");
          this.$router.push({ name: "notice" });
        });
    },

    // 입력값을 확인한 뒤 수정 내용 저장
    updateNotice() {
      if (!this.isAdmin) {
        return alert("관리자만 공지사항을 수정할 수 있습니다.");
      }

      if (!this.title.trim()) {
        return alert("제목을 입력해주세요.");
      }

      if (!this.content.trim()) {
        return alert("내용을 입력해주세요.");
      }

      // 백엔드로 전송할 수정 데이터
      const param = {
        seq: this.$route.params.seq,
          title: this.title,
          content: this.content,
          ispinned: this.ispinned,
          isdeleted: false
      };

      axios
        .post("http://localhost:8282/updatenotice", param, {
          withCredentials: true
        })
        .then((resp) => {
          if (resp.data > 0) {
            alert("공지사항이 수정되었습니다.");
            this.$router.push({
              name: "noticedetail",
              params: { seq: this.$route.params.seq }
            });
          } else {
            alert("공지사항 수정에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("공지사항 수정 오류:", error);
          alert("공지사항 수정 중 오류가 발생했습니다.");
        });
    },

    // 공지사항을 삭제 상태로 변경
    deleteNotice() {
      if (!this.isAdmin) {
        return alert("관리자만 공지사항을 삭제할 수 있습니다.");
      }

      if (!confirm("공지사항을 삭제하시겠습니까?")) return;

      // 실제 삭제 대신 삭제 여부를 true로 변경
      const param = {
        seq: this.$route.params.seq,
        title: this.title,
        content: this.content,
        ispinned: this.ispinned,
        isdeleted: true
      };

      axios
        .post("http://localhost:8282/updatenotice", param, {
          withCredentials: true
        })
        .then((resp) => {
          if (resp.data > 0) {
            alert("공지사항이 삭제되었습니다.");
            this.$router.push({ name: "notice" });
          } else {
            alert("공지사항 삭제에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("공지사항 삭제 오류:", error);
          alert("공지사항 삭제 중 오류가 발생했습니다.");
        });
    },

    // 수정을 취소하고 상세 화면으로 이동
    cancel() {
      this.$router.push({
        name: "noticedetail",
        params: { seq: this.$route.params.seq }
      });
    }
  }
};
</script>
