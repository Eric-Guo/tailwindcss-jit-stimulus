# frozen_string_literal: true

class Demand < ApplicationRecord
  self.table_name = 'demands'

  default_scope { where(deleted_at: nil) }

  has_many :replies, class_name: 'DemandReply', foreign_key: :demand_id

  belongs_to :material, class_name: 'Material', foreign_key: :material_id

  def self.cates
    response = HTTP.get("http://172.17.1.48:8000/admin_api/demand_types")
    JSON.parse(response.body.to_s)['data'].map do |cate|
      {
        id: cate['id'],
        name: cate['name'],
        materials: cate['Lists'].map do |item|
          {
            id: item['Id'],
            name: item['Name'],
          }
        end
      }
    end
  end

  def self.upload_file(file)
    filename = file.original_filename
    response = HTTP.post("http://172.17.1.48:8000/admin_api/demand_files", form: {
      file: HTTP::FormData::File.new(file)
    })
    body = JSON.parse(response.body.to_s)
    file = body['data']['file']
    {
      name: filename,
      url: file['url'],
      tag: file['tag'],
    }
  end

  def self.submit(data, ip)
    response = HTTP.headers({
      'X-Forwarded-For': ip,
      'X-Real-IP': ip,
    }).post("http://172.17.1.48:8000/admin_api/demands", json: data)
    body = JSON.parse(response.body.to_s)
    {
      code: body['code'],
      msg: body['msg']
    }
  end

  def cate_name
    case demand_type
    when 1
      '品类'
    when 2
      '样品'
    when 3
      '项目/案例'
    when 4
      '供应商'
    else
      '未知'
    end
  end

  def references_json
    if references.present?
      if references.is_a?(Array)
        references.map { |item| item.with_indifferent_access }
      else
        JSON.parse(references).map { |item| item.with_indifferent_access }
      end
    else
      []
    end
  end
end
