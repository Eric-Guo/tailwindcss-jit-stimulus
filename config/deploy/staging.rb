# frozen_string_literal: true

set :nginx_use_ssl, true
set :branch, :matlib
set :puma_service_unit_name, :puma_matlib_staging
set :puma_systemctl_user, :system

server 'thape_matlib', user: 'matlib_staging', roles: %w{app db web}
