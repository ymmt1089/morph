class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :admin_name, uniqueness: true
  # validates :admin_name, presence: true
  # validates :email, uniqueness: true
  # validates :email, presence: true
  # validates :encrypted_password, uniqueness: true
  # validates :encrypted_password, presence: true
end
