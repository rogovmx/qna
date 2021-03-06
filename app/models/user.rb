class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
       
  has_many :questions
  has_many :answers
  
  validates :email, :password, presence: true
  
  def author_of?(resource)  
    id == resource&.user_id
  end
end
