class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :user_image
  has_many :books, dependent: :destroy
  has_many :morphemes
  has_many :arts
  acts_as_paranoid
end
