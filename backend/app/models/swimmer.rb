class Swimmer < ApplicationRecord
  has_many :performances, dependent: :destroy
  has_many :user_swimmers, dependent: :destroy
  has_many :users, through: :user_swimmers

  validates :first_name, :last_name, :dob, :sex, presence: true
  validates :se_membership_id, uniqueness: true, allow_nil: true
  validates :sex, inclusion: { in: %w[M F] }

  def full_name
    "#{first_name} #{last_name}"
  end

  def age_on(date)
    age = date.year - dob.year
    age -= 1 if date.yday < dob.yday
    age
  end
end
