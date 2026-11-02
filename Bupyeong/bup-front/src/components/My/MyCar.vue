<template>
  <div class="parking-container">
    <div class="header-section">
      <h1>스마트 일일 주차 확인 시스템</h1>
      <h5>당일 주차하신 차량이 없으실 경우 조회 되지 않습니다.</h5>
    </div>

    <!-- 카드 1: 내 차량 위치 & 주차 시간 -->
    <div id="card1">
      <!-- 내 차량 위치 -->
      <table class="info-table">
        <thead>
          <tr>
            <th colspan="2">내 차량 찾기 서비스</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>차량 번호 |</th>
            <td>{{ hasParkingRecord ? carNum : "현재 주차 중인 차량이 없습니다" }}</td>
          </tr>
          <tr>
            <th>층수 |</th>
            <td>{{ hasParkingRecord ? parkingFloor : "-" }}</td>
          </tr>
          <tr>
            <th>주차 구역 |</th>
            <td>{{ hasParkingRecord ? parkingZone : "-" }}</td>
          </tr>
        </tbody>
      </table>

      <!-- 주차 시간 -->
      <table class="info-table">
        <thead>
          <tr>
            <th colspan="2">주차 시간</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>입차 시간 |</th>
            <td>{{ hasParkingRecord ? formatDate(entryTime) : "-" }}</td>
          </tr>
          <tr>
            <th>출차 시간 |</th>
            <td>
              {{ !hasParkingRecord ? "-" : (exitTime ? formatDate(exitTime) : "출차 전") }}
            </td>
          </tr>
          <tr>
            <th>총 주차 시간 |</th>
            <td>{{ hasParkingRecord ? formatMinutes(totalMin) : "-" }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 정산 내역 -->
    <div class="fee-section">
      <table id="finalfeetable">
        <thead>
          <tr>
            <th colspan="2">정산 내역</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>주차비용</th>
            <td class="text-right">{{ hasParkingRecord ? Number(rawFee).toLocaleString() + " 원" : "-" }}</td>
          </tr>
          <tr>
            <th>할인금액</th>
            <td class="text-right">{{ hasParkingRecord ? Number(discountFee).toLocaleString() + " 원" : "-" }}</td>
          </tr>
          <tr class="highlight-row">
            <th>정산하실 금액</th>
            <td class="text-right">{{ hasParkingRecord ? Number(finalFee).toLocaleString() + " 원" : "-" }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      carNum: "",
      parkingFloor: "",
      parkingZone: "",

      entryTime: "",
      exitTime: null,
      totalMin: null,

      hasParkingRecord: false,

      rawFee: 0,
      discountFee: 0,
      finalFee: 0
    };
  },

  mounted() {
    const login = JSON.parse(sessionStorage.getItem("login"));

    if (!login) {
      alert("로그인이 필요합니다.");
      this.$router.push({ name: "login" });
      return;
    }

    // 차량 위치 조회 (POST 바디 데이터 전송으로 수정)
    axios.post("http://localhost:8282/mypage/carLocation", { id: login.id })
      .then(res => {
        if (res.data) {
          this.carNum = res.data.carNum;
          this.parkingFloor = res.data.parkingFloor;
          this.parkingZone = res.data.parkingZone;
          this.entryTime = res.data.entryTime;
          this.hasParkingRecord = true;
        } else {
          this.hasParkingRecord = false;
        }
      })
      .catch(err => {
        console.error(err);
        this.hasParkingRecord = false;
      });

    // 주차요금 조회
    axios.post("http://localhost:8282/mypage/parkingCost", { id: login.id })
      .then(res => {
        if (res.data) {
          this.exitTime = res.data.exitTime;
          this.totalMin = res.data.totalMin;
          this.rawFee = res.data.rawFee;
          this.discountFee = res.data.discountFee;
          this.finalFee = res.data.finalFee;
        }
      })
      .catch(err => {
        console.error(err);
      });
  },

  methods: {
    // 날짜 포맷 함수 (2026-08-06T07:50:00 -> 2026-08-06 07:50)
    formatDate(dateStr) {
      if (!dateStr) return "-";
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr;

      const pad = (n) => (n < 10 ? "0" + n : n);
      return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
    },
    // 분 -> 시간/분 변환 함수
    formatMinutes(minutes) {
      if (!minutes && minutes !== 0) return "-";
      const hrs = Math.floor(minutes / 60);
      const mins = minutes % 60;
      return hrs > 0 ? `${hrs}시간 ${mins}분` : `${mins}분`;
    }
  }
};
</script>

<style scoped src="@/components/Css/MyCar.styles.css"></style>