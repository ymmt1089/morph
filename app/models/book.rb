class Book < ApplicationRecord
	has_many :morphemes
	has_many :arts
	belongs_to :user
	acts_as_paranoid
end
