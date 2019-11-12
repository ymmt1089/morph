class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :validatable
  attachment :user_image
  has_many :books, dependent: :destroy
  has_many :morphemes
  has_many :arts
  acts_as_paranoid


  validates :user_name, uniqueness: true
  validates :user_name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :encrypted_password, uniqueness: true
  validates :encrypted_password, presence: true

  default_scope -> { order(created_at: :desc) }
end
