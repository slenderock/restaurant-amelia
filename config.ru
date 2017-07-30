# config.ru

require 'sinatra/base'
require 'slim'
require 'dotenv/load'

# require 'mongoid'
# Mongoid.load!('db/mongoid.yml', :production)

class ApplicationController < Sinatra::Base
  set :views, File.expand_path('../views', __FILE__)

  not_found { slim :not_found }
end

Dir.glob('./{models,controllers}/*.rb').each { |file| require file }


map('/')      { run PublicController }
map('/admin') { run ProtectedController }
