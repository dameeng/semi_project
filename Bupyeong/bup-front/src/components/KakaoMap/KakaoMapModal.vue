<template>
  <Teleport to="body">
    <div class="map-overlay" @click.self="close">
      <div class="map-modal">
        <button class="map-close" @click="close">✕</button>
        <KakaoMap />
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import KakaoMap from './KakaoMap.vue'

const emit = defineEmits(['close'])

function close() {
  emit('close')
}
</script>

<style scoped src="@/components/Css/KakaoMapModal.styles.css"></style>