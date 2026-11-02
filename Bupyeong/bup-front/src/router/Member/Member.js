// src/router/member/member.js

import home from "../../components/Home.vue";
import login from "../../components/Member/Login.vue";
import signup from "../../components/Member/SignUp.vue";
import my from "../../components/My/My.vue";
import findlogin from "../../components/Member/FindLogin.vue";
import myupdate from "../../components/My/MyUpdate.vue";
import mycar from "../../components/My/MyCar.vue";
import myfaqlist from "../../components/My/MyQna/MyFaqList.vue";
import mypass from "../../components/My/MyPass.vue";


//마이페이지, 로그인, 로그아웃, 홈페이지

export default [
    { //홈페이지
        path: '/',
        name: 'home',
        component: home
    },
    { //로그인 페이지
        path: '/login',
        name: 'login',
        component: login
    },
    { //회원가입페이지
        path: '/signup',
        name: 'signup',
        component: signup
    },
    { //내정보보기
        path: '/my',
        name: 'my',
        component: my
    },
    { //아이디 찾기
        path: '/findlogin',
        name: 'findlogin',
        component: findlogin
    },
    { //내 정보 수정
        path: '/myupdate',
        name: 'myupdate',
        component: myupdate
    },
    { //내 차량 위치
        path: '/mycar',
        name: 'mycar',
        component: mycar
    },
    
    { //내 정기권 조회
        path: '/mypass',
        name: 'mypass',
        component: mypass
    },
    { //내 질의응답 조회 리스트 목록
        path: '/myfaqlist',
        name: 'myfaqlist',
        component: myfaqlist
    }
    


]