<template>
    <table>
        <thead>
            <tr>
               <th colspan="2">내 정보</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>회원구분</th>
                <td>{{ authText }}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>{{ name }}</td>
            </tr>
            <tr>
                <th>아이디</th>
                <td>{{ id }}</td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <!-- 글자 수만큼 * 로 마스킹되어 출력됩니다 -->
                <td>{{ maskedPw }}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>{{ email }}</td>
            </tr>
            <tr>
                <th>차량번호</th>
                <td>{{ carNum }}</td>
            </tr>
             <tr>
                <th>특수차량</th>
                <td>{{ carTypesText }}</td>
            </tr>
            <tr>
               <td colspan="2">
                    <button type="button" @click="myupdate">내 정보 수정</button>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<script>
//axios 선언 백엔드 연결. 설치 완료 확인
import axios from 'axios';

export default {
   data() {
    return {
        auth: '',
        id: '',
        pw: '',
        name: '',
        email: '',
        carNum: '',
        carTypes: '',
    };
},

computed: {
    authText() {
        const authMap = { 1: '관리자', 2: '상인', 3: '일반 회원' };
        return authMap[this.auth] || '알 수 없음';
    },
carTypesText() {
    if (!this.carTypes) return '해당 없음';
    const filtered = this.carTypes
        .split(',')
        .map(t => t.trim())
        .filter(t => t !== '일반' && t !== '');
    return filtered.length > 0 ? filtered.join(', ') : '해당 없음';
},
    // DB에서 받아온 pw의 length 만큼 '*' 생성
    maskedPw() {
        return this.pw ? '*'.repeat(this.pw.length) : '';
    }
},

mounted() {
    //로그인 정보 없을 경우 경고창 실행 
    let login = JSON.parse(sessionStorage.getItem('login'));

    if (!login) {
        alert('로그인이 필요합니다');
        this.$router.push({ name: 'login' });
        return;
    }

    axios.post("http://localhost:8282/mypage/info", { id: login.id })
        .then(resp => {
            let mem = resp.data;
            this.auth = mem.auth;
            this.id = mem.id;
            this.pw = mem.pw;
            this.name = mem.name;
            this.email = mem.email;
            this.carNum = mem.carNum;
            this.carTypes = mem.carTypes;  
        })
        .catch(err => {
            alert(err);
        });
},

    methods: {
         myupdate() {
            this.$router.push({ name: 'myupdate' });
        }
    },
};
</script>

<style scoped src="@/components/Css/My.styles.css"></style>