class RegistrationApplication < ActiveRecord::Base
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  has_many :registration_answers, :dependent => :destroy
  has_many :questions, :through => :registration_answers
  
  accepts_nested_attributes_for :registration_answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  
  def name
    self.user_profile.name
  end
  
  def all_answers
    self.registration_answers
  end
  
  def all_questions  
    self.registration_answers.collect { |answer|answer.question }.uniq
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
end
