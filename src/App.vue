<script setup lang="ts">
import { ref, onMounted } from 'vue'

const hero = {
  name: "乱炖直播",
  text: "全能直播播放器",
  tagline: "深耕多端开发，诚意打造出品。聚合全网直播资源，智能识别频道，无需复杂配置，极致流畅播放，优雅打造您的私人大屏影院。",
  image: {
    src: "/images/hero_mockup.webp",
    alt: "StitchTV Multi-device Mockup"
  },
  actions: [
    { theme: 'brand', text: 'Android TV 下载', link: 'https://github.com/GutsGo/stitch_tv/releases' },
    { theme: 'alt', text: 'GitHub 项目', link: 'https://github.com/GutsGo/stitch_tv' }
  ]
}

const features = [
  { title: 'Android', icon: '/images/device-Android.png', details: 'Support for Android phones.' },
  { title: 'Android TV', icon: '/images/device-AndroidTV.png', details: 'Optimized for the big screen.', link: 'https://github.com/GutsGo/stitchtv/releases' },
  { title: 'macOS', icon: '/images/device-macOS.png', details: 'Desktop playback supported.' },
  { title: 'iOS', icon: '/images/device-Apple.png', details: 'Support for iPhone and iPad.', badge: '即将推出' },
  { title: 'Apple TV', icon: '/images/device-tvOS.png', details: 'Native tvOS experience.', badge: '即将推出' },
  { title: 'Windows', icon: '/images/device-Windows.png', details: 'Windows app available soon.', badge: '即将推出' }
]

const highlights = [
  { emoji: '⚡️', title: '极致流畅', details: '深度优化，在低配置 Android TV 盒子上也能保持完美的流畅运行体验。' },
  { emoji: '📺', title: '多源集成', details: '聚合多家主流直播平台，无需切换应用，一个 APP 搞定所有直播内容。' },
  { emoji: '🎮', title: '原生交互', details: '专为遥控器设计的焦点系统，大屏操作得心应手，符合人体工程学。' },
  { emoji: '🚀', title: '科技美学', details: '采用深色科技风格设计，玻璃拟态 UI，让您的电视瞬间焕发未来感。' }
]

const mainAction = ref(hero.actions[0])
const isDark = ref(true)
const config = ref<any>(null)
const showDownloadModal = ref(false)
const currentPlatform = ref('')

const getPlatformKey = (title: string) => {
  const map: Record<string, string> = {
    'Android TV': 'androidTV',
    'macOS': 'macOS',
    'Apple TV': 'appleTV'
  }
  return map[title] || title.toLowerCase()
}

const fetchConfig = async () => {
  try {
    const isDev = import.meta.env.DEV
    const configUrl = isDev 
      ? '/assets/config.json' 
      : 'https://v6.gh-proxy.org/https://raw.githubusercontent.com/GutsGo/stitch_tv/dev/public/assets/config.json'
    
    const response = await fetch(configUrl)
    config.value = await response.json()
    updateFeatures()
  } catch (error) {
    console.error('获取配置失败:', error)
  }
}

const updateFeatures = () => {
  if (!config.value) return
  
  features.forEach(feature => {
    const platformKey = getPlatformKey(feature.title)
    const link = config.value.platforms[platformKey]
    
    if (!link) {
      feature.badge = '即将推出'
      delete feature.link
    } else {
      feature.badge = undefined
      feature.link = '#' // 标记为可点击，具体逻辑在 handleDownload 处理
    }
  })
}

const handleDownload = (platform: string) => {
  const platformKey = getPlatformKey(platform)
  const linkTemplate = config.value?.platforms[platformKey]
  
  if (!linkTemplate) return

  if (platformKey === 'android' || platformKey === 'androidTV') {
    currentPlatform.value = platform
    showDownloadModal.value = true
    return
  }

  doDownload(platformKey, linkTemplate)
}

const selectArchAndDownload = (arch: string) => {
  const platformKey = getPlatformKey(currentPlatform.value)
  const linkTemplate = config.value?.platforms[platformKey]
  const link = linkTemplate.replace('$arch', arch)
  
  doDownload(platformKey, link)
  showDownloadModal.value = false
}

const doDownload = (platform: string, path: string) => {
  const url = config.value.baseURL + path
  const a = document.createElement('a')
  a.href = url
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
}

