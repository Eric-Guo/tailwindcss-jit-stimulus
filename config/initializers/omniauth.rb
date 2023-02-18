# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  issuer = if Rails.env.development?
    'https://oauth2id.test/'
  else
    'https://sso.thape.com.cn'
  end

  redirect_uri = if Rails.env.development?
    'https://matlib.test/auth/openid_connect/callback'
  elsif ENV['REAL_RAILS_ENV'] == 'staging'
    'https://m-thtri-staging.thape.com.cn/auth/openid_connect/callback'
  else
    'https://m-thtri.thape.com.cn/auth/openid_connect/callback'
  end

  openid_connect_identifier = if ENV['REAL_RAILS_ENV'] == 'staging'
    Rails.application.credentials.staging_connect_identifier
  else
    Rails.application.credentials.openid_connect_identifier
  end

  openid_connect_secret = if ENV['REAL_RAILS_ENV'] == 'staging'
    Rails.application.credentials.staging_connect_secret
  else
    Rails.application.credentials.openid_connect_secret
  end

  provider :openid_connect,
           name: :openid_connect,
           scope: %i[openid main_position clerk_code chinese_name phone],
           response_type: :code,
           uid_field: 'email',
           issuer: issuer,
           client_auth_method: 'query',
           discovery: true,
           client_options: {
             identifier: openid_connect_identifier,
             secret: openid_connect_secret,
             redirect_uri: redirect_uri
           }
end
