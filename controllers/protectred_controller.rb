class ProtectedController < ApplicationController
  use Rack::Auth::Basic, 'Protected Area' do |username, password|
    username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
  end

  get '/' do
    slim :admin
  end
end
