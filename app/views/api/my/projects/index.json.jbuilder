json.total @total
json.list @list do |project|
  json.id project.id
  json.cover project.record.show_cover
  json.project_id project.case_id
  json.record_id project.record.id
  json.status project.status
  json.status_title project.web_status_title
  json.project_name project.record.project_name
  json.is_th_str project.record.is_th_str
  json.show_project (['delegate_published', 'delegate_unpublishing', 'delegate_unpublished'].include?(project.status) && Cases.exists?(project.case_id))
end
