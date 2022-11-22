status, status_title = if demand.resolved_at.present?
  [2, '已落实']
elsif demand.replies.present?
  [1, '跟进中']
else
  [0, '待回复']
end

json.status status
json.status_title status_title
