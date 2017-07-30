# config valid only for current version of Capistrano
lock '3.9.0'

set :application, 'restaurant-amelia'
set :repo_url, 'git@github.com:slenderock/restaurant-amelia.git'

set :deploy_to, '/home/deploy/apps/restaurant-amelia'

set :ssh_options,     forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub)
