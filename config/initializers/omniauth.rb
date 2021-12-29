# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  issuer = if Rails.env.development?
    'https://matlib.test/'
  else
    'https://sso.thape.com.cn'
  end

  host = if Rails.env.development?
    'matlib.test'
  else
    'sso.thape.com.cn'
  end

  redirect_uri = if Rails.env.development?
    'https://matlib.test/auth/openid_connect/callback'
  else
    'https://cybros.thape.com.cn/auth/openid_connect/callback'
  end

  provider :openid_connect,
           name: :openid_connect,
           scope: %i[openid main_position clerk_code chinese_name phone],
           response_type: :code,
           uid_field: 'email',
           nonce: false,
           issuer: issuer,
           client_signing_alg: :RS256,
           client_jwk_signing_key: '{"keys":[{"kty":"RSA","kid":"LqqRQA72LVnbtET__DuG_LdzdB1U31dBdJORWdB96tI","e":"AQAB","n":"uuqxOPaceNE5NubPcf2iN3rPuOHjeOyFd5Djpade3njJePcLKW3SW-FI61QPsLa9zg4GrFYmAuxzZoISohtNBjv4vIRC0ocrsUfpOWZKbTvhHjBJp725azc2cOMcgIOgjG8mM4nQIeUYQNeX40b3XwAEVBIo22OXvO7vmHQzjlswWsY54iEM4gWeNt3O7M4o37IGOQDFKV7muJxeoAnU7caZfZy1aa5-3mMcJa2xryukC45tmOy_76tLqm0Ig3BDoPVDiHbFDtU5GzLXI2CbyDWnB-S0a-cU7HFGJX7qiYZxrTjBcI2nf98Ljb8ZN1AeLUq5NcpOTE_BCvJ-zyc-sw","use":"sig","alg":"RS256"}]}',
           client_options: {
             scheme: 'https',
             host: host,
             identifier: Rails.application.credentials.openid_connect_identifier!,
             secret: Rails.application.credentials.openid_connect_secret!,
             redirect_uri: redirect_uri,
             authorization_endpoint: '/oauth/authorize',
             token_endpoint: '/oauth/token',
             userinfo_endpoint: '/oauth/userinfo',
             jwks_uri: '/oauth/discovery/keys'
           }
end
