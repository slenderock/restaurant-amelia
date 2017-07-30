class PublicController < ApplicationController
  get '/' do
    slim :home
  end
end
