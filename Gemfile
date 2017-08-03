source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari-mongoid', '~> 1.0', '>= 1.0.1'
gem 'listen', '~> 3.0.5'
gem 'mongoid', '~> 6.1', '>= 6.1.1'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.4'
gem 'rails_admin', '~> 1.2'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails', '~> 3.1', '>= 3.1.2'
gem 'telegram-bot-ruby', '~> 0.8.2'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'awesome_print', '~> 1.7'
  gem 'better_errors', '~> 2.1', '>= 2.1.1'
  gem 'pry'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'

  # deploy

  gem 'capistrano',         '3.6.1', require: false
  gem 'capistrano-bundler', '1.2.0', require: false
  gem 'capistrano-rails',   '1.2.0', require: false
  gem 'capistrano-rvm',     '0.1.2', require: false
  gem 'capistrano3-puma',   '1.2.1', require: false
end

gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
