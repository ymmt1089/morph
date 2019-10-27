class Art < ApplicationRecord
	belongs_to :user
	belongs_to :book
	belongs_to :morpheme
end
