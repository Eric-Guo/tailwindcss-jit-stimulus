module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html+phone.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Montserrat', 'Source Han Sans', 'Source Han Sans SC', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei', 'sans-serif'],
      },
      screens: {
        '3xl': '1850px',
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
