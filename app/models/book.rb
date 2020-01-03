class Book < ApplicationRecord
	has_many :morphemes
	has_many :arts
	belongs_to :user
	acts_as_paranoid
	default_scope -> { order(created_at: :desc) }
	validates :title,    length: { in: 1..75 }
	validates :body,    length: { in: 1..22300 } #本番環境のメモリに依存し22300以上はエラー
	validates :title, presence: true
	validates :body, presence: true
end
