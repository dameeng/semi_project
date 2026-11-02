<script setup>
import home from "@/assets/homepage-header.png"
import menuMascot from "@/assets/10.jpg"

//공통 사이드바
import Sidebar from "./components/Sidebar/Sidebar.vue";





</script>

<template>

    <header class="header">
        <img :src="home" class="Bupyeong" @click="Home">

        <article class="profile-area">
            <div id="card" class="card">

                <div class="card-body">
                    <h5 class="card-title">
                        <span v-if="isLoggedIn">{{loginName}}님</span>
                        <span v-else>프로필</span>
                    </h5>
                    <button @click="Owner" v-if="isOwner">점주</button>
                    <button @click="Admin" v-if="isAdmin">관리자</button>
                    <button @click="Login" v-if="!isLoggedIn">로그인</button>
                    <button @click="Signup" v-if="!isLoggedIn">회원가입</button>
                    <button @click="Logout" v-if="isLoggedIn">로그아웃</button>
                </div>
            </div>
        </article>

        <button
          v-if="$route.name !== 'admin'"
          type="button"
          class="hamburger-button"
          :class="{ active: mobileMenuOpen }"
          :aria-expanded="mobileMenuOpen"
          :aria-label="mobileMenuOpen ? '메뉴 닫기' : '메뉴 열기'"
          @click="toggleMobileMenu">
          <img v-if="mobileMenuOpen" :src="menuMascot" alt="메뉴 닫기" class="menu-mascot">
          <template v-else>
            <span></span>
            <span></span>
            <span></span>
          </template>
        </button>

   

    <!--admin페이지에서는 네비바가 숨겨진다-->
    <nav v-if="$route.name !== 'admin'" class="header-nav" :class="{ 'mobile-open': mobileMenuOpen }">

        <!-- menu-->
        <!--어디론가 이동했을때 네비가 다시 올라가고 다시 네비쪽으로 커서가져다 대면 내려오는 기능-->
        <ul class="maincategory" :class="{'menu-closed':menuClosed}" 
          @click.capture="menuClosed = true" @mouseenter="menuClosed = false">   <!--네비바 커서를 다시올리면 메뉴열기-->


            <!-- 정기권신청 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'pass' }">
                <span @click="handleCategoryClick('pass')">정기권신청</span>

                <ul class="menu">
                    <li @click="PassNow">정기권 발매 현황</li>
                    <li @click="Pass">정기권 신청</li>
                    <li @click="PassInfo">정기권 이용안내</li>
                </ul>
            </li>

            <!-- 주차현황 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'park' }">
                <span @click="handleCategoryClick('park')">주차</span>

                <ul class="menu">
                    <li @click="Park">주차 현황</li>
                    <li @click="ParkInt">주차장 소개</li>
                    <li @click="ParkInfo">주차 요금 안내</li>
                </ul>
            </li>

            <!-- 상가 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'stores' }">
                <span @click="handleCategoryClick('stores')">상가</span>

                <ul class="menu">
                    <li @click="Stores">상가 정보</li>
                </ul>
            </li>

            <!-- 알림 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'support' }">
                <span @click="handleCategoryClick('support')">공지 / 문의</span>

                <ul class="menu">
                    <li @click="Notice">공지사항</li>
                    <li @click="Qna">1:1 질의응답 등록</li>
                    <li @click="Faq">자주묻는질문</li>
                </ul>
            </li>

            <!-- 자유게시판 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'board' }">
                <span @click="handleCategoryClick('board')">자유게시판</span>

                <ul class="menu">
                    <li @click="BbsList">3조의 수다방</li>
                </ul>
            </li>

            <!-- 마이페이지 -->
            <li class="subcategory" :class="{ 'mobile-expanded': openMobileCategory === 'mypage' }">
                <span @click="handleCategoryClick('mypage')">마이페이지</span>

                <ul class="menu">
                    <li @click="My">내 정보</li>
                    <li @click="MyCar">내 주차 현황/정산</li>
                    <li @click="MyPass">마이 정기권</li>
                    <li @click="MyFaq">나의 질의응답 조회</li>

                </ul>
               
            </li>
            
        </ul>
    </nav>
 </header>

   <main
  class="page-layout"
  :class="{
    'has-sidebar': showSidebar && sidebarInfo,
    'is-home': $route.name === 'home'
  }"
>
  <Sidebar
    v-if="showSidebar && sidebarInfo"
    :title="sidebarInfo.title"
    :menus="sidebarInfo.menus"
  />

  <router-view v-if="$route.name === 'home'" />
  <section v-else class="route-content" :class="`route-${$route.name || 'page'}`">
    <div v-if="pagePresentation" class="route-hero">
      <div class="route-hero-copy">
        <span class="route-kicker">{{ pagePresentation.kicker }}</span>
        <h1>{{ pagePresentation.title }}</h1>
        <p>{{ pagePresentation.description }}</p>
        <div class="route-tags"><span v-for="tag in pagePresentation.tags" :key="tag">{{ tag }}</span></div>
      </div>
      <div class="route-icon" :class="{ 'has-mascot': pagePresentation.image }" aria-hidden="true">
        <img v-if="pagePresentation.image" :src="pagePresentation.image" alt="">
        <span v-else>{{ pagePresentation.icon }}</span>
      </div>
    </div>
    <div class="route-panel"><router-view @store-floor-change="selectedStoreFloor = $event" /></div>
  </section>
