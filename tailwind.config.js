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
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
