json.id @demand.id
json.cate_name @demand.cate_name
json.material_name @demand.material&.name
json.description @demand.description
json.created_at @demand.created_at&.strftime('%Y-%m-%d %H:%M:%S')

json.references @demand.references_json do |item|
  json.name item[:name]
  json.path mat_img_url(item[:path])
end
json.resolved_at @demand.resolved_at
json.replies @demand.replies do |reply|
  json.content reply.content
  json.created_at reply.created_at&.strftime('%Y-%m-%d %H:%M:%S')
end

json.partial! 'status', demand: @demand