const toggleTheme = () => {
  isDark.value = !isDark.value
  updateTheme()
}

const updateTheme = () => {
  if (isDark.value) {
    document.documentElement.classList.add('dark')
    localStorage.setItem('theme', 'dark')
  } else {
    document.documentElement.classList.remove('dark')
    localStorage.setItem('theme', 'light')
  }
}

onMounted(async () => {
  await fetchConfig()
  
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  } else {
    isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
  }
  updateTheme()

  const ua = navigator.userAgent.toLowerCase()
  if (ua.includes('macintosh') || ua.includes('mac os x')) {
    mainAction.value.text = 'macOS 下载'
  } else if (ua.includes('android')) {
    mainAction.value.text = 'Android 下载'
  } else {
    mainAction.value.text = 'Android TV 下载'
  }
})
</script>

<template>
  <div class="layout">
    <header class="nav glass-effect">
      <div class="container nav-container">
        <div class="logo">
          <img src="/images/logo.png" alt="Logo" />
          <span>{{ hero.name }}</span>
        </div>
        <div class="nav-actions">
          <button @click="toggleTheme" class="theme-toggle" :title="isDark ? '切换到亮色模式' : '切换到暗色模式'">
            <svg v-if="isDark" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
          </button>
        </div>
      </div>
    </header>

    <main>
      <!-- Hero Section -->
      <section class="hero">
        <div class="container hero-container">
          <div class="hero-content">
            <h1 class="hero-name">{{ hero.name }}</h1>
            <p class="hero-text">{{ hero.text }}</p>
            <p class="hero-tagline">{{ hero.tagline }}</p>
            <div class="hero-actions">
              <a 
                v-for="action in hero.actions" 
                :key="action.text"
                :href="action.link"
                target="_blank"
                rel="noopener noreferrer"
                :class="['btn', `btn-${action.theme}`]"
                @click="action.theme === 'brand' ? (handleDownload(mainAction.text.replace(' 下载', '')), $event.preventDefault()) : null"
              >
                {{ action === hero.actions[0] ? mainAction.text : action.text }}
              </a>
            </div>
          </div>
          <div class="hero-image">
            <img :src="hero.image.src" :alt="hero.image.alt" />
          </div>
        </div>
      </section>

      <!-- Features Section -->
      <section class="features">
        <div class="container">
          <div class="features-grid">
            <div 
              v-for="feature in features" 
              :key="feature.title"
              class="feature-card glass-effect"
              @click="!feature.badge ? handleDownload(feature.title) : null"
            >
              <div v-if="feature.badge" class="badge">{{ feature.badge }}</div>
              <div class="feature-icon">
                <img :feature="feature.icon" :src="feature.icon" :alt="feature.title" width="48" height="48" />
              </div>
              <h3 class="feature-title">{{ feature.title }}</h3>
            </div>
          </div>
        </div>
      </section>

      <!-- Highlights Section -->
      <section class="highlights">
        <div class="container">
          <div class="highlights-grid">
            <div 
              v-for="item in highlights" 
              :key="item.title"
              class="highlight-card glass-effect"
            >
              <div class="highlight-icon-wrapper">
                <span class="highlight-emoji">{{ item.emoji }}</span>
              </div>
              <h3 class="highlight-title">{{ item.title }}</h3>
              <p class="highlight-details">{{ item.details }}</p>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Download Modal -->
    <div v-if="showDownloadModal" class="modal-overlay" @click="showDownloadModal = false">
      <div class="modal-content glass-effect" @click.stop>
        <h2 class="modal-title">选择 {{ currentPlatform }} 架构</h2>
        <div class="arch-list">
          <div 
            v-for="arch in config?.androidArchs" 
            :key="arch" 
            class="arch-item"
            @click="selectArchAndDownload(arch)"
          >
            <span class="arch-name">{{ arch }}</span>
            <span v-if="arch === 'arm64-v8a'" class="recommend-badge">推荐</span>
          </div>
        </div>
        <button class="modal-close" @click="showDownloadModal = false">取消</button>
      </div>
    </div>

    <footer class="footer">
      <div class="container">
        <p>&copy; 2026 {{ hero.name }}. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.layout {
  display: flex;
  flex-direction: column;
}

