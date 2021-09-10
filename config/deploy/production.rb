# frozen_string_literal: true

set :nginx_use_ssl, true
set :branch, :layout
set :puma_service_unit_name, :puma_matlib
set :puma_systemctl_user, :system

server "thape_matlib", user: "matlib", roles: %w{app db web}
