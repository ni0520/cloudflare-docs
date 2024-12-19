<template>
  <div class="home">
    <el-row class="mb-4">
      <el-button type="primary">Primary Button</el-button>
      <el-button type="success">Success Button</el-button>
    </el-row>
    <el-icon><Edit /></el-icon>
    <el-icon><Share /></el-icon>
  </div>
</template>

<script setup lang="ts">
import { Edit, Share } from '@element-plus/icons-vue'
</script>

<style scoped>
.home {
  padding: 20px;
}
</style>