class Question < ApplicationRecord
  has_many :answers, -> { order_by_best }, dependent: :destroy 
  belongs_to :user
  
  validates :title, :body, presence: true
end
