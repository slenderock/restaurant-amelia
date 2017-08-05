class Client
  include Mongoid::Document

  field :name, type: String

  has_many :reserves, class_name: 'Reserve', inverse_of: :client
end
