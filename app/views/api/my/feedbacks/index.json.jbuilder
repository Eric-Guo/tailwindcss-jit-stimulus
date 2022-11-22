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

  json.partial! 'status', feedback: feedback

  if feedback.replies.present?
    json.replies feedback.replies do |reply|
      json.content reply.content
      json.created_at reply.created_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
