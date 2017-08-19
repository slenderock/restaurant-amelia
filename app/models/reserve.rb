class Reserve
  include Mongoid::Document
  scope :is_verified, -> { where(verified: true) }
  scope :not_verified, -> { where(verified: false) }

  belongs_to :user, class_name: 'User', inverse_of: :reserves

  field :datetime, type: Time
  field :guests, type: Integer
  field :verified, type: Boolean, default: false

  validates_length_of :guests, maximum: Restaurant.load.table_size
  validates_format_of :datetime, with: /\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}/


  def confirm!
    update_attributes(verified: true)
  end
end
