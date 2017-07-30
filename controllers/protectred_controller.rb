class ProtectedController < ApplicationController
  use Rack::Auth::Basic, 'Protected Area' do |username, password|
    username == 'foo' && password == 'bar'
  end

  get '/' do
    slim :admin
  end
end
