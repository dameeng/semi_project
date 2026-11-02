<template>
    <div id="div1">
        <h1>주차 요금 안내 </h1>
        <h4> 상세 요금 안내  </h4>
        <h6> *15분내 회차시 이용료 <strong>무료</strong></h6>
        <table>
            <thead>
                <tr>
                    <th> 구분 </th>
                    <th> 일반 </th>
                    <th> 점주</th>
                    <th> 비회원</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>정기권 이용요금</th>
                    <td> 100,000원/월 </td>
                    <td>50,000원/월</td>
                    <td> - </td>
                </tr>
                <tr>
                    <th>일일 최대 주차 이용요금</th>
                    <td colspan="3" > 30,000원/일 </td>
                   
                </tr>
                <tr>
                    <th>기본 요금  </th>
                    <td colspan="3"> 1,000 /30분  </td>
                    
                </tr>
            </tbody>
        </table>

        <div id="textbox">
            <h6>비회원의 경우 정기권 발급이 불가하오니 정기권 신청을 원하실 경우 회원가입을 진행해 주십시오.</h6>          
        </div>
         <button type="button" @click="SignUp"> 회원가입 바로가기 </button> <button type="button" @click="PassApply"> 정기권 신청 바로가기 </button>

    </div>
</template>

<script>
export default{
    methods: {
        SignUp() {
            const login = JSON.parse(sessionStorage.getItem("login"));  // 수정한부분 로그인 시 회원가입을 못하게

            if(login) {
                alert("이미 로그인되어 있는 회원입니다.");
                return;
            }


             this.$router.push({ name: 'signup' });
        },
         PassApply() {
            const login = JSON.parse(sessionStorage.getItem("login"));

            if(!login) {
                alert("로그인이 필요한 서비스 입니다");
                this.$router.push({ name : 'login'});
                return;
            }

             this.$router.push({ name: 'passapply' });  // 정기권 신청 안들어가지는 문제 수정
        }
    },
}
</script>

<style scoped src="@/components/Css/ParkCost.styles.css"></style>