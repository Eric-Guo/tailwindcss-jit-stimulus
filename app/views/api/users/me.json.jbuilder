json.id current_user.id
json.type 'user'
json.avatar user_image_url(current_user)
json.chinese_name current_user.chinese_name
json.position_title current_user.position_title
json.clerk_code current_user.clerk_code

permissions = []
# 访客邀请管理权限
if Visitor.user_auth?(current_user)
  permissions.push('visitor_manage')
end
json.permissions permissions
