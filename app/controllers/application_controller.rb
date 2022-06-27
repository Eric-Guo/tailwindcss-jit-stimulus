# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DetectDevice
  wechat_api
  before_action :login_in_as_dev_user, if: -> { Rails.env.development? }
  before_action :make_sure_wechat_user_login_in_phone, if: -> { request.variant.any?(:phone) }
  before_action :set_ie_warning
  before_action :set_tree_materials
  before_action :set_sidebar_nav
  before_action :set_footer_info
  after_action :record_user_view_history, if: -> { Rails.env.production? }

  protected

    def q_return_mat_ids(q)
      mat_2_level_ids = Material.where(level: 2).joins(:parent_material, :children_materials)
        .where(parent_material: { name: q })
        .pluck('children_materials_materials.id')
      mat_3_level_ids = Material.where(level: [1, 2, 3]).where('name LIKE ?', "%#{q}%").pluck(:id)
      if mat_2_level_ids.present? || mat_3_level_ids.present?
        (mat_2_level_ids + [nil] + mat_3_level_ids).uniq
      end
    end

  private

    def login_in_as_dev_user
      sign_in User.where('clerk_code = ?', '019795').first unless user_signed_in?
    end

    def make_sure_wechat_user_login_in_phone
      wechat_oauth2 do |user_name|
        return redirect_to root_path if user_name.blank?

        Rails.logger.info "make_sure_wechat_user_login_in_phone: #{user_name}"
        Current.user = User.find_by wecom_id: user_name
        Current.user = User.find_by email: "#{user_name}@thape.com.cn" if Current.user.blank?
        if Current.user.present?
          sign_in Current.user
        else
          return redirect_to root_path
        end
      end unless current_user.present? || request.path == '/'
    end

    def record_user_view_history
      ReportViewHistory.create(controller_name: controller_path, action_name: action_name,
        clerk_code: current_user&.clerk_code, request_path: request.fullpath)
    end

    def set_ie_warning
      if @browser.ie?
        flash.now[:alert] = "本站点必须在Chrome, Edge, Firefox等非IE浏览器下浏览，Chrome浏览器可以从<a href='https://www.google.cn/intl/zh-CN/chrome/'>https://www.google.cn/intl/zh-CN/chrome/</a>下载。".html_safe
      end
    end

    def tree_materials(materials, parent_id = 0)
      materials.select { |item| item.parent_id == parent_id }.map do |item|
        {
          id: item.id,
          title: item.name,
          subtitle: item.en_name,
          children: tree_materials(materials, item.id),
          descendant_ids: material_descendants(materials, item).pluck(:id)
        }
      end
    end

    def material_descendants(materials, material)
      case material.level
      when 1
        materials.select { |item| item.grandpa_id == material.id }
      when 2
        materials.select { |item| item.parent_id == material.id }
      else
        []
      end
    end

    def set_tree_materials
      materials = Material.where(level: [1, 2, 3]).all
      @tree_materials = tree_materials(materials)
    end

    def set_sidebar_nav
      @sidebar_nav = [
        {
          title: '材料',
          subtitle: 'Materials',
          url: materials_path,
          children: @tree_materials.map do |item|
            { **item, children: item[:children].map { |it| { **it, url: material_path(it[:id]), children: nil } } }
          end,
        },
        {
          title: '案例',
          subtitle: 'Projects',
          url: projects_path,
        },
        {
          title: '供应商',
          subtitle: 'Manufacturer',
          url: manufacturers_path,
        },
        {
          title: '新闻',
          subtitle: 'News',
          url: news_index_path,
        },
      ]
    end

    def set_footer_info
      @footer_info = {
        phone_number: '64281588-8914',
        email: 'architectonic@thape.com.cn',
        links: [
          { title: '建筑委', url: 'http://jzw.thape.com.cn/' },
          { title: '材料在线', url: 'http://www.clzx.net/' },
          { title: '阿奇找找', url: 'https://www.archifound.com/#/' },
        ],
      }
    end
end
