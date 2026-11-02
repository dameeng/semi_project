<template>
  <div class="kakaomap-container">
    <div class="map-header">
      <h2 class="map-title">부평역사쇼핑몰 오시는 길</h2>
      <p class="map-desc">인천광역시 부평구 광장로 16 (부평동)</p>
    </div>

    <div id="map" class="map-area"></div>
    
    <div class="transport-info">
      <div class="info-item">
        <span class="icon">🚇</span>
        <div class="info-text">
          <strong>지하철</strong>
          <p>1호선, 인천지하철 1호선 부평역 연결</p>
        </div>
      </div>
      <div class="info-item">
        <span class="icon">🚌</span>
        <div class="info-text">
          <strong>버스</strong>
          <p>부평역 정류장 하차 (도보 1분)</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped src="@/components/Css/KakaoMap.styles.css"></style>

<script>
let kakaoLoadPromise = null;

function loadKakaoScript() {
  if (window.kakao && window.kakao.maps) {
    return Promise.resolve();
  }
  if (kakaoLoadPromise) {
    return kakaoLoadPromise;
  }

  kakaoLoadPromise = new Promise((resolve, reject) => {
    const script = document.createElement("script");
    script.src =
      "https://dapi.kakao.com/v2/maps/sdk.js?appkey=2750720f5d13b472156aa20d4329da07&autoload=false";
    script.onload = () => {
      window.kakao.maps.load(() => {
        resolve();
      });
    };
    script.onerror = (e) => {
      kakaoLoadPromise = null;
      reject(e);
    };
    document.head.appendChild(script);
  });

  return kakaoLoadPromise;
}

export default {
  name: "KakaoMap",
  mounted() {
    loadKakaoScript()
      .then(() => {
        this.initMap();
      })
      .catch((e) => {
        console.error("지도 초기화 실패:", e);
      });
  },
  methods: {
    initMap() {
      const container = document.getElementById("map");
      if (!container) return;

      const locPosition = new window.kakao.maps.LatLng(37.489472, 126.724116);
      const options = {
        center: locPosition,
        level: 3,
      };
      const map = new window.kakao.maps.Map(container, options);
      
      // 마커 추가
      const marker = new window.kakao.maps.Marker({
        position: locPosition
      });
      marker.setMap(map);
    }
  },
};
</script>