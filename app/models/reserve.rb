class Reserve
  include Mongoid::Document

  belongs_to :client_name, class_name: 'Client', inverse_of: :reserves

  field :date, type: Date
  field :time, type: Time
  field :guests, type: Integer
  # field :client_id, type: String
end
