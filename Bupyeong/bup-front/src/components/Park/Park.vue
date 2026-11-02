<template>
  <div id="div1">
    <div class="parking-heading">
      <h1>스마트 주차 확인 시스템</h1>
      <p class="parking-refresh-text">층별 실시간 주차 현황을 3초마다 자동으로 갱신합니다.</p>
    </div>
    <section class="parking-summary">
      <article>
        <span>🅿️</span>
        <div><small>전체 주차면</small><strong>{{ spots.length }}면</strong></div>
      </article>
      <article>
        <span>🌿</span>
        <div><small>주차 가능</small><strong>{{ spots.filter(spot => !spot.recordId).length }}면</strong></div>
      </article>
      <article>
        <span>🚘</span>
        <div><small>사용 중</small><strong>{{ spots.filter(spot => spot.recordId).length }}면</strong></div>
      </article>
    </section>
    <br/><br/>
    <div>
      <!-- 실제 데이터에 존재하는 층만 버튼으로 표시 -->
      <div style="text-align: center; margin-bottom: 20px;">
        <button v-for="f in floorList" :key="f" @click="selectedFloor = f" 
                :class="{ 'active-floor': selectedFloor === f }"
                style="margin: 0 5px; padding: 5px 15px;">
          {{ f }}층
        </button>
      </div>

      <table>
        <!-- 6개씩 자동 출력 -->
        <tr v-for="(row, rIdx) in chunkedSpots" :key="rIdx">
          <td v-for="spot in row" :key="spot.spotId">
            <!-- getCardClass 메서드를 통해 상태별 클래스 동적 바인딩 -->
            <div class="card" :class="getCardClass(spot)" style="width: 18rem;">
              <div class="card-body">
                <h5>{{ spot.spotId }}</h5>
                <h6>{{ spot.parkingFloor }}층 · {{ spot.section }}구역</h6>
                <h6>{{ formatType(spot.parkingType) }}</h6>
                <!-- 상태 텍스트 변경 -->
                <h5 class="status-text">
                  <span v-if="spot.spotId === searchedSpotId">내 차량</span>
                  <span v-else-if="spot.recordId">만차</span>
                  <span v-else>가능</span>
                </h5>
              </div>
            </div>
          </td>
        </tr>
      </table>
    </div>

    <div>
      <table>
        <tbody>
          <tr>
            <td id="text1">
              상인 및 일반 방문 고객을 위한 실시간 빈자리 확인 및 차량 조회
            </td>
          </tr>
          <tr>
            <td>
              <input type="text" v-model="searchCarNum" size="20" placeholder="25호2234" @keyup.enter="gobtn">&nbsp;
              <button type="button" @click="gobtn">
                <img src="@/assets/icon1.png" id="icon1">조회
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      selectedFloor: null, // 데이터 로드 후 첫 번째 층으로 자동 설정
      searchCarNum: '',
      spots: [],
      timer: null,
      searchedSpotId: null // 검색된 차량의 주차 공간 ID 저장
    };
  },
  computed: {
    // 실제 spots 데이터에 존재하는 층만 오름차순 추출
    floorList() {
      const floors = [...new Set(this.spots.map(s => s.parkingFloor))];
      return floors.sort((a, b) => a - b);
    },
    chunkedSpots() {
      const currentFloorSpots = this.spots.filter(s => s.parkingFloor === this.selectedFloor);
      const result = [];
      for (let i = 0; i < currentFloorSpots.length; i += 6) {
        result.push(currentFloorSpots.slice(i, i + 6));
      }
      return result;
    }
  },
  mounted() {
    this.fetchParkingSpots();
    this.timer = setInterval(this.fetchParkingSpots, 3000); // 3초마다 갱신
  },
  beforeUnmount() {
    if (this.timer) clearInterval(this.timer);
  },
  methods: {
    formatType(type) {
      if (type === 'pregnant') return '임산부석';
      if (type === 'disabled') return '장애인석';
      if (type === 'ev') return '전기차석';
      return '일반석';
    },
    async fetchParkingSpots() {
      try {
        const res = await axios.get("http://localhost:8282/parkingspots");
        //alert(JSON.stringify(res.data) );
        console.log("주차장 데이터 전체 response:", res);
        console.log("실제 응답 데이터(res.data):", res.data);
        if (res.data) {
          this.spots = res.data;
          // 처음 로드 시, 선택된 층이 없으면 가장 낮은 층을 기본 선택
          if (this.selectedFloor === null && this.floorList.length > 0) {
            this.selectedFloor = this.floorList[0];
          }
        }
      } catch (err) {
        console.error("데이터 로딩 실패:", err);
      }
    },
    // 주차 공간의 상태에 따라 CSS 클래스를 반환하는 메서드
    getCardClass(spot) {
      // 1순위: 내 차량 검색 결과
      if (this.searchedSpotId && spot.spotId === this.searchedSpotId) {
        return 'status-searched';
      }
      // 2순위: 만차 여부 (recordId 존재 시 만차)
      if (spot.recordId) {
        return 'status-occupied';
      }
      // 3순위: 주차 가능
      return 'status-available';
    },
    gobtn() {
      if (!this.searchCarNum.trim()) {
        alert("차량 번호를 입력하세요.");
        this.searchedSpotId = null; // 검색어 없으면 하이라이트 해제
        return;
      }
      // spots 데이터에서 차량 번호로 검색
      const found = this.spots.find(s => s.carNum === this.searchCarNum.trim());
      
      if (found) {
        this.selectedFloor = found.parkingFloor; // 해당 차량이 있는 층으로 이동
        this.searchedSpotId = found.spotId; // 검색된 spotId 저장 -> 클래스 바인딩에서 사용
        alert(`차량 [${this.searchCarNum}] 위치: ${found.parkingFloor}층 ${found.spotId}(${found.section}구역)`);
      } else {
        alert("주차된 차량을 찾을 수 없습니다.");
        this.searchedSpotId = null; // 검색 실패 시 하이라이트 해제
      }
    }
  }
}
</script>

<style scoped src="@/components/Css/Park.styles.css"></style>
