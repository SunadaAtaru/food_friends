source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '3.1.2'
# ruby '3.0.3'
ruby '3.1.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
# gem 'concurrent-ruby', '1.3.4'
gem 'concurrent-ruby', '1.3.4'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'carrierwave'
gem 'devise'
gem 'jbuilder', '~> 2.7'
gem 'logger', '1.6.5'
# gem 'logger', '~> 1.5.1'
gem 'ransack'
# gem 'carrierwave'
gem 'mini_magick', '~> 4.11.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
# gem 'rails', '~> 6.1.4.6'
gem 'rails', '~> 6.1.7.6'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
# gem 'webpacker', '~> 5.0'
gem 'webpacker', '~> 5.4.4' # または
# Gemfile
gem 'will_paginate', '~> 3.3'
# または
gem 'kaminari', '~> 1.2'
# Gemfile
gem 'will_paginate-bootstrap4'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'rspec-rails'
  gem 'faker'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web' # Web UIでメールを確認できる
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby-lsp', require: false
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
