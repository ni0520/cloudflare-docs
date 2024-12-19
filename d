import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css' // 如果使用 Element Plus，別忘了引入樣式

const app = createApp({})
const pinia = createPinia()

app.use(pinia)
app.use(ElementPlus)

app.mount('#app')