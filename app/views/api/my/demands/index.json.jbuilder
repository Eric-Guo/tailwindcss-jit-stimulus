json.total @total
json.list @list do |demand|
  json.id demand.id
  json.cate_name demand.cate_name
  json.material_name demand.material&.name
  json.description demand.description
  json.created_at demand.created_at&.strftime('%Y-%m-%d %H:%M:%S')

  json.references demand.references_json do |item|
    json.name item[:name]
    json.path mat_img_url(item[:path])
  end

  json.resolved_at demand.resolved_at

  json.replies demand.replies do |reply|
    json.content reply.content
    json.created_at reply.created_at&.strftime('%Y-%m-%d %H:%M:%S')
  end

  status, status_title = if demand.resolved_at.present?
    [2, '已落实']
  elsif demand.replies.present?
    [1, '跟进中']
  else
    [0, '待回复']
  end

  json.status status
  json.status_title status_title
end
