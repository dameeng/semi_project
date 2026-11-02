<template>
    <div>
        <h1 id="title1">내 정기권 신청 정보</h1>
        <table>
            <thead >
                <tr>
                    <th th colspan="2"> {{ ownerName }} 님의 정기권 신청 현황입니다</th>

                </tr>
            </thead>
            <tbody>

                <tr>
                    <th>차량번호</th>
                    <td>{{ carNum }}</td>
                </tr>
                <tr>
                    <th> 정기권 신청 날짜</th>
                    <td>{{ createdAt }}</td>
                </tr>
                <tr>
                    <th> 정기권 유형</th>
                    <td>{{ type }}</td>
                </tr>

                <tr>
                    <th>사용 시작일</th>
                    <td>{{ startDate }}</td>
                </tr>

                <tr>
                    <th>사용 마감일</th>
                    <td>{{ endDate }}</td>
                </tr>

                <tr>
                    <th> 정기권 금액 </th>
                    <td>{{ price }}</td>
                </tr>

                <tr>
                    <th> 승인상태 </th>
                    <td>{{ statusText }}</td>
                </tr>
            </tbody>
        </table>
    </div>

</template>

<script>

import axios from 'axios';

export default {
    data() {
        return {
            ownerName: '',
            carNum: '',
            createdAt: '',
            type: '',
            startDate: '',
            endDate: '',
            price: '',
            status: '',

        };
    },

    computed: {
        statusText() {
            const statusMap = {
                approved: '승인',
                requested: '승인 대기',
                rejected: '거절',
                expired: '만료'
            };

            return statusMap[this.status] || '미신청 상태로 확인 불가';
        }
    },

    mounted() {
    //로그인 정보 없을 경우 경고창 실행 
    let login = JSON.parse(sessionStorage.getItem('login'));

    if (!login) {
        alert('로그인이 필요합니다');
        this.$router.push({ name: 'login' });
        return;
    }

    //백엔드 주소로 보낼 데이터 백엔드가 요청한 UserId에 this 로그인 정보 id 담아서 ㄱㄱ
    axios.get("http://localhost:8282/prepaid/my-status",{ 
        params:{
            userId:login.id
        }
    })
    .then(resp => {

            console.log(resp.data);
            //alert(JSON.stringify(resp.data));

            // 백엔드가 List를 반환하므로 첫 번째 데이터 사용
            if (resp.data.length > 0) {

                const mem = resp.data[0];

                this.ownerName = mem.ownerName;
                this.carNum = mem.carNum;
                this.createdAt = mem.createdAt;
                this.type = mem.type;
                this.startDate = mem.startDate;
                this.endDate = mem.endDate;
                this.price = mem.price;
                this.status = mem.status;
            }
            else{
                alert("정기권 신청 내역이 없습니다.");
            }

        })
        .catch(err => {
            console.log(err);
            alert("err ");
        });

    }
};
</script>


<style scoped src="@/components/Css/MyPass.styles.css"></style>