source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '~> 2.3.0'
gem 'rails', '~> 5.1.6'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'bootstrap-sass'
gem 'carrierwave', '~> 1.0'
gem 'devise'
gem 'draper'
# gem 'ecomm', github: 'evtik/ecomm', branch: 'develop'
gem 'ecomm', path: '~/projects/ecomm'
gem 'faker'
gem 'fog-aws'
gem 'font-awesome-rails'
gem 'hamlit'
gem 'hamlit-rails'
gem 'jquery-rails'
gem 'mini_magick'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'rectify'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'rack_session_access'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
  gem 'wisper-rspec', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
