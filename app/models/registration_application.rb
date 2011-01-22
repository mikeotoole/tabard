class RegistrationApplication < ActiveRecord::Base
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  has_many :answers
  has_many :questions, :throgh => :answers
end
