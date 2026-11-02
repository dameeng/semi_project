<template>
  <div>
    <h2>공지사항 등록</h2>

    <!-- 관리자에게만 등록 폼 표시 -->
    <div v-if="isAdmin">
      <table>
        <tbody>
          <tr>
            <th>제목</th>
            <td>
              <input
                v-model="title"
                type="text"
                placeholder="제목을 입력해주세요."
              />
            </td>
          </tr>

          <tr>
            <th>내용</th>
            <td>
              <textarea
                v-model="content"
                rows="10"
                cols="60"
                placeholder="내용을 입력해주세요."
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
        <button type="button" @click="writeNotice">등록</button>
        <button type="button" @click="cancel">취소</button>
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
  name: "NoticeWrite",

  data() {
    return {
      // 등록 폼에 연결되는 공지사항 데이터
      writerId: "",
      title: "",
      content: "",
      ispinned: false
    };
  },

  computed: {
    // auth가 1인 회원인지 확인
    isAdmin() {
      return Number(getLoginData()?.auth) === 1;
    }
  },

  mounted() {
    // 현재 로그인한 회원 정보 확인
    const login = getLoginData();

    // 관리자가 아니면 공지사항 목록으로 이동
    if (!login || Number(login.auth) !== 1) {
      alert("관리자만 접근할 수 있습니다.");
      this.$router.push({ name: "notice" });
      return;
    }

    // 로그인한 관리자의 아이디를 작성자로 설정
    this.writerId = login.id;
  },

  methods: {
    // 입력값을 확인한 뒤 새 공지사항 등록
    writeNotice() {
      if (!this.isAdmin) {
        return alert("관리자만 공지사항을 등록할 수 있습니다.");
      }

      if (!this.title.trim()) {
        return alert("제목을 입력해주세요.");
      }

      if (!this.content.trim()) {
        return alert("내용을 입력해주세요.");
      }

      // 백엔드로 전송할 공지사항 데이터
      const param = {
        writerId: this.writerId,
        title: this.title,
        content: this.content,
        ispinned: this.ispinned
      };

      axios
        .post("http://localhost:8282/addnotice", param, {
          withCredentials: true
        })
        .then((resp) => {
          if (resp.data > 0) {
            alert("공지사항이 등록되었습니다.");
            this.$router.push({ name: "notice" });
          } else {
            alert("공지사항 등록에 실패했습니다.");
          }
        })
        .catch((error) => {
          console.error("공지사항 등록 오류:", error);
          alert("공지사항 등록 중 오류가 발생했습니다.");
        });
    },

    // 등록을 취소하고 공지사항 목록으로 이동
    cancel() {
      this.$router.push({ name: "notice" });
    }
  }
};
</script>
