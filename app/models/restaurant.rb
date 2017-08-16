class Restaurant
  include Mongoid::Document

  field :title, type: String
  field :site, type: String
  field :reserve_price, type: Integer
  field :meta_description, type: String
  field :address, type: String
  field :api_token, type: String
  field :table_size, type: Integer
  field :table_count, type: Integer
  field :home_title_2, type: String
  field :home_description_2, type: String
  field :home_title_3, type: String
  field :home_description_3, type: String

  # Singleton object is required
  before_create 'self.class.destroy_all'

  def self.load
    first || (new.save; return self)
  end
  # end of singleton
end
