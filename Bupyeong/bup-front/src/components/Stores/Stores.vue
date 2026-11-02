v<template>
  <div>
    <!-- 헤더 타이틀 -->
    <div class="header-title">
      <h2>상가 안내</h2>
      <p>부평역사 내 입점 상가를 층별로 확인하실 수 있습니다.</p>
    </div>

    <!-- 3단 레이아웃 -->
    <div class="app-layout">
      
      <!-- [좌측] 층별 안내 -->
      <div class="panel left-sidebar">
        <h3>층별 안내</h3>
        <div class="elevator-panel" aria-hidden="true">
          <div class="floor-display">
            <span class="display-arrow">▲</span>
            <span class="display-num">{{ activeFloor }}</span>
          </div>
          <div class="elevator-doors" :class="{ open: doorsOpen }">
            <span class="door-half door-half-l"></span>
            <span class="door-half door-half-r"></span>
            <img :src="mascotImage" alt="" class="mascot-peek" :class="{ show: mascotVisible }" />
          </div>
        </div>
        <ul>
          <li v-for="floor in floors" :key="floor" @click="selectFloor(floor)" class="stair" :class="{ active: activeFloor === floor }">
            {{ floor }}층
          </li>
        </ul>
      </div>

      <!-- [중앙] 매장 목록 -->
      <div class="panel middle-content">
        <div class="panel-header">
          <h3>{{ activeFloor }}층 매장 목록</h3>
          <button v-if="isAdmin" @click="startCreate">+ 매장 등록</button>
        </div>
        
        <ul>
          <li v-for="store in currentStores" :key="store.storeNum" @click="selectStore(store)">
            <div class="store-list-main">
              <img
                v-if="getStoreImage(store.storeNum)"
                class="store-list-thumb"
                :src="getStoreImage(store.storeNum)"
                :alt="`${store.storeName} 매장 사진`"
              />
              <strong>{{ store.storeName }}</strong>
            </div>
            <span> | {{ store.contact }}</span>
          </li>
          <li v-if="currentStores.length === 0" class="empty-msg">
            등록된 매장이 없습니다.
          </li>
        </ul>
      </div>

      <!-- [우측] 상세 정보 / 등록 / 수정 전환 패널 -->
      <div class="panel right-panel">
        
        <!-- 신규 등록 폼 -->
        <div v-if="mode === 'create'">
          <h3>매장 신규 등록</h3>
          <form @submit.prevent="submitCreateStore">
            <label>매장명</label>
            <input type="text" v-model="formStore.storeName" placeholder="예: 무신사" required />

            <label>층수</label>
            <input type="number" v-model.number="formStore.floor" required />

            <label>아이디</label>
            <input type="text" v-model="formStore.id" placeholder="등록자/관리자 ID" required />

            <label>연락처</label>
            <input type="text" v-model="formStore.contact" placeholder="032-000-0000" required />

            <div class="btn-group">
              <button type="submit">등록 완료</button>
              <button type="button" @click="cancelForm">취소</button>
            </div>
          </form>
        </div>
        <!-- 수정 폼 (아이디 수정 제외) -->
        <div v-else-if="mode === 'edit'">
          <h3>매장 정보 수정</h3>
          <form @submit.prevent="submitUpdateStore">
            <label>매장명</label>
            <input type="text" v-model="formStore.storeName" required />

            <label>층수</label>
            <input type="number" v-model.number="formStore.floor" required />

            <label>아이디</label>
            <!-- 수정 불가 (텍스트 표시만 진행) -->
            <p class="read-only-id">{{ formStore.id }}</p>

            <label>연락처</label>
            <input type="text" v-model="formStore.contact" required />

            <div class="btn-group">
              <button type="submit">수정 완료</button>
              <button type="button" @click="cancelForm">취소</button>
            </div>
          </form>
        </div>

        <!-- 상세 정보 보기 -->
        <div v-else-if="activeStore">
          <h3>상세 정보</h3>
          <figure v-if="currentStoreImage" class="store-photo-wrap">
            <img class="store-photo" :src="currentStoreImage" :alt="`${activeStore.storeName} 매장 사진`" />
          </figure>
          <div>
            <p><strong>가게 이름:</strong> {{ activeStore.storeName }}</p>
            <p><strong>층수:</strong> {{ activeStore.floor }}층</p>
            <p v-if="isAdmin"><strong>아이디:</strong> {{ activeStore.id }}</p>
            <p><strong>전화번호:</strong> {{ activeStore.contact }}</p>
          </div>

          <div v-if="isAdmin" class="btn-group">
            <button @click="startEdit(activeStore)">수정</button>
            <button @click="deleteStore(activeStore.storeNum)">삭제</button>
          </div>
        </div>

        <!-- 아무것도 선택 안 됨 -->
        <div v-else class="empty-msg">
          <p>가게를 선택해주세요.</p>
        </div>

      </div>

    </div>
  </div>
