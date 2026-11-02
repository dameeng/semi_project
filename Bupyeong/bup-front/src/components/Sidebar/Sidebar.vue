<template>
 <aside v-if="currentSidebar" class="sidebar">
    <!-- 사이드바 대표 제목 -->
    <h2 class="sidebar-title">
      {{ currentSidebar.title }}
    </h2>

    <!-- 해당 페이지 그룹의 메뉴 목록 -->
    <ul class="sidebar-menu">
      <li
        v-for="menu in currentSidebar.menus"
        :key="menu.name"
        class="sidebar-menu-item"
      >
        <!--
          Vue Router를 사용한 페이지 이동

          menu.name:
            클릭했을 때 이동할 route name

          active 클래스:
            현재 보고 있는 페이지에 해당하는 메뉴 강조
        -->
        <router-link
          :to="{ name: menu.name }"
          class="sidebar-link"
          :class="{ active: isActive(menu) }"
        >
          {{ menu.label }}
        </router-link>
      </li>
    </ul>
    </aside>

</template>



<script>
import sidebarConfig from "./Sidebar/SidebarConfig.js";

export default {
  name: "Sidebar",

  computed: {
   currentSidebar() {
      return (
        sidebarConfig.find((group) =>
          group.routeNames.includes(this.$route.name)
        ) || null
      );
    }
  },
 methods: {
    /*
      현재 메뉴가 선택된 상태인지 확인가능*/
    isActive(menu) {
      // activeNames가 있는 경우 현재 route name이 포함됐는지 검사
      if (menu.activeNames) {
        return menu.activeNames.includes(this.$route.name);
      }

      // activeNames가 없으면 이동할 route name과 직접 비교
      return this.$route.name === menu.name;
    }
  }
};
</script>


<style scoped src="@/components/Css/Sidebar.styles.css"></style>