# config.ru

require 'sinatra/base'
require 'slim'

# share models and db
load 'config/shared.rb'

# controllers
class ApplicationController < Sinatra::Base
  set :views, File.expand_path('../views', __FILE__)

  not_found { slim :not_found }
end

Dir.glob('./controllers/*.rb').each { |file| require file }
map('/')      { run PublicController }
map('/admin') { run ProtectedController }