</template>

<script>
import axios from 'axios';
import mascotImg from '@/assets/elevator-mascot-face.png';

const storeImageModules = import.meta.glob('/src/assets/stores/*.{jpg,jpeg,png,webp}', {
  eager: true,
  query: '?url',
  import: 'default'
});

const storeImages = Object.fromEntries(
  Object.entries(storeImageModules).map(([path, url]) => {
    const storeNum = path.split('/').pop().split('.')[0];
    return [storeNum, url];
  })
);

const storeVoiceFiles = {
  1: 'store_부평베이커리.mp3', 2: 'store_MBC카페.mp3', 3: 'store_맛있는식당.mp3',
  4: 'store_행복약국.mp3', 5: 'store_스타일헤어.mp3', 6: 'store_스마트안경원.mp3',
  7: 'store_부평네일숍.mp3', 8: 'store_클린세탁소.mp3', 9: 'store_모바일스토어.mp3',
  10: 'store_올바른치과.mp3', 11: 'store_피트니스클럽.mp3', 12: 'store_플라워샵.mp3',
  13: 'store_청과물마트.mp3', 14: 'store_부평서점.mp3', 15: 'store_스크린골프.mp3',
  16: 'store_국숫집.mp3', 17: 'store_아이스크림전문점.mp3', 18: 'store_만화카페.mp3',
  19: 'store_네일아트샵.mp3', 20: 'store_시계수선점.mp3', 21: 'store_부평영화관.mp3',
  22: 'store_오락실.mp3', 23: 'store_스포츠용품점.mp3', 24: 'store_지에스25.mp3',
  25: 'store_옥상정원카페.mp3', 26: 'store_반려동물샵.mp3', 27: 'store_이벤트홀.mp3',
  28: 'store_문구점.mp3'
};

