json.total @total
json.list @list do |message|
  json.id message.id
  json.avatar message.format_data&.fetch(:fromUser, {})&.fetch(:headerImg, '')
  json.title message.format_data&.fetch(:subject, '')
  json.content message.msg&.gsub(/\[(.*)\]\((.*)\)/, '<a class="underline text-blue-400" href="\2" target="_blank">\1</a>').html_safe
  json.created_at Time.parse(message.format_data&.fetch(:DateTime, '')).strftime('%Y-%m-%d %H:%M:%S')
  json.read_at message.read_at

  replies = message.format_data&.fetch(:demands, {})&.fetch(:DemandReplies, [])&.reverse()
  if replies.present?
    json.replies replies do |reply|
      json.content reply[:content]
      json.created_at Time.parse(reply[:CreatedAt]).strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
