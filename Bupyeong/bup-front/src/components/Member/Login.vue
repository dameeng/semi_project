<template>


  <div class="login-wrap">
    <table>
      
        <thead>
            <tr>
                <th colspan="2">Login</th>
            </tr>
        </thead>

        <tbody>
         
            
            <tr>
                <th>아이디</th>
                <td class="input-cell">
                    <div class="inputtext">
                     <input type="text" placeholder="아이디" v-model="user_id" class="input-row">
                         <label >   
                                <!--@change : 체크상태가 변경했을때!-->
                              <input type="checkbox" v-model="sid" @change="saveid">
                                  <span> id 저장</span>
                             </label>
                    </div>
                </td>  
            </tr>

            <tr>
                <th>비밀번호</th>
                <td class="input-cell">
                    <input type="password" placeholder="비밀번호" v-model="password" class="input-row" @keyup.enter="login">
                </td>
            </tr>
            <tr>
                <td colspan="2" class="button-container">
                    <button @click="login">로그인</button>&nbsp;
                    <button @click="signup">회원가입</button>&nbsp;
                    <button @click="Findlogin">내 id 찾기</button>
                </td>
            </tr>
        </tbody>

    </table>
    </div>
</template>

<script>
//쿠키 사용가능
import { useCookies } from "vue3-cookies";
const { cookies } = useCookies();

//백엔드 연결
import axios from "axios";


//변수저장, 함수 돌리기
export default {

    data() {

       
        return {     
            user_id: '',
            password: '',
            sid:false
        };
    },

    mounted() {
        //쿠키로 이전에 입력 받은 id 변수 저장
        let userid = cookies.get("userid");

        //조건 1 
        if (userid !== null) {
            this.sid = true;
            this.user_id = userid;
        }
        //조건2
        else {
            this.sid = false;
            this.user_id = "";
        }
    },

    methods: {
        //아이디 찾기 이동 
          Findlogin(){
            alert('아이디 찾기 페이지로 이동합니다.');
            this.$router.push({ name:'findlogin'});
        },
        //회원가입 이동 
        signup() {
            alert('회원가입 페이지로 이동합니다.');
            this.$router.push({ name: 'signup' }); // 또는 해당 라우트 이름
        },

        //아이디 체크박스 저장
        saveid() {
            //조건 1 : 체크박스 체크 됨, 공백 제거 시에도 빈문자열이 아닐때 
            if (this.sid && this.user_id.trim() !== "") {
                cookies.set("userid", this.user_id);
                 alert("ID 저장이 완료 되었습니다.");
            }

            //조건 1 해당안 될 때 
            else {
                cookies.remove("userid");
            }
        },

        //로그인 기능 실행
      
        login() {

            //param에 id,pw 세팅 
            let param = {
                params: {
                    id: this.user_id,
                    pw: this.password,
                   
                },
            };

            // 로그인 로직 구현 : 공백 방지

           
            const hasId = this.user_id.trim() !== '';
            const hasPassword = this.password.trim() !== '';

            //아이디 비밀번호 미입력시 뜨는 경고창 구현 해당 안 될경우 axios로 넘어감 
            if (!hasId && !hasPassword ) {
                alert(" 아이디, 비밀번호를 입력해주세요.");
                return;
            }
            else if (hasId && !hasPassword ) {
                alert("비밀번호를 입력해주세요.");
                return;
            }
            else if (!hasId && hasPassword) {
                alert("아이디를 입력해주세요.");
                return;
            }
           

            //백엔드 서버 연결
            axios
                .post("http://localhost:8282/login", null, param)

                .then((resp) => {
                    //alert(resp.data);
                   // alert(JSON.stringify(resp.data));

                    //변수 mem 에 데이터 베이스에서 넘어온 정보 담는 작업
                    let mem = resp.data;

                    //조건1 -> 로그인 실패
                    if (!mem || !mem.id) {
                        alert('입력하신 정보를 확인해 주십시오');
                        //비밀번호 초기화
                        this.password="";
                        return; //로그인 실패로 종결
                    }

                    //조건 2 -> 로그인 성공시

                    //세션스토리지에 login 이름표 달아서 데이터 베이스에서 넘어온 로그인 정보를 담아둠
                    sessionStorage.setItem('login', JSON.stringify(resp.data));

                    //관리자 로그인시   
                    //  그냥 auth일 경우 일반 문자열이여서 true로 넘어가 일반 회원도 관리자 페이지로넘어감
                    if(Number(mem.auth) === 1){
                        this.$router.push({name:'admin'});
                    }
                    else{
                       this.$router.push({ name: 'home' });
                    }
                })
            
                .catch((err) => {
                    alert(err);
                })


        },
    },
}
</script>


<style scoped src="@/components/Css/Login.styles.css"></style>