export default {
  emits: ['store-floor-change'],
  data() {
    return {
      stores: [],
      activeFloor: null,
      activeStore: null,
      currentUser: null,
      guideAudio: null,
      doorsOpen: false,
      mascotVisible: false,
      mascotImage: mascotImg,
      doorTimer: null,
      mascotTimer: null,
      mode: 'detail',
      formStore: { storeNum: null, storeName: '', floor: 1, id: '', contact: '' }
    };
  },
  computed: {
    isAdmin() {
      return this.currentUser && (this.currentUser.auth === 1 || this.currentUser.auth === '1');
    },
    floors() {
      const floorSet = new Set(this.stores.map(s => s.floor));
      return Array.from(floorSet).sort((a, b) => b - a);
    },
    currentStores() {
      return this.stores.filter(s => s.floor === this.activeFloor);
    },
    currentStoreImage() {
      return this.activeStore ? storeImages[String(this.activeStore.storeNum)] : null;
    }
  },
  methods: {
    getStoreImage(storeNum) {
      return storeImages[String(storeNum)] || null;
    },
    async fetchStores() {
      try {
        const res = await axios.get('http://localhost:8282/allstores');
        this.stores = res.data;

        if (this.floors.length > 0 && (!this.activeFloor || !this.floors.includes(this.activeFloor))) {
          this.activeFloor = this.floors[0];
        }
      } catch (err) {
        console.error('목록 조회 실패:', err);
      }
    },
    selectFloor(floor) {
      this.activeFloor = floor;
      this.activeStore = null;
      this.mode = 'detail';
      this.$emit('store-floor-change', floor);
      this.playGuideAudio(`/voices/floor-${floor}.mp3`);
      this.playElevatorAnimation();
    },
    selectStore(store) {
      this.activeStore = store;
      this.mode = 'detail';
      const voiceFile = storeVoiceFiles[store.storeNum];
      if (voiceFile) this.playGuideAudio(`/voices/stores/${voiceFile}`);
    },
    playGuideAudio(src) {
      if (this.guideAudio) {
        this.guideAudio.pause();
        this.guideAudio.currentTime = 0;
      }
      this.guideAudio = new Audio(encodeURI(src));
      this.guideAudio.play().catch(err => console.warn('음성 안내 재생 실패:', err));
    },
    playElevatorAnimation() {
      clearTimeout(this.doorTimer);
      clearTimeout(this.mascotTimer);
      this.doorsOpen = false;
      this.mascotVisible = false;
      this.$nextTick(() => requestAnimationFrame(() => { this.doorsOpen = true; }));
      this.mascotTimer = setTimeout(() => { this.mascotVisible = true; }, 380);
      this.doorTimer = setTimeout(() => {
        this.doorsOpen = false;
        this.mascotVisible = false;
      }, 2800);
    },
    startCreate() {
      this.formStore = { 
        storeNum: null, 
        storeName: '', 
        floor: this.activeFloor || 1, 
        id: this.currentUser?.id || '', 
        contact: '' 
      };
      this.mode = 'create';
    },
    startEdit(store) {
      this.formStore = { ...store };
      this.mode = 'edit';
    },
    cancelForm() {
      this.mode = 'detail';
    },
    async submitCreateStore() {
      if (!this.formStore.storeName.trim()) {
        alert('매장명을 입력해주세요.');
        return;
      }
      if (!this.formStore.id.trim()) {
        alert('아이디를 입력해주세요.');
        return;
      }

      try {
        const payload = {
          storeName: this.formStore.storeName.trim(),
          floor: this.formStore.floor,
          id: this.formStore.id.trim(),
          contact: this.formStore.contact.trim()
        };

        const res = await axios.post('http://localhost:8282/addstore', payload);
        
        if (res.data === true) {
          alert('매장이 성공적으로 등록되었습니다.');
          this.mode = 'detail';
          await this.fetchStores();
        } else {
          alert('존재하지 않는 아이디이거나 입력 정보에 오류가 있습니다.');
        }
      } catch (err) {
        console.error('등록 오류:', err);
        // DB 외래키(FK) 조건에 맞지 않는 아이디거나 백엔드 에러 발생 시
        alert('존재하지 않는 회원 아이디입니다.');
      }
    },
    async submitUpdateStore() {
      try {
        // id는 변경 없이 기존 값 그대로 전송
        const payload = {
          storeNum: this.formStore.storeNum,
          storeName: this.formStore.storeName.trim(),
          floor: this.formStore.floor,
          id: this.formStore.id, 
          contact: this.formStore.contact.trim()
        };

        const res = await axios.post('http://localhost:8282/updatestore', payload);
        if (res.data === true) {
          alert('매장 정보가 수정되었습니다.');
          this.mode = 'detail';
          this.activeStore = { ...payload };
          await this.fetchStores();
        } else {
          alert('수정 정보가 올바르지 않습니다.');
        }
      } catch (err) {
        console.error('수정 오류:', err);
        alert('수정 처리 중 오류가 발생했습니다.');
      }
    },
    async deleteStore(storeNum) {
      if (!confirm('정말 삭제하시겠습니까?')) return;
      try {
        const res = await axios.post(`http://localhost:8282/deletestore?storeNum=${storeNum}`);
        if (res.data) {
          alert('삭제되었습니다.');
          this.activeStore = null;
          this.mode = 'detail';
          await this.fetchStores();
        } else {
          alert('삭제 처리에 실패했습니다.');
        }
      } catch (err) {
        console.error('삭제 오류:', err);
        alert('삭제 중 오류가 발생했습니다.');
      }
    }
  },
  mounted() {
    const saved = sessionStorage.getItem('login') || localStorage.getItem('loginUser') || localStorage.getItem('login');
    if (saved) {
      try { this.currentUser = JSON.parse(saved); } catch (e) { console.error(e); }
    }
    this.$emit('store-floor-change', this.activeFloor);
    this.fetchStores();
    this.playElevatorAnimation();
  },
  beforeUnmount() {
    clearTimeout(this.doorTimer);
    clearTimeout(this.mascotTimer);
    if (this.guideAudio) {
      this.guideAudio.pause();
      this.guideAudio = null;
    }
  }
};
</script>

<style scoped src="@/components/Css/Stores.styles.css"></style>