</main>

   <!-- 홈 화면에서는 펼쳐지는 안내 패널을 사용하므로 공통 푸터를 숨긴다. -->
   <footer v-if="$route.name !== 'home'" class="footer">
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
import sidebarConfig from "./components/Sidebar/Sidebar/SidebarConfig.js";
import adminMascot from "./assets/admin-mascot.png";
import storesMascot from "./assets/mascot-stores.png";
import parkingMascot from "./assets/mascot-parking.png";
import passMascot from "./assets/mascot-pass.png";
import communityMascot from "./assets/mascot-community.png";
import supportMascot from "./assets/mascot-support.png";
import memberMascot from "./assets/mascot-member.png";
import mypageMascot from "./assets/mascot-mypage.png";
import ownerMascot from "./assets/mascot-owner.png";
import storeFloor1 from "./assets/1층.png";
import storeFloor2 from "./assets/2층.png";
import storeFloor3 from "./assets/3층.png";
import storeFloor4 from "./assets/4층.png";
import storeFloor5 from "./assets/5층.png";
import storeFloor6 from "./assets/6층.png";
import storeFloor7 from "./assets/7층.png";

export default {
    data() {
        return {
            //로그인여부
            isLoggedIn: false,

            //로그인한 이름
            loginName:"",
            menuClosed:false,
            mobileMenuOpen:false,
            openMobileCategory:null,

            //관리자(auth 1) 여부
            isAdmin:false,

            //점주
            isOwner:false
            ,selectedStoreFloor:1
           
        }
    },
   computed: {

    pagePresentation() {
      const name = this.$route.name;
      if (!name || name === 'home' || name === 'login') return null;
      const groups = [
        { names:['stores'], kicker:'BUPYEONG SHOPPING', title:'상가 안내', description:'부평역사 내 입점 상가를 층별로 확인하실 수 있습니다.', image:({1:storeFloor1,2:storeFloor2,3:storeFloor3,4:storeFloor4,5:storeFloor5,6:storeFloor6,7:storeFloor7}[this.selectedStoreFloor] || storesMascot), tags:['층별 안내','매장 정보','연락처 확인'] },
        { names:['park','parkinfo','parkcost','mycar'], kicker:'SMART PARKING', title:'주차 서비스', description:'주차 현황부터 요금과 이용 정보까지 한눈에 확인하세요.', image:parkingMascot, tags:['실시간 현황','주차 안내','간편 조회'] },
        { names:['pass','passapply','passinfo','passnow','mypass'], kicker:'MONTHLY PASS', title:'정기권 서비스', description:'정기권 신청과 이용 현황을 쉽고 편리하게 관리하세요.', image:passMascot, tags:['신청 안내','발매 현황','이용 관리'] },
        { names:['boardlist','boardwrite','boarddetail'], kicker:'BUPYEONG COMMUNITY', title:'자유게시판', description:'부평역사쇼핑몰의 다양한 이야기를 함께 나눠보세요.', image:communityMascot, tags:['자유로운 소통','공지 확인','댓글 참여'] },
        { names:['notice','noticedetail','noticewrite','noticeupdate','faq','faqdetail','faqwrite','faqupdate','qna','qnawrite','qnadetail','qnaupdate','myfaqlist'], kicker:'CUSTOMER SUPPORT', title:'고객지원', description:'공지사항과 자주 묻는 질문, 1:1 문의를 이용하실 수 있습니다.', image:supportMascot, tags:['공지사항','FAQ','1:1 문의'] },
        { names:['login','signup','findlogin'], kicker:'WELCOME TO BUPYEONG', title:'회원 서비스', description:'로그인하고 더 편리한 부평역사쇼핑몰 서비스를 만나보세요.', image:memberMascot, tags:['간편 로그인','회원가입','계정 찾기'] },
        { names:['my','myupdate'], kicker:'MY BUPYEONG', title:'마이페이지', description:'내 정보와 이용 내역을 안전하고 편리하게 관리하세요.', image:mypageMascot, tags:['회원 정보','차량 관리','이용 내역'] },
        { names:['admin'], kicker:'ADMIN CONSOLE', title:'관리자 센터', description:'쇼핑몰 운영 현황과 회원·서비스 정보를 관리합니다.', image:adminMascot, tags:['통합 관리','승인 업무','운영 현황'] },
        { names:['owner'], kicker:'STORE PARTNER', title:'점주 센터', description:'매장과 정기권 관련 업무를 한곳에서 관리하세요.', image:ownerMascot, tags:['매장 관리','점주 서비스','운영 지원'] }
      ];
      return groups.find(group => group.names.includes(name)) || null;
    },

    // 현재 페이지에 맞는 사이드바 정보 찾기
    sidebarInfo() {
        return sidebarConfig.find(config =>
            config.routeNames.includes(this.$route.name)
        );
    },

    // 사이드바 표시 여부
    showSidebar() {
        const excludedRoutes = [
            'home',
            'admin',
            'owner',
            'login'
        ];

        return !excludedRoutes.includes(this.$route.name);
    }

},
    
    mounted() {
    this.checkLogin();
  },

  watch: {
    // 로그인 후 다른 화면으로 이동하면 로그인 상태 재확인 / watch : 특정 값의 변화 감시
    $route() {
      this.checkLogin();
      

      //페이지가 이동하면 네비게이션 메뉴닫기
      this.menuClosed = true;
      this.mobileMenuOpen = false;
      this.openMobileCategory = null;
    }
  },
    methods: {
         toggleMobileMenu() {
           this.mobileMenuOpen = !this.mobileMenuOpen;
           if (!this.mobileMenuOpen) this.openMobileCategory = null;
         },

         handleCategoryClick(category) {
           if (window.innerWidth <= 1100) {
             this.openMobileCategory = this.openMobileCategory === category ? null : category;
             return;
           }

           const categoryMethods = {
             pass: "Pass",
             park: "Park",
             stores: "Stores",
             support: "Faq",
             board: "BbsList",
             mypage: "My"
           };
           this[categoryMethods[category]]();
         },

         checkLogin() {
      const loginData = sessionStorage.getItem("login");

      //로그인 정보가 없는 경우
      if(!loginData || loginData ===null
      ){
        this.isLoggedIn = false;
        this.loginName =  "";

        //로그인 정보가 없으면 관리자 상태 해제
        this.isAdmin= false;
        
        //로그인 정보가 없으면 점주 상태 해제
        this.isOwner=false;
        return;
      }
      try{
        //이름이 없으면 아이디 표시
        const login = JSON.parse(loginData);
        
        
        this.isLoggedIn = true;
        //현재 로그인한 아이디로 갱신
        this.loginName =login.id || "";

        //auth가 1이면 관리자 메뉴 표시
        this.isAdmin = Number(login.auth) ===1;

        this.isOwner = Number(login.auth) === 2;

      }catch(error){
        console.error('로그인 정보 확인오류', error);

        


        this.isLoggedIn = false;
        this.loginName = "";
        this.isAdmin = false;
        this.isOwner = false;
      }
    },
    

        //메인홈페이지
        Home() {
            this.$router.push({ name: 'home' });
        },

        //로그인
        Login() {
            this.$router.push({ name: 'login' });
        },

        //회원가입
        Signup() {
            this.$router.push({ name: 'signup' });
        },

        //로그아웃
        Logout() {
           const loginData = sessionStorage.getItem("login");

           //로그인하지 않는경우
           if(!loginData || loginData === "null"){
            alert("로그인 상태가 아닙니다");
            return;
           }
           if(!confirm("로그아웃하시겠습니까?")){
            return;
           }
           
           //로그인 정보 제거
           sessionStorage.removeItem("login");
           sessionStorage.removeItem("location");

           //버튼 상태 변경
           this.isLoggedIn = false;
           this.isAdmin = false;
           this.isOwner = false;
           this.loginName = "";

           alert("로그아웃되었습니다");

           //홈페이지 이동
           this.$router.push({
            name:"home"
           });
        },

        //==============================정기권신청================================

        //정기권 발매 현황
        PassNow() {
            this.$router.push({ name: 'passnow' });
        },
        //정기권신청
        Pass() {
            this.$router.push({ name: 'pass' });
        },
        //정기권 이용안내
        PassInfo() {
            this.$router.push({ name: 'passinfo' });
        },

        //==============================주차현황================================

        //주차현황
        Park() {
            this.$router.push({ name: 'park' });
        },
         ParkInt() {
            this.$router.push({ name: 'parkinfo' });
        },
         ParkInfo() {
            this.$router.push({ name: 'parkcost' });
        },
        //==============================상가================================
   
        Stores() {
            this.$router.push({ name: 'stores' });
        },
        //==============================알림================================

        //공지 
        Notice() {
            this.$router.push({ name: 'notice' });
        },
        Faq() {
            this.$router.push({ name: 'faq' });
        },
        Qna(){
            this.$router.push({name: 'qna'});
        },



        //==============================자유게시판================================
        //자유게시판
        BbsList() {
            this.$router.push({ name: 'boardlist' });
        },


        //==============================마이페이지================================

        // 정보 조회
        My() {
            this.$router.push({ name: 'my' });
        },

        // 주차 현황
        MyCar() {
            this.$router.push({ name: 'mycar' });
        },

         // 주차 현황/정산
        MyCar() {
            this.$router.push({ name: 'mycar' });
        },


        //나의 신청 정보
        MyPass() {
            this.$router.push({ name: 'mypass' });
        },
        //내 질의응답 
        MyFaq() {
            this.$router.push({ name: 'myfaqlist' });
        },
        //관리자 페이지로 이동
        Admin(){
            this.$router.push({name:"admin"})
        },
        Owner(){
            this.$router.push({name:'owner'})
        }


    },
}
</script>


<style scoped src="@/components/Css/App.styles.css"></style>
<!-- 전체 화면의 공통 메뉴와 페이지 레이아웃을 관리합니다. -->
