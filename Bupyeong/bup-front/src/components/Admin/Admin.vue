<template>
    <div class="admin">
      <aside class="admin-nav">
        <div class="admin-nav-title"><span>⚙️</span><div><small>ADMIN MENU</small><h2>통합 관리</h2></div></div>
        <ul>
          <li><button @click="goPassapply"><span>🎫</span><div><b>정기권 관리</b><small>신청 승인 및 현황</small></div><i>›</i></button></li>
          <li><button @click="goStores"><span>🏬</span><div><b>상가 관리</b><small>입점 매장 정보</small></div><i>›</i></button></li>
          <li><button @click="goNotice"><span>📢</span><div><b>알림 관리</b><small>공지사항 등록</small></div><i>›</i></button></li>
          <li><button @click="goBoarddetail"><span>💬</span><div><b>게시판 관리</b><small>자유게시판 확인</small></div><i>›</i></button></li>
          <li><button @click="goQna"><span>🌿</span><div><b>1:1 문의 관리</b><small>문의 답변 처리</small></div><i>›</i></button></li>
        </ul>
      </aside>

      <main class="admin-content">
        <div class="dashboard-heading"><div><span>OVERVIEW</span><h2>대시보드 현황</h2><p>주차 이용 현황과 월별 매출을 한눈에 확인하세요.</p></div><em>● 실시간 연동</em></div>

        <section class="admin-summary">
          <article><span>🅿️</span><div><small>집계된 주차 차량</small><strong>{{ totalParking.toLocaleString() }}대</strong></div></article>
          <article><span>💰</span><div><small>연간 누적 매출</small><strong>{{ totalRevenue.toLocaleString() }}원</strong></div></article>
          <article><span>📈</span><div><small>최고 매출 월</small><strong>{{ peakMonth }}</strong></div></article>
        </section>

        <section class="board">
          <article class="chart-card circleboard"><div class="chart-heading"><div><small>PARKING STATUS</small><h3>층별 주차 현황</h3></div><span>층별 비율</span></div><div class="chart-area pie-area"><Pie :data="pieData" :options="pieOptions" :plugins="[ChartDataLabels]"/></div></article>
          <article class="chart-card barboard"><div class="chart-heading"><div><small>MONTHLY SALES</small><h3>월별 매출 금액</h3></div><span>단위: 원</span></div><div class="chart-area"><Bar :data="barData" :options="barOptions"/></div></article>
        </section>
      </main>
    </div>

</template>

<script>
export default{
    methods: {

    goNotice(){
        this.$router.push({name:'notice'})
    },
    goPassapply(){
        this.$router.push({name:'passnow'})
    },
    goStores(){
        this.$router.push({name:'stores'})
    },
    goBoarddetail(){
        this.$router.push({name:'boardlist'})
    },
 goQna(){
        this.$router.push({name:'qna'})
    }
}
}
</script>

<script setup>

import { ref, onMounted, computed } from 'vue'
import axios from 'axios'

/* 원형 그래프와 막대그래프 컴포넌트 */
import { Pie, Bar } from 'vue-chartjs'
import ChartDataLabels from 'chartjs-plugin-datalabels'

/* Chart.js에서 사용할 기능 */
import {
    Chart as ChartJS,

    /* 원형 그래프에 필요 */
    ArcElement,

    /* 막대그래프에 필요 */
    CategoryScale,
    LinearScale,
    BarElement,

    /* 공통 기능 */
    Tooltip,
    Legend
} from 'chart.js'


/* Chart.js 기능 등록 */
ChartJS.register(
    ArcElement,
    CategoryScale,
    LinearScale,
    BarElement,
    Tooltip,
    Legend
)


/* ========================================
   원형 그래프 데이터 (기본값 설정)
======================================== */
const pieData = ref({
    labels: ['1층', '2층', '3층'],
    datasets: [
        {
            data: [80, 60, 45],
            backgroundColor: [
                '#55771f',
                '#8ca847',
                '#c18335'
            ],
            borderColor: '#ffffff',
            borderWidth: 2,
            hoverBorderColor: '#2f4514',
            hoverBorderWidth: 5,
            hoverOffset: 5
        }
    ]
})

