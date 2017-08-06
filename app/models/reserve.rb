class Reserve
  include Mongoid::Document

  belongs_to :user, class_name: 'User', inverse_of: :reserves

  field :date, type: Date
  field :time, type: Time
  field :guests, type: Integer
end
