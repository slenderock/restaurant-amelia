class Reserve
  include Mongoid::Document
  scope :is_verified, -> { where(verified: true) }
  scope :not_verified, -> { where(verified: false) }

  belongs_to :user, class_name: 'User', inverse_of: :reserves

  field :datetime, type: Time
  field :guests, type: Integer
  field :verified, type: Boolean, default: false

  def verify!
    update_attributes(verified: true)
  end
end
