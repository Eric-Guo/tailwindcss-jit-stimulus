json.id @manufacturer.id
json.name @manufacturer.name

if @manufacturer.material.present?
  json.material do
    json.id @manufacturer.material.id
    json.name @manufacturer.material.name
  end
end

json.contact_name @manufacturer.contact_name # 联系人
json.contact_tel @manufacturer.contact_tel # 联系电话
json.reason @manufacturer.reason # 推荐理由

json.is_th_co @manufacturer.is_th_co
json.is_th_co_text @manufacturer.is_th_co_text

json.projects @manufacturer.cases do |project|
  json.id project.id
  json.type_id project.type_id
  if project.type_id == 'pm'
    json.no project.no
    json.pm_project_name project.pm_project_name
    json.status 6
    json.status_text '内部'
  else
    json.status 7
    json.status_text '外部'
  end
  json.name project.name
  json.livePhotos project.live_photos do |photo|
    json.id photo.id
    json.title photo.title
    json.url mat_img_url(photo.path)
  end
end

json.partial! 'status', manufacturer: @manufacturer
