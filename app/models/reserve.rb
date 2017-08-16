class Reserve
  include Mongoid::Document

  belongs_to :user, class_name: 'User', inverse_of: :reserves

  field :datetime, type: Time
  field :guests, type: Integer
  field :paid, type: Boolean, default: false
end
