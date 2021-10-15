module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html+phone.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  corePlugins: {
    gap: true, // have to disable for wechat/qq browser, as it not supported yet.
  },
  theme: {
    extend: {
      fontFamily: {
        sans: ['Montserrat', 'Source Han Sans', 'Source Han Sans SC', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei', 'sans-serif'],
      },
      colors: {
        'black': '#101820',
        'black-6c': '#0F1820',
      },
      gap: {
        '18': '4.5rem',
      },
      screens: {
        '3xl': '1850px',
      },
      spacing: {
        '30': '7.5rem',
        '50': '12.5rem',
        '120': '30rem',
      },
      gridTemplateColumns: {
        // Simple 20 column grid
        '20': 'repeat(20, minmax(0, 1fr))',
      },
      visibility: ['hover','focus'],
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
