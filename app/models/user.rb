class User
  include Mongoid::Document

  field :name, type: String
  field :phone, type: String
  field :chat_id, type: String
  field :action, type: String
  has_many :reserves, class_name: 'Reserve', inverse_of: :user

  def load_reserve
    reserves.last || reserves.create
  end
end
