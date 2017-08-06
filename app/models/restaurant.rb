class Restaurant
  include Mongoid::Document

  DETAILS = {
    site: 'http://restaurant-amelia.ml',
    api_token: ENV['TELEGRAM_API_KEY'],
    table_size: 8
  }.freeze
end
