class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_restaurant

  def set_restaurant
    @restaurant ||= Restaurant.load
  end
end
