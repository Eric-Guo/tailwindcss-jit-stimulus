json.total @total
json.list @list do |project|
  json.id project.id
  json.name project.project_name
  json.cover mat_img_url(project.web_cover)
  json.location project.project_location
  json.design_unit project.design_unit
  json.is_th_str project.is_th_str
end
