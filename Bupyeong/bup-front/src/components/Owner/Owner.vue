<template>
    <div class="discount">
    <h2>상가 할인</h2>
    <input type="text" v-model.trim="carNum" :disabled="isSubmitting" @keyup.enter="discount" placeholder="차 번호를 입력하세요">

    <button type="button" :disabled="isSubmitting || !carNum.trim()" @click="discount">
        {{ isSubmitting ? '처리중...' : '2시간 할인' }}
    </button>
</div>
    <p v-if="message">{{ message }}</p>
</template>

<script>
import axios from 'axios'

export default {
    data() {
        return {
            carNum: '',
            isSubmitting: false,
            message: ''
        }
    },
    methods: {
        discount() {
            if (this.isSubmitting) return;

            const carNum = this.carNum.replace(/\s+/g, '');
            if (!carNum) {
                this.message = '차량번호를 입력해주세요';
                return;
            }

            const savedlogin = sessionStorage.getItem('login');
            if (!savedlogin) {
                this.message = '로그인이 필요합니다';
                return;
            }

            let loginuser;
            try {
                loginuser = JSON.parse(savedlogin);
            } catch (error) {
                this.message = '로그인 정보를 확인할 수 없습니다';
                return;
            }

            this.isSubmitting = true;
            this.message = '';

            axios.post('http://localhost:8282/store/discount/apply', {
                id: loginuser.id,
                carNum: carNum
            })
            .then((resp) => {
                this.message = `${carNum} 2시간 할인이 등록되었습니다`;
                this.carNum = '';
                console.log('할인 등록 결과', resp.data);
            })
            .catch((error) => {
                const status = error.response?.status;
                if (status === 404) {
                    this.message = '현재 주차 중인 차량을 찾을 수 없습니다.';
                } else if (status === 409) {
                    this.message = '이미 2시간 할인이 등록된 차량입니다.';
                } else if (status === 400) {
                    this.message = '등록된 매장 정보가 없습니다.';
                } else {
                    this.message = '할인 처리 중 오류가 발생했습니다.';
                }
                console.error('할인 등록 오류:', error);
            })
            .finally(() => {
                this.isSubmitting = false;
            });
        }
    }
};
</script>


<style scoped src="@/components/Css/Owner.styles.css"></style>