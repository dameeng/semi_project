<script setup>
import {Swiper, SwiperSlide} from 'swiper/vue'
import  {Autoplay, Navigation, Pagination} from 'swiper/modules'
import { computed, ref, onMounted, onUnmounted } from 'vue'

import 'swiper/css'
//import 'swiper/css/navigation'
import 'swiper/css/pagination'
// 카카오맵 추가
import KakaoMapModal from './KakaoMap/KakaoMapModal.vue'

// 메인 슬라이드 이미지
import swipe1 from '@/assets/main1.jpg';
import swipe2 from '@/assets/main2.jpg';
import swipe3 from '@/assets/main3.jpg';
import swipe4 from '@/assets/main4.jpg';

import faq from '@/assets/faq.png';
import coming from '@/assets/coming.png';
import parking from '@/assets/parking.png';
import homeGuideVideo from '@/assets/videos/home-guide.mp4';

// 슬라이드에 표시할 순서
const swipes = [swipe1, swipe2, swipe3, swipe4]

// 슬라이드 기능 설정
const modules = [Autoplay, Navigation, Pagination]

// 카카오맵 모달 표시 여부
const showMap = ref(false)

// 현재 스크롤 위치(0~100)
const scroll = ref(0)
const scrollContent = ref(null)

// 스크롤 위치에 맞춰 표시 막대를 이동
const scrollBar = computed(() => ({
  height: `${50 + scroll.value}px`,
}))

function handleWheel(event){
  event.preventDefault()

  const maxscroll = Math.max(0, window.innerHeight - 220)
  const panel = scrollContent.value

  if (scroll.value >= maxscroll && event.deltaY > 0) {
    if (panel) panel.scrollTop += event.deltaY
    return
  }

  if (panel && panel.scrollTop > 0 && event.deltaY < 0) {
    panel.scrollTop += event.deltaY
    return
  }

  scroll.value = Math.max(0, Math.min(maxscroll, scroll.value + event.deltaY * 0.2))
}

onMounted(() => {
  window.addEventListener('wheel', handleWheel, { passive: false })
})

onUnmounted(() => {
  window.removeEventListener('wheel', handleWheel)
})
</script>

<template>
  <div class="handleWheel">
    <!-- App.vue에 이미 main이 있으므로 내부 콘텐츠는 section으로 구성한다. -->
    <section class="main">
      <Swiper
        :modules="modules"
        effect="slide"
        direction="horizontal"
        :slides-per-view="1"
        :loop="true"
        :speed="1000"
        :autoplay="{
          delay: 3000,
          disableOnInteraction: false
        }"
        :pagination="{ clickable: true }"
        class="main-swiper1">
        <SwiperSlide
          v-for="image in swipes"
          :key="image">
          <!-- 이미지 한장에만 css 입히기 위해-->
          <img :src="image" alt="부평" :class="{'main1-image': image === swipe1}"/>
        </SwiperSlide>
      </Swiper>
    </section>

    <footer class="scrollBar" :style="scrollBar" ref="scrollContent">
      <p class="scroll-label">
        scroll <br>
        down
      </p>

      <hr>

      <p class="use">이용안내</p>

      <div class="icon-png">
        <div class="icon-item">
          <img :src="faq" alt="FAQ" @click="goFaq">
          <span>FAQ</span>
        </div>

        <div class="icon-item">
         <img :src="parking" alt="주차시설" @click="goParkInfo">
          <span>주차시설</span>
        </div>

        <div class="icon-item">
          <img :src="coming" alt="오시는길" @click="showMap = true">
          <span>오시는길</span>
        </div>
      </div>

      <hr class="building-intro-divider">
      <p class="building-intro-title">건물 소개</p>

      <div class="home-video-section">
        <video class="home-guide-video" autoplay muted loop playsinline preload="auto">
          <source :src="homeGuideVideo" type="video/mp4">
          영상을 재생할 수 없는 브라우저입니다.
        </video>
      </div>

      <div class="box-all1 footer-info-box">
        <p class="box-text"> 영업시간 | 연중무휴 24시 운영</p>
        <p class="box-text">인천광역시 부평구 광장로 16 | 고객센터: 032-000-0000 | 이메일: info@bupyeong.com</p>
        <p class="box-text">Copyright © Bupyeong Shopping Mall. All Rights Reserved</p>
      </div>

      <div class="bottom">
        <p class="customer">(주)부평역쇼핑몰 주차관리시스템</p>
      </div>
    </footer>
  </div>

  <!-- 카카오맵 모달 -->
  <KakaoMapModal v-if="showMap" @close="showMap = false" />

</template>


<script>
export default{
methods: {
 goFaq(){
  this.$router.push({name:'faq'});
 },
 goParkInfo(){
  this.$router.push({name:'parkinfo'});
 } 
}
}
</script>


<style scoped src="@/components/Css/Home.styles.css"></style>
<!-- 메인 배너와 주요 서비스를 보여주는 홈 화면입니다. -->
