class Restaurant
  include Mongoid::Document

  DETAILS = {
    site: 'http://restaurant-amelia.ml',
    address: 'Cherkassy',
    google_map_key: ENV['GOOGLE_MAP_KEY'],
    api_token: ENV['TELEGRAM_API_KEY'],
    table_size: 8
  }.freeze
end
