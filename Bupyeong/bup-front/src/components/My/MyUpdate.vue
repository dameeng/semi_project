<template>
    <table>
        <thead>
            <tr>
                <th colspan="3">내 정보 수정</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>회원구분</th>
                <td colspan="2">{{ authText }}</td>
            </tr>
            <tr>
                <th>ID (아이디)</th>
                <td colspan="2">{{ id }}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>{{ name }}</td>
                <td><input type="text" size="20" v-model="newName" placeholder="변경 시 입력"></td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>{{ email }}</td>
                <td><input type="text" size="20" v-model="newEmail" placeholder="변경 시 입력"></td>
            </tr>
            <tr>
                <th>차량번호</th>
                <td>{{ carNum }}</td>
                <td><input type="text" size="20" v-model="newCarNum" placeholder="변경 시 입력"></td>
            </tr>
            <tr>
                <th>특수차량</th>
                <td>{{ carTypesText }}</td>
                <td>
                    <input type="checkbox" id="pregnant" value="임산부" v-model="newCarTypes" />
                    <label for="pregnant">임산부</label>

                    <input type="checkbox" id="ev" value="전기차" v-model="newCarTypes" />
                    <label for="ev">전기차</label>

                    <input type="checkbox" id="disabled" value="장애인" v-model="newCarTypes" />
                    <label for="disabled">장애인</label>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <button type="button" @click="myupdate">수정하기</button>  <button type="button" @click="my">뒤로가기</button>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            // DB 원본 회원 정보 불러오기
            seq: null,
            auth: '',
            id: '',
            name: '',
            email: '',
            carNum: '',
            carTypes: '',

            // 수정 입력창용
            newName: '',
            newEmail: '',
            newCarNum: '',
            newCarTypes: [],
        };
    },

    computed: {
        authText() {
            const authMap = { 1: '관리자', 2: '상인', 3: '일반 회원' };
            return authMap[this.auth] || '일반 회원';
        },
        carTypesText() {
            if (!this.carTypes) return '해당 없음';
            const filtered = this.carTypes
                .split(',')
                .map(t => t.trim())
                .filter(t => t !== '일반' && t !== '');
            return filtered.length > 0 ? filtered.join(', ') : '해당 없음';
        }
    },

    mounted() {
        this.loadMemberInfo();
    },

    methods: {
        loadMemberInfo() {
            let login = JSON.parse(sessionStorage.getItem('login'));

            if (!login || !login.id) {
                alert('로그인이 필요합니다.');
                this.$router.push({ name: 'login' });
                return;
            }

            // 회원 정보 조회
            axios.post("http://localhost:8282/mypage/info", { id: login.id })
                .then(resp => {
                    let mem = resp.data;
                    if (mem) {
                        this.seq = mem.seq;
                        this.auth = mem.auth;
                        this.id = mem.id;
                        this.name = mem.name;
                        this.email = mem.email;
                        this.carNum = mem.carNum;
                        this.carTypes = mem.carTypes;

                        // 특수차량 배열 생성
                        this.newCarTypes = mem.carTypes
                            ? mem.carTypes.split(',').map(t => t.trim()).filter(t => t !== '일반' && t !== '')
                            : [];
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert('회원 정보를 불러오지 못했습니다.');
                });
        },

        my() {
            this.$router.push({ name: 'my' });
        },

        myupdate() {
            if (!this.seq) {
                alert('회원 식별 정보(seq)를 로드하지 못했습니다. 새로고침 후 다시 시도해 주세요.');
                return;
            }

            //  특수차량 체크박스 상태 비교 (배열 정렬 후 비교)
            const currentSelectedTypes = [...this.newCarTypes].sort().join(',');
            const originalTypes = this.carTypes
                ? this.carTypes.split(',').map(t => t.trim()).filter(t => t !== '일반' && t !== '').sort().join(',')
                : '';
            const isCarTypesUnchanged = currentSelectedTypes === originalTypes;

            //  텍스트 입력창이 모두 비어있는지 검사
            const isNameEmpty = this.newName.trim() === '';
            const isEmailEmpty = this.newEmail.trim() === '';
            const isCarNumEmpty = this.newCarNum.trim() === '';

            //  아무것도 변경된 게 없으면 요청 전송 중단
            if (isNameEmpty && isEmailEmpty && isCarNumEmpty && isCarTypesUnchanged) {
                alert('수정된 정보가 없습니다.');
                return;
            }

            // 수정할 데이터를 DTO 필드와 1:1 매핑
            let param = {
                seq: Number(this.seq),
                id: this.id,
                name: !isNameEmpty ? this.newName.trim() : this.name,
                email: !isEmailEmpty ? this.newEmail.trim() : this.email,
                carNum: !isCarNumEmpty ? this.newCarNum.trim() : this.carNum,
                carTypes: this.newCarTypes.length > 0 ? this.newCarTypes.join(',') : '',
            };

            axios.post("http://localhost:8282/mypage/updateMember", param)
                .then(resp => {
                    const { success, carNumBlocked, blockReason, data } = resp.data;

                    if (!success) {
                        alert('수정에 실패했습니다.');
                        return;
                    }

                    // 차량번호 변경이 막힌 경우 사유별 안내
                    if (carNumBlocked) {
                        if (blockReason === 'PARKING') {
                            alert('현재 차량이 주차장에 입차되어 있어 차량번호를 변경할 수 없습니다.\n(이름/이메일 등 다른 정보는 정상적으로 수정되었습니다.)');
                        } else if (blockReason === 'PREPAID') {
                            alert('이용 중인 정기권이 있어 차량번호를 변경할 수 없습니다.\n관리사무소 또는 고객센터로 문의해 주세요.\n(이름/이메일 등 다른 정보는 정상적으로 수정되었습니다.)');
                        }
                    } else {
                        alert('회원 정보가 성공적으로 수정되었습니다.');
                    }

                    // 서버가 실제로 저장한 최종 값으로 화면 갱신
                    // (차단된 경우 data.carNum은 원래 값 그대로 옴)
                    this.name = data.name;
                    this.email = data.email;
                    this.carNum = data.carNum;
                    this.carTypes = data.carTypes;

                    // 세션스토리지의 로그인 정보도 최신값으로 갱신
                    let login = JSON.parse(sessionStorage.getItem('login'));
                    if (login) {
                        login.name = data.name;
                        login.email = data.email;
                        login.carNum = data.carNum;
                        login.carTypes = data.carTypes;
                        sessionStorage.setItem('login', JSON.stringify(login));
                    }

                    // 입력 창 초기화
                    this.newName = '';
                    this.newEmail = '';
                    this.newCarNum = '';
                    this.newCarTypes = data.carTypes
                        ? data.carTypes.split(',').map(t => t.trim()).filter(t => t !== '일반' && t !== '')
                        : [];
                })
                .catch(err => {
                    console.error('수정 요청 에러:', err);
                    alert('수정 처리 중 서버 오류가 발생했습니다.');
                });
        }
    },
};
</script>

<style scoped src="@/components/Css/MyUpdate.styles.css"></style>