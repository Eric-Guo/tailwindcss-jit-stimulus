json.total @total
json.list @list do |visitor|
  json.id visitor.id
  json.code visitor.code
  json.invitation_url visitor_login_url(visitor.code)
  json.remark visitor.remark
  json.expired_at visitor.expired_at&.strftime('%Y-%m-%d')
  json.created_at visitor.created_at&.strftime('%Y-%m-%d')
  json.effective visitor.effective?
end
