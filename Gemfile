source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.0"

gem "rails", "~> 7.0.8"

gem "mysql2"

# Use Puma as the app server
gem 'puma'
gem "shakapacker"

# https://github.com/hotwired/turbo-rails/pull/335/files
gem "turbo-rails", '= 1.1.0' # need lock to make cookie works.

gem "browser", "< 6", require: "browser/browser" # support ruby 3.0

gem 'kaminari'

gem 'rubyzip'

gem "http"
# bundle config local.wechat /Users/guochunzhong/git/oss/wechat/
gem 'wechat', git: 'https://git.thape.com.cn/Eric-Guo/wechat.git', branch: :main
gem "honeybadger"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

gem 'devise'
gem 'omniauth_openid_connect'
gem 'omniauth', '~> 1.9' # lock above omniauth version
gem 'jwt'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

# markdown
gem 'redcarpet'
gem 'coderay'

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
  gem 'capistrano3-puma', '~> 5.2.0'

  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.39'
  gem 'selenium-webdriver', '>= 4.14.0'
  gem 'rexml' # required by selenium-webdriver
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
