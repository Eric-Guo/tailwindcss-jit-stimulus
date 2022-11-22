json.id @feedback.id
json.created_at @feedback.created_at&.strftime('%Y-%m-%d %H:%M:%S')
json.question_type_names @feedback.question_types.pluck(:name)
json.opinion @feedback.opinion

if @feedback.manufacturer.present?
  json.manufacturer do
    json.id @feedback.manufacturer.id
    json.name @feedback.manufacturer.name
  end
end

json.partial! 'status', feedback: @feedback

if @feedback.replies.present?
  json.replies @feedback.replies do |reply|
    json.content reply.content
    json.created_at reply.created_at&.strftime('%Y-%m-%d %H:%M:%S')
  end
end

json.screenshot_path mat_img_url(@feedback.screenshot_path)

if @feedback.references_json.present?
  json.references @feedback.references_json do |item|
    json.name item[:name]
    json.path mat_img_url(item[:path])
  end
end
