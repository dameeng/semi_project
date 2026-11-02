<template>

         <h2>1:1 질의응답 글작성</h2>

      <div class="top-menu">
      <button type="button" @click="goFaq">자주 묻는 질문</button>
      <button type="button" @click="goNotice">공지사항</button>
      <button type="button" @click="goQna">1:1 질의응답 조회</button>
     </div>

     <div>
      <table>
        <tbody>
        <tr>
            <th>공개여부</th>
            <td>
                <label><input type="radio" v-model="issecret" :value="false">공개</label>
                <label><input type="radio" v-model="issecret" :value="true">비공개</label>
            </td>
            </tr>
        <tr>
            <th>제목</th><td><input v-model="title" type="text" placeholder="제목을 입력해주세요." /></td>
        </tr>
        <tr>
            <th>내용</th>
            <td><textarea v-model="content" placeholder="내용을 입력해주세요."></textarea></td>
        </tr>
      </tbody>
    </table>
     <div class="button-area">
        <button type="button" @click="writeQna">등록</button>
        <button type="button" @click="cancel">취소</button>
       
      </div>
    </div>


</template>

<script>
import axios from "axios";


export default{
data() {
    return {
        writerId:"",
        title:"",
        content:"",
        issecret:false
    }
},    
mounted(){
    //저장된 로그인 정보 가져오기
    const loginData = sessionStorage.getItem("login");

    if(!loginData || loginData ==="null"){
        alert("로그인이 필요합니다");
        this.$router.push({name:"qna"});
        return;
    }
    try{
        const login = JSON.parse(loginData);
        this.writerId = login.id;
    }catch(error){
        console.error("로그인 정보 확인 오류:", error);
        alert("로그인 정보를 확인할 수 없습니다");
        this.$router.push({name: "home"});
    }
},
methods: {
    writeQna(){
        if(!this.title.trim()) {
            return alert("제목을 입력해 주십시오");
        }
        if(!this.content.trim()){
         return alert("내용을 입력해 주십시오");
        }
        //백엔드 qna에 전달할 데이터
        const param = {
            writerId : this.writerId,
            title : this.title,
            content : this.content,
            issecret : this.issecret
        }
        axios
        .post("http://localhost:8282/addqna", param)
        .then((resp ) =>{
            if(resp.data > 0){
                alert("문의가 등록되었습니다");
                this.$router.push({name: "qna"});
            }else{
                alert("문의 등록이 실패했습니다");
            }
        })
        .catch((error) =>{
            console.error("문의 등록 오류", error);
            alert("문의 등록 중 오류가 발생했습니다");
        })
},
cancel(){
    this.$router.push({name: "qna"});
},
 goFaq() { this.$router.push({ name: "faq" });
     },
    goNotice() { this.$router.push({ name: "notice" });
 },
    goQna() { this.$router.push({ name: "qna" }); 
}
}
}
</script>



<style scoped src="@/components/Css/QnaWrite.styles.css"></style>