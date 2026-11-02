import { createRouter, createWebHistory } from 'vue-router';
import member from './Member/Member.js';
import board from './Board/Board.js';
import notice from './Notice/Notice.js';
import park from './Park/Park.js';
import pass from './Pass/Pass.js';
import stores from './Stores/Stores.js';
import admin from './Admin/Admin.js';
import owner from './Owner/Owner.js';

const router = createRouter({
    history: createWebHistory(),
    routes: [
        ...member,
        ...board,
        ...notice,
        ...park,
        ...pass,
        ...stores,      
        ...admin,
        ...owner

    ]
})

// 이미 로그인된 상태에서 /login으로 접근(뒤로가기, 직접 URL 입력 등)하는 것을 전역에서 차단
router.beforeEach((to, from, next) => {
    const loginData = sessionStorage.getItem("login");
    if (to.name === "login" && loginData) {
        alert("로그인 상태입니다. 로그아웃을 먼저 진행해 주세요.");
        next({ name: "home" });
    } else {
        next();
    }
});

export default router;