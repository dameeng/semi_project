import park from "../../components/Park/Park.vue";
import parkcost from "../../components/Park/ParkCost.vue";
import parkinfo from "../../components/Park/ParkInfo.vue";


//주차 현황 관련 
export default[
    { //주차현황
        path: '/park',
        name: 'park',
        component: park
    },
    { //주차장 소개
        path: '/parkinfo',
        name: 'parkinfo',
        component: parkinfo

    },
    { //주차장 운영 요금 
         path: '/parkcost',
        name: 'parkcost',
        component: parkcost 
    }

]