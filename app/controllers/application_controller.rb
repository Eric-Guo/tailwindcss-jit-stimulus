class ApplicationController < ActionController::Base
  include DetectDevice
  before_action :set_ie_warning
  before_action :set_sidebar_nav

  private

    def set_ie_warning
      if @browser.ie?
        flash.now[:alert] = "本站点必须在Chrome, Edge, Firefox等非IE浏览器下浏览，Chrome浏览器可以从<a href='https://www.google.cn/intl/zh-CN/chrome/'>https://www.google.cn/intl/zh-CN/chrome/</a>下载。".html_safe
      end
    end

    def set_sidebar_nav
      @sidebar_nav = [
        {
          title: '材料',
          subtitle: 'Materials',
          children: [
            {
              title: '石材',
              subtitle: 'Stone',
              children: [
                {
                  title: '石灰石/青石',
                  subtitle: 'Limestone',
                  url: '',
                },
                {
                  title: '大理石',
                  subtitle: 'Marble',
                  url: '',
                }
              ]
            },
            {
              title: '玻璃',
              subtitle: 'Glass',
              children: [
                {
                  title: '超白透明色玻璃基片',
                  subtitle: '',
                  url: '',
                },
                {
                  title: '磨砂双星玻璃砖',
                  subtitle: '',
                  url: '',
                },
              ]
            }
          ]
        },
        {
          title: '案例',
          subtitle: 'Projects',
          url: '',
        },
        {
          title: '供应商',
          subtitle: 'Manufacturer',
          url: '',
        },
        {
          title: '需求登记',
          subtitle: 'Your Demand',
          url: '',
        }
      ]
    end
end