/* 원형 그래프 설정 */
const pieOptions = {
    responsive: true,
    maintainAspectRatio: true,
    plugins: {
        legend: {
            position: 'bottom'
        },
        datalabels: {
            color: 'white',
            anchor: 'center',
            align: 'center',
            textAlign: 'center',
            font: {
                size: 14,
                weight: 'bold'
            },
            formatter: (value, context) => {
                const total = context.dataset.data.reduce(
                    (sum, number) => sum + number,
                    0
                )
                if (total === 0) return ''
                const percent = Math.round((value / total) * 100)
                const floor = context.chart.data.labels[context.dataIndex]
                return `${floor} ${percent}%`  
            }
        },
        tooltip: {
            callbacks: {
                label: (context) => {
                    return `${context.label}: ${context.raw}대`
                }
            }
        }
    }
}

/* ========================================
   막대그래프 데이터 (기본값 설정)
======================================== */
const barData = ref({
    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    datasets: [
        {
            label: '월별 주차장 매출',
            data: [
                12500000, 11800000, 13200000, 14100000, 15300000, 16000000,
                17200000, 16800000, 15700000, 14900000, 16300000, 18000000
            ],
            backgroundColor: '#55771f',
            hoverBackgroundColor: '#304713',
            borderColor: '#3d5918',
            borderWidth: 0,
            hoverBorderColor: '#172309',
            hoverBorderWidth: 5,
            borderRadius: 5,
            maxBarThickness: 45
        }
    ]
})

/* 막대그래프 설정 */
const barOptions = {
    responsive: true,
    maintainAspectRatio: true,
    scales: {
        y: {
            beginAtZero: true,
            ticks: {
                callback: (value) => {
                    return `${Number(value).toLocaleString()}원`
                }
            }
        },
        x: {
            grid: {
                display: false
            }
        }
    },
    plugins: {
        legend: {
            position: 'bottom'
        },
        tooltip: {
            callbacks: {
                label: (context) => {
                    const value = Number(context.raw).toLocaleString()
                    return `매출: ${value}원`
                }
            }
        }
    }
}

const totalParking = computed(() => pieData.value.datasets[0]?.data.reduce((sum, value) => sum + Number(value || 0), 0) || 0)
const totalRevenue = computed(() => barData.value.datasets[0]?.data.reduce((sum, value) => sum + Number(value || 0), 0) || 0)
const peakMonth = computed(() => {
    const values = barData.value.datasets[0]?.data || []
    if (!values.length) return '-'
    const maxIndex = values.indexOf(Math.max(...values.map(Number)))
    return barData.value.labels[maxIndex] || '-'
})

/* 백엔드 대시보드 API 호출 */
const getDashboardData = () => {
    axios.get("http://localhost:8282/admin/dashboard")
        .then((resp) => {
            const data = resp.data;
            if (data) {
                if (data.pieLabels && data.pieLabels.length > 0 && data.pieData && data.pieData.length > 0) {
                    pieData.value = {
                        labels: data.pieLabels,
                        datasets: [
                            {
                                data: data.pieData,
                                backgroundColor: [
                                    '#55771f',
                                    '#8ca847',
                                    '#c18335',
                                    '#76543c',
                                    '#a55343'
                                ],
                                borderColor: '#ffffff',
                                borderWidth: 2,
                                hoverBorderColor: '#2f4514',
                                hoverBorderWidth: 5,
                                hoverOffset: 5
                            }
                        ]
                    }
                }

                if (data.barLabels && data.barLabels.length > 0 && data.barData && data.barData.length > 0) {
                    barData.value = {
                        labels: data.barLabels,
                        datasets: [
                            {
                                label: '월별 주차장 매출',
                                data: data.barData,
                                backgroundColor: '#55771f',
                                hoverBackgroundColor: '#304713',
                                borderColor: '#3d5918',
                                borderWidth: 0,
                                hoverBorderColor: '#172309',
                                hoverBorderWidth: 5,
                                borderRadius: 5,
                                maxBarThickness: 45
                            }
                        ]
                    }
                }
            }
        })
        .catch((err) => {
            console.log("백엔드 미연동 시 기본 예시 데이터 유지:", err);
        })
}

onMounted(() => {
    getDashboardData();
})
</script>



<style scoped src="@/components/Css/Admin.styles.css"></style>
<!-- 관리자 메뉴와 관리 현황을 보여주는 화면입니다. -->
