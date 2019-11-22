class Morpheme < ApplicationRecord
	has_many :arts
	belongs_to :book
end
