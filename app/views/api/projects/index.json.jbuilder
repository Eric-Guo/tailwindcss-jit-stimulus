json.total @total
json.list @list do |project|
  json.id project.id
  json.no project.no
  json.name project.project_name
  json.cover mat_img_url(project.web_cover)
  json.location project.project_location
  json.is_th project.is_th
  json.is_th_str project.is_th_str
  json.business_type project.business_type
  json.project_type project.project_type
  json.material_tags project.material_tags
end
