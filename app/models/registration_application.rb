class RegistrationApplication < ActiveRecord::Base
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  has_many :registration_answers, :dependent => :destroy
  has_many :questions, :through => :registration_answers
end
