import admin from "@/components/Admin/Admin.vue";


//beforeEnter: 페이지에 들어가기 '직전'에 실행되는 보안 검사 함수
// (to: 이동할 페이지, from: 이전 페이지, next: 이동을 허용/거부하는 제어 함수)
export default [
    {
        path: '/admin',
        name: 'admin',
        component: admin,
        beforeEnter: (to, from, next) => { 
            const savedlogin = sessionStorage.getItem('login');
            if (!savedlogin) {
                alert('로그인이 필요합니다.');
                next({ name: 'login' });
                return;
            }
            try {
                const user = JSON.parse(savedlogin);
                if (Number(user.auth) === 1) {
                    next();
                } else {
                    alert('관리자전용 페이지입니다.');
                    next({ name: 'home' });
                }
            } catch (e) {
                alert('로그인 정보를 확인할 수 없습니다.');
                next({ name: 'login' });
            }
        }
    },
]

