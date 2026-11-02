<template>
  <div>
    <h2>공지사항 상세보기</h2>

    <!-- 선택한 공지사항의 상세 정보 -->
    <table>
      <colgroup>
        <col width="150" />
        <col width="600" />
      </colgroup>

      <tbody>
        <tr>
          <th>제목</th>
          <td>
            <span v-if="notice.ispinned">📌</span>
            {{ notice.title }}
          </td>
        </tr>

        <tr>
          <th>작성자</th>
          <td>{{ notice.writerId }}</td>
        </tr>

        <tr>
          <th>조회수</th>
          <td>{{ notice.readcount }}</td>
        </tr>

        <tr>
          <th>작성일</th>
          <!-- 날짜 포맷 함수 적용 -->
          <td>{{ formatDate(notice.wdate) }}</td>
        </tr>

        <tr>
          <th>내용</th>
          <td>{{ notice.content }}</td>
        </tr>
      </tbody>
    </table>

    <!-- 관리자는 수정·삭제 가능, 모든 사용자는 목록 이동 가능 -->
    <div>
      <button
        v-if="isAdmin"
        type="button"
        @click="updateNotice"
      >
        수정
      </button>

      <button
        v-if="isAdmin"
        type="button"
        @click="deleteNotice"
      >
        삭제
      </button>

      <button type="button" @click="goList">목록</button>
    </div>
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
  name: "NoticeDetail",

  data() {
    return {
      // 서버에서 받아올 공지사항 상세 정보
      notice: {
        seq: null,
        writerId: "",
        title: "",
        content: "",
        readcount: 0,
        wdate: "",
        ispinned: false,
        isdeleted: false
      }
    };
  },

  computed: {
    // auth가 1인 회원인지 확인
    isAdmin() {
      return Number(getLoginData()?.auth) === 1;
    }
  },

  mounted() {
    // 화면이 열리면 공지사항 상세 정보 조회
    this.getNotice();
  },

  methods: {
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
    },

    // URL의 seq를 이용해 공지사항 상세 조회
    getNotice() {
      const seq = this.$route.params.seq;

      axios
        .post("http://localhost:8282/detailnotice", null, {
          params: { seq: seq }
        })
        .then((resp) => {
          this.notice = resp.data;
        })
        .catch((error) => {
          console.error("공지사항 상세 조회 오류:", error);
          alert("공지사항을 불러오지 못했습니다.");
          this.$router.push({ name: "notice" });
        });
    },

    // 공지사항 수정 화면으로 이동
    updateNotice() {
      if (!this.isAdmin) {
        return alert("관리자만 공지사항을 수정할 수 있습니다.");
      }

      this.$router.push({
        name: "noticeupdate",
        params: { seq: this.notice.seq }
      });
    },

    // 공지사항을 삭제 상태로 변경
    deleteNotice() {
      if (!this.isAdmin) {
        return alert("관리자만 공지사항을 삭제할 수 있습니다.");
      }

      if (!confirm("공지사항을 삭제하시겠습니까?")) return;

      axios
        .post("http://localhost:8282/updatenotice", {
          ...this.notice,
          isdeleted: true
        }, {
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

    // 공지사항 목록으로 이동
    goList() {
      this.$router.push({ name: "notice" });
    }
  }
};
</script>

