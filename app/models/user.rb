class User
  include Mongoid::Document
  include Mongoid::Enum

  field :name, type: String
  field :phone, type: String
  field :locale, type: Integer, default: 0

  enum :locale, %i[russian english]

  has_many :reserves, class_name: 'Reserve', inverse_of: :user
end
