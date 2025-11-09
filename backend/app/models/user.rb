class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_swimmers, dependent: :destroy
  has_many :swimmers, through: :user_swimmers

  def admin?
    # TODO: Add admin field to users table if needed
    false
  end
end
