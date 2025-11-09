class UserSwimmer < ApplicationRecord
  belongs_to :user
  belongs_to :swimmer

  validates :user_id, uniqueness: { scope: :swimmer_id }

  scope :ordered, -> { order(:display_order, :id) }

  def display_name
    nickname.presence || swimmer.full_name
  end
end
