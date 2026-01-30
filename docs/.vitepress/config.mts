import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "StitchTV",
  description: "一款简约而不简单的 Android TV 直播应用。",
  appearance: 'dark',
  themeConfig: {
    logo: '/logo.png',
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Downloads', link: 'https://github.com/GutsGo/simple_live/releases' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/GutsGo/simple_live' }
    ],

    footer: {
      message: '基于 MIT 许可发布',
      copyright: '版权所有 © 2026-至今 StitchTV Team'
    }
  }
})
