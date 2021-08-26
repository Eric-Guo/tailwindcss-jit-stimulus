source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.1"
gem "rbs", "< 4.2" # require by Ruby 3.2
gem "parallel", "< 2.0"

gem "rails", "~> 7.2.3.1"
gem "minitest", "< 6" # rails 7.2 not support minitest 6.0.1

# Use sqlite3 as the database for Active Record
gem "sqlite3"
# Use Puma as the app server
gem 'puma'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "shakapacker", "~> 8.4.0"
gem "rack-proxy", "~> 0.8" # after shakapacker v10.3.2 can remove this line
gem "turbo-rails"

gem "browser", "< 6", require: "browser/browser" # support ruby 3.0

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

group :development, :test do
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

  gem 'tidewave'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # Selenium Manager handles browser drivers without the webdrivers gem.
  gem "selenium-webdriver", "~> 4.26.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
