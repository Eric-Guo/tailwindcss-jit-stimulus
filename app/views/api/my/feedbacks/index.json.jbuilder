json.total @total
json.list @list do |feedback|
  json.id feedback.id
  json.created_at feedback.created_at&.strftime('%Y-%m-%d %H:%M:%S')
  json.question_type_names feedback.question_types.pluck(:name)
  json.opinion feedback.opinion

  if feedback.manufacturer.present?
    json.manufacturer do
      json.id feedback.manufacturer.id
      json.name feedback.manufacturer.name
    end
  end

  status, status_title = if feedback.resolved_at.present?
    [2, '已落实']
  elsif feedback.replies.present?
    [1, '跟进中']
  else
    [0, '待回复']
  end

  json.status status
  json.status_title status_title

  if feedback.replies.present?
    json.replies feedback.replies do |reply|
      json.content reply.content
      json.created_at reply.created_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
