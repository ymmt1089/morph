class Book < ApplicationRecord
	has_many :morphemes
	has_many :arts
	belongs_to :user
	acts_as_paranoid
	validates :title,    length: { in: 1..75 }
	validates :body,    length: { in: 1..22300 }
end
