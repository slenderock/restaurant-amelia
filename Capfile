require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/passenger'
require 'capistrano/scm/git'
require 'capistrano/rvm'
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
