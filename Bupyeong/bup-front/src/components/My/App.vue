<script setup>
import home from "@/assets/homepage.png"
</script>

<template>
    <!-- 헤더 영역 -->
    <header class="header">
        <img :src="home" class="Bupyeong" @click="Home">

        <article>
            <div id="card" class="card">
                <div class="card-body">
                    <h5 class="card-title">
                        <span v-if="isLoggedIn">{{loginName}}님</span>
                        <span v-else>프로필</span>
                    </h5>

                    <button @click="Login" v-if="!isLoggedIn">로그인</button>
                    <button @click="Signup" v-if="!isLoggedIn">회원가입</button>
                    <button @click="Logout" v-if="isLoggedIn">로그아웃</button>
                </div>
            </div>
        </article>
    </header>

    <!-- 네비게이션 영역 -->
    <nav>
        <ul class="maincategory">
            <!-- 정기권신청 -->
            <li class="subcategory">
                <span @click="Notice">정기권신청</span>
                <ul class="menu">
                    <li @click="PassNow">정기권 발매 현황</li>
                    <li @click="Pass">정기권 신청</li>
                    <li @click="PassInfo">정기권 이용안내</li>
                </ul>
            </li>

            <!-- 주차현황 -->
            <li class="subcategory">
                <span @click="Park">주차현황</span>
                <ul class="menu">
                    <li @click="Park">주차 현황</li>
                    <li @click="ParkInt">주차장 소개</li>
                    <li @click="ParkSystem">입출차 시스템</li>
                    <li @click="ParkInfo">주차 요금 안내</li>
                </ul>
            </li>

            <!-- 상가 -->
            <li class="subcategory">
                <span @click="StoresDc">상가</span>
                <ul class="menu">
                    <li @click="StoresDc">상가 할인율</li>
                    <li @click="Stores">상가 정보</li>
                </ul>
            </li>

            <!-- 알림 -->
            <li class="subcategory">
                <span @click="Faq">알림</span>
                <ul class="menu">
                    <li @click="Faq">자주 묻는 질문</li>
                    <li @click="Qna">1:1 질의응답 등록</li>
                    <li @click="Notice">공지사항</li>
                </ul>
            </li>

            <!-- 자유게시판 -->
            <li class="subcategory">
                <span @click="BbsList">자유게시판</span>
                <ul class="menu">
                    <li @click="BbsList">자유게시판</li>
                </ul>
            </li>

            <!-- 마이페이지 -->
            <li class="subcategory">
                <span @click="My">마이페이지</span>
                <ul class="menu">
                    <li @click="My">내 정보</li>
                    <li @click="MyCar">내 주차 위치/정산</li>
                    <li @click="MyPass">마이 정기권</li>
                    <li @click="MyFaq">나의 질의응답 조회</li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- 메인 영역 -->
    <main>
        <router-view />
    </main>

    <!-- 푸터 영역 -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-info">
                <p class="company-name">(주)부평역쇼핑몰 주차관리시스템</p>
                <p>주소: 인천광역시 부평구 광장로 16 | 고객센터: 032-000-0000 | 이메일: info@bupyeong.com</p>
                <p class="copyright">Copyright © Bupyeong Shopping Mall. All Rights Reserved.</p>
            </div>
        </div>
    </footer>
</template>

<script>
export default {
    data() {
        return {
            //로그인여부
            isLoggedIn: false,
            //로그인한 이름
            loginName:""
        }
    },
    mounted() {
        this.checkLogin();
    },
    watch: {
        $route() {
            this.checkLogin();
        }
    },
    methods: {
        checkLogin() {
            const loginData = sessionStorage.getItem("login");

            if(!loginData || loginData === null){
                this.isLoggedIn = false;
                this.loginName = "";
                return;
            }
            try{
                const login = JSON.parse(loginData);
                this.isLoggedIn = true;
                this.loginName = this.loginName || login.id || "";
            }catch(error){
                console.error("로그인 정보 확인 오류:", error);
                this.isLoggedIn = false;
                this.loginName = "";
            }
        },

        // 메인홈페이지
        Home() {
            this.$router.push({ name: 'home' });
        },
        // 로그인
        Login() {
            this.$router.push({ name: 'login' });
        },
        // 회원가입
        Signup() {
            this.$router.push({ name: 'signup' });
        },
        // 로그아웃
        Logout() {
            const loginData = sessionStorage.getItem("login");

            if(!loginData || loginData === "null"){
                alert("로그인 상태가 아닙니다");
                return;
            }
            if(!confirm("로그아웃하시겠습니까?")){
                return;
            }
           
            sessionStorage.removeItem("login");
            sessionStorage.removeItem("location");
            this.isLoggedIn = false;

            alert("로그아웃되었습니다");
            this.$router.push({ name: "home" });
        },

        // 정기권
        PassNow() { this.$router.push({ name: 'passnow' }); },
        Pass() { this.$router.push({ name: 'pass' }); },
        PassInfo() { this.$router.push({ name: 'passinfo' }); },

        // 주차현황
        Park() { this.$router.push({ name: 'park' }); },
        ParkInt() { this.$router.push({ name: 'parkint' }); },
        ParkSystem() { this.$router.push({ name: 'parksystem' }); },
        ParkInfo() { this.$router.push({ name: 'parkinfo' }); },

        // 상가
        StoresDc() { this.$router.push({ name: 'storesdc' }); },
        Stores() { this.$router.push({ name: 'stores' }); },

        // 알림
        Notice() { this.$router.push({ name: 'notice' }); },
        Qna() { this.$router.push({ name: 'qna' }); },
        Faq() { this.$router.push({ name: 'faq' }); },

        // 자유게시판
        BbsList() { this.$router.push({ name: 'boardlist' }); },

        // 마이페이지
        My() { this.$router.push({ name: 'my' }); },
        MyCar() { this.$router.push({ name: 'mycar' }); },
        MyPass() { this.$router.push({ name: 'mypass' }); },
        MyFaq() { this.$router.push({ name: 'myfaqlist' }); }
    }
}
</script>

<style scoped src="@/components/Css/App.styles.css"></style>