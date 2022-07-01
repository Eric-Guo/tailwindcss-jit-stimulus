# frozen_string_literal: true

class Position < ActiveRecord::Base
  establish_connection :user_info

  belongs_to :department, optional: true

  # 通过岗位编码判断是否是建筑岗位
  def self.architecture?(code)
    ArchitecturePosition.where(code: code).exists?
  end

  # 判断当前岗位是否是建筑岗位
  def architecture?
    Position.architecture?(b_postcode);
  end
end
