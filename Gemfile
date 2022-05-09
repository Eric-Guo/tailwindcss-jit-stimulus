source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.0"

gem "rails", "~> 7.0.3"

gem "mysql2"

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

# Use Puma as the app server
gem 'puma'
gem "shakapacker"
gem "turbo-rails"

gem "browser", require: "browser/browser"

gem 'kaminari'

gem 'rubyzip'

gem "http"
# bundle config local.wechat /Users/guochunzhong/git/oss/wechat/
gem 'wechat', git: 'https://gitee.com/Eric-Guo/wechat.git', branch: :main
gem "honeybadger"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

gem 'devise'
gem 'gitlab-omniauth-openid-connect', '~> 0.9.1', require: 'omniauth_openid_connect'
gem 'jwt'

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Call "debugger" anywhere in the code to stop execution and get a debugger console
  gem "debug"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  # bundle config local.web-console /Users/guochunzhong/git/oss/web-console
  gem "web-console"
  # Display speed badge on every html page with SQL times and flame graphs.
  # Note: Interferes with etag cache testing. Can be configured to work on production: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem "rack-mini-profiler", "~> 2.0"
  # Speed up rails commands in dev on slow machines / big apps. See: https://github.com/rails/spring
  # gem "spring"

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'rexml' # required by selenium-webdriver
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