.container {
  max-width: 1152px;
  margin: 0 auto;
  padding: 0 24px;
}

/* Nav */
.nav {
  position: sticky;
  top: 0;
  z-index: 100;
  padding: 16px 0;
  margin: 12px 24px;
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 1.2rem;
  font-weight: bold;
}

.logo img {
  height: 32px;
}

.nav-actions {
  display: flex;
  align-items: center;
}

.theme-toggle {
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
  color: var(--vp-c-text-2);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: background-color 0.2s, color 0.2s;
}

.theme-toggle:hover {
  background-color: var(--vp-c-bg-mute);
  color: var(--vp-c-brand);
}

/* Hero */
.hero {
  padding: 64px 0;
}

.hero-container {
  display: flex;
  align-items: center;
  gap: 48px;
}

.hero-content {
  flex: 1;
}

.hero-name {
  font-size: 3.5rem;
  font-weight: 800;
  line-height: 1.1;
  background: linear-gradient(135deg, var(--vp-c-brand) 0%, #a8ff78 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 8px;
}

.hero-text {
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 24px;
  color: var(--vp-c-text-1);
}

.hero-tagline {
  font-size: 1.2rem;
  color: var(--vp-c-text-2);
  margin-bottom: 32px;
  max-width: 500px;
}

.hero-actions {
  display: flex;
  gap: 12px;
}

.btn {
  padding: 12px 24px;
  border-radius: 20px;
  font-weight: 600;
  transition: transform 0.2s;
}

.btn:hover {
  transform: translateY(-2px);
}

.btn-brand {
  background-color: var(--vp-c-brand);
  color: white;
}

.btn-alt {
  background-color: var(--vp-c-bg-mute);
  color: var(--vp-c-text-1);
}

.hero-image {
  flex: 1;
  display: flex;
  justify-content: center;
}

.hero-image img {
  max-width: 100%;
  border-radius: 24px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
}

/* Features */
.features {
  padding: 64px 0;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.feature-card {
  position: relative;
  padding: 32px 24px;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
  overflow: hidden;
}

.badge {
  position: absolute;
  top: 10px;
  right: -30px;
  background: linear-gradient(135deg, var(--vp-c-brand) 0%, #a8ff78 100%);
  color: white;
  font-size: 10px;
  font-weight: bold;
  padding: 4px 35px;
  transform: rotate(45deg);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  white-space: nowrap;
}

.dark .badge {
  color: #1b1b1f;
  background: linear-gradient(135deg, #a8ff78 0%, var(--vp-c-brand) 100%);
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
  border-color: var(--vp-c-brand);
}

.feature-icon {
  margin-bottom: 20px;
  display: flex;
  justify-content: center;
}

.feature-title {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0;
  color: var(--vp-c-text-1);
}

/* Highlights */
.highlights {
  padding: 64px 0 128px;
}

.highlights-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 24px;
}

.highlight-card {
  padding: 32px;
  text-align: center;
}

.highlight-icon-wrapper {
  margin-bottom: 20px;
}

.highlight-emoji {
  font-size: 2.5rem;
}

.highlight-title {
  font-size: 1.5rem;
  margin-bottom: 12px;
}

.highlight-details {
  color: var(--vp-c-text-2);
}

.footer {
  padding: 48px 0;
  border-top: 1px solid var(--vp-c-bg-mute);
  text-align: center;
  color: var(--vp-c-text-3);
}

@media (max-width: 768px) {
  .hero-container {
    flex-direction: column;
    text-align: center;
  }
  
  .hero-name, .hero-text {
    font-size: 2.5rem;
  }
  
  .hero-tagline {
    margin: 0 auto 32px;
  }
  
  .hero-actions {
    justify-content: center;
  }

  .features-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .feature-card {
    flex-direction: row;
    justify-content: flex-start;
    align-items: center;
    padding: 16px 12px;
    text-align: left;
  }

  .feature-icon {
    margin-bottom: 0;
    margin-right: 12px;
    flex-shrink: 0;
  }

  .feature-icon img {
    width: 32px;
    height: 32px;
  }

  .feature-title {
    font-size: 0.95rem;
    margin-top: 0;
  }

  .badge {
    top: 5px;
    right: -35px;
    font-size: 8px;
    padding: 2px 35px;
  }
}
</style>
