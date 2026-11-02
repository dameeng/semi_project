import qna from "../../components/Notice/Qna/Qna.vue";
import qnawrite from "../../components/Notice/Qna/QnaWrite.vue";
import notice from "../../components/Notice/Notice/Notice.vue";
import noticedetail from "../../components/Notice/Notice/Noticedetail.vue";
import noticewrite from "../../components/Notice/Notice/Noticewrite.vue";
import noticeupdate from "../../components/Notice/Notice/Noticeupdate.vue";
import faq from "../../components/Notice/Faq/Faq.vue";
import faqdetail from "../../components/Notice/Faq/Faqdetail.vue";
import faqupdate from "../../components/Notice/Faq/Faqupdate.vue";
import faqwrite from "../../components/Notice/Faq/Faqwrite.vue";
import qnadetail from "../../components/Notice/Qna/QnaDetail.vue";
import qnaupdate from "../../components/Notice/Qna/QnaUpdate.vue";


//알림 관련 
export default[
    { //알림
        path: '/notice',
        name: 'notice',
        component: notice
    },
    {
        path: '/noticedetail/:seq',
        name: 'noticedetail',
        component: noticedetail
    },
    {
        path: '/noticewrite',
        name: 'noticewrite',
        component: noticewrite
    },
    {
        path: '/noticeupdate/:seq',
        name: 'noticeupdate',
        component: noticeupdate
    },
    //=================================Faq 폴더 관련=============================
     // 자주 묻는 질문 목록
    {
        path: '/faq',
        name: 'faq',
        component: faq
    },
    // 자주 묻는 질문 상세
    {
        path: '/faqdetail/:seq',
        name: 'faqdetail',
        component: faqdetail
    },
    { // 관리자 글 등록
        path: '/faqwrite',
        name: 'faqwrite',
        component: faqwrite
    },
    // 관리자 글 수정
    {
        path: '/faqupdate/:seq',
        name: 'faqupdate',
        component: faqupdate
    },
     {
        path: '/qna',
        name: 'qna',
        component: qna
    },
     {
        path: '/qnawrite',
        name: 'qnawrite',
        component: qnawrite
    },
    {
        path: '/qnadetail/:seq',
        name: 'qnadetail',
        component: qnadetail
    },
       {
        path: '/qnaupdate/:seq',
        name: 'qnaupdate',
        component: qnaupdate
    },
]
