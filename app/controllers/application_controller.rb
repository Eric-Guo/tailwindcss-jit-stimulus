# frozen_string_literal: true

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
      materials = Material.where(level: [1, 2]).all
      @sidebar_nav = [
        {
          title: '材料',
          subtitle: 'Materials',
          children: materials.select do |item|
            item.level == 1
          end.map do |item|
            {
              id: item.id,
              title: item.name,
              subtitle: item.en_name,
              children: materials.select do |it|
                it.level == 2 && item.id == it.parent_id
              end.map do |it|
                {
                  id: it.id,
                  title: it.name,
                  subtitle: it.en_name,
                  url: material_path(it.id),
                }
              end
            }
          end
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
