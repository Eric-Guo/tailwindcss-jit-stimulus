# frozen_string_literal: true

class User < ActiveRecord::Base
  establish_connection :user_info
  devise :database_authenticatable

  has_many :department_users, dependent: :destroy
  has_many :departments, through: :department_users

  has_many :position_users, -> { order(main_position: :desc) }, dependent: :destroy
  has_many :positions, through: :position_users

  # 主职
  def main_position
    @_main_position ||= positions.where(position_users: { main_position: true }).first
  end

  # 主职岗位级别
  def main_position_level
    @_main_position_level ||= main_position&.post_level.to_i
  end

  # 是否是超级员工
  def super_staff?
    SuperStaff.where(clerk_code: clerk_code).exists?
  end

  # 是否属于建筑岗位线
  def architecture?
    main_position.present? && Position.architecture?(main_position.b_postcode)
  end

  # 是否显示项目相关文件
  def show_project_relevant_document?
    super_staff? || (architecture? && main_position_level > 8)
  end

  # 案例文件下载次数限制
  def project_file_download_limit
    return 9999 if super_staff?
    return 0 unless architecture?

    if main_position_level > 11
      9999
    elsif main_position_level >= 9
      3
    else
      0
    end
  end
end
