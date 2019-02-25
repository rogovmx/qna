class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  scope :order_by_best, -> { order best: :desc }
  
  validates :body, presence: true, length: { minimum: 3 }
  
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
end
