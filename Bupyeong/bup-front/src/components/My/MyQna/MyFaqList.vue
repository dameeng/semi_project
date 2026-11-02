<template>
  <div class="myfaq-container">
    <h2> 내 질의응답 조회</h2>
    <p class="subtitle">내가 등록한 Q&A 질문 목록과 관리자의 답변을 확인하실 수 있습니다.</p>

    <!-- 상세보기 카드 및 관리자 답변 영역 -->
    <div v-if="selectedFaq" class="faq-detail-card">
      <div class="detail-header">
        <span class="status-badge" :class="selectedFaq.replycontent ? 'completed' : 'waiting'">
          {{ selectedFaq.replycontent ? '답변 완료' : '답변 대기' }}
        </span>
        <h3>{{ selectedFaq.title }}</h3>
        <button class="close-btn" @click="selectedFaq = null">닫기 ✖</button>
      </div>

      <div class="detail-meta">
        <span>작성자: {{ selectedFaq.writerId }}</span>
        <span>작성일: {{ formatDate(selectedFaq.wdate) }}</span>
        <span>조회수: {{ selectedFaq.readcount || 0 }}</span>
      </div>

      <hr class="divider" />

      <!-- 사용자 질문 내용 -->
      <div class="section-box">
        <h4 class="section-title"> 내 질문 내용</h4>
        <p class="question-content">{{ selectedFaq.content }}</p>
      </div>

      <!-- 관리자 답변 내용 (답변이 있는 경우) -->
      <div v-if="selectedFaq.replycontent" class="section-box reply-box">
        <h4 class="section-title reply-title">관리자 답변</h4>
        <p class="reply-content">{{ selectedFaq.replycontent }}</p>
        <span v-if="selectedFaq.replydate" class="reply-date">
          답변일시: {{ formatDate(selectedFaq.replydate) }}
        </span>
      </div>

      <div v-else class="section-box waiting-box">
        <p> 관리자가 답변을 작성 중입니다. 잠시만 기다려주세요.</p>
      </div>
    </div>

    <!-- 내 Q&A 목록 테이블 -->
    <div class="table-wrapper">
      <table class="faq-table">
        <thead>
          <tr>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">상태</th>
            <th width="15%">작성일</th>
            <th width="10%">조회수</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td colspan="5" class="empty-msg">질문 목록을 불러오는 중입니다...</td>
          </tr>
          <tr v-else-if="faqlist.length === 0">
            <td colspan="5" class="empty-msg">등록하신 Q&A 질문이 없습니다.</td>
          </tr>
          <tr
            v-for="(faq, index) in faqlist"
            :key="faq.seq"
            @click="fetchDetail(faq.seq)"
            class="faq-row"
          >
            <td>{{ index + 1 }}</td>
            <td class="title-td">
              <span v-if="faq.issecret">🔒 </span>
              {{ faq.title }}
            </td>
            <td>
              <span class="status-badge" :class="faq.replycontent || faq.status === 'COMPLETED' ? 'completed' : 'waiting'">
                {{ faq.replycontent || faq.status === 'COMPLETED' ? '답변 완료' : '답변 대기' }}
              </span>
            </td>
            <td>{{ formatDate(faq.wdate) }}</td>
            <td>{{ faq.readcount || 0 }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'MyFaqView',
  data() {
    return {
      faqlist: [],
      selectedFaq: null,
      loading: false
    };
  },
  mounted() {
    this.fetchMyFaqList();
  },
  methods: {
    // 1. 내 Q&A 목록 조회 (POST /myfaq?writerId=...)
    fetchMyFaqList() {
      let loginUser = JSON.parse(sessionStorage.getItem('login'));

      if (!loginUser || !loginUser.id) {
         alert('로그인이 필요합니다');
        this.$router.push('/login');
        return;
      }

      this.loading = true;
      // Spring @RequestParam 및 RequestBody 전송 호환성을 위해 Query String + Body 동시 전송
      axios
        .post(`http://localhost:8282/myqna?writerId=${loginUser.id}`, { writerId: loginUser.id })
        .then((res) => {
          this.faqlist = res.data || [];
        })
        .catch((err) => {
          console.error('내 Q&A 목록 불러오기 에러:', err);
        })
        .finally(() => {
          this.loading = false;
        });
    },
    // 2. Q&A 상세보기 (POST /detailfaq?seq=...)
    fetchDetail(seq) {
      axios
        .post(`http://localhost:8282/detailqna?seq=${seq}`)
        .then((res) => {
          if (res.data) {
            this.selectedFaq = res.data;
            this.fetchMyFaqList(); // 조회수 갱신용 목록 재호출
          }
        })
        .catch((err) => {
          console.error('Q&A 상세 조회 에러:', err);
        });
    },
    formatDate(dateStr) {
      if (!dateStr) return '-';
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr;
      return date.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
      });
    }
  }
};
</script>

<style scoped src="@/components/Css/MyFaqList.styles.css"></style>