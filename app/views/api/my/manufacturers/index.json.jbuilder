json.total @total
json.list @list do |manufacturer|
  json.id manufacturer.id
  json.name manufacturer.name
  json.manufacturer_id manufacturer.manufacturer_id

  json.reason manufacturer.reason # 推荐理由

  json.partial! 'status', manufacturer: manufacturer

  if manufacturer.material.present?
    json.material do
      json.id manufacturer.material.id
      json.name manufacturer.material.name
    end
  end
  json.created_at manufacturer.created_at.strftime('%Y-%m-%d %H:%M:%S')
end
