<template>
  <div class="find-login-container">
    <h1>아이디 찾기</h1>

    <table>
      <tbody>
        <tr>
          <th>이름</th>
          <td>
            <input type="text" v-model="name" size="25" placeholder="사용중이신 이름을 입력해 주세요"/>
          </td>
        </tr>
        <tr>
          <th>이메일</th>
          <td>
            <input type="email" v-model="email" size="25" placeholder="사용중이신 이메일을 입력해 주세요"/>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="button-container">
            <button @click="findId">아이디 찾기</button>&nbsp;
            
            <button @click="login">뒤로가기</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- 결과 표시 영역 -->
    <div v-if="foundId" class="result-box success">
      고객님의 아이디는 <strong>{{ foundId }}</strong> 입니다.
    </div>
    <div v-if="errorMessage" class="result-box error">
      {{ errorMessage }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'FindLogin',
  data() {
    return {
      name: '',
      email: '',
      foundId: '',
      errorMessage: ''
    };
  },
  methods: {
    findId() {
      this.foundId = '';
      this.errorMessage = '';

      if (!this.name.trim()) {
        alert('이름을 입력해주세요.');
        return;
      }
      if (!this.email.trim()) {
        alert('이메일을 입력해주세요.');
        return;
      }
    
      // 백엔드 API 호출 (이후 백엔드 구현 완료 시 동작)
      axios.post('http://localhost:8282/findid', {
        name: this.name,
        email: this.email
      })
      .then((res) => {
        if (res.data && res.data.id) {
          this.foundId = res.data.id;
        } else {
          this.errorMessage = '일치하는 회원 정보를 찾을 수 없습니다.';
        }
      })
      .catch((err) => {
        console.error('아이디 찾기 에러:', err);
        this.errorMessage = '아이디 찾기 중 오류가 발생했습니다.';
      });
    }, login(){
        alert('로그인 창으로 이동합니다');
        this.$router.push({name:'login'});
      }

  }
}
</script>

<style scoped src="@/components/Css/FindLogin.styles.css"></style>