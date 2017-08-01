class Restaurant
  include Mongoid::Document

  DETAILS = {
    site: 'restaurant-amelia.ml',
    api_token: ENV['TELEGRAM_API_KEY'],
    table_size: 8
  }.freeze
end
