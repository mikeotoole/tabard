class RegistrationApplication < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :discussion
  has_many :registration_answers, :dependent => :destroy
  has_many :questions, :through => :registration_answers
  
  accepts_nested_attributes_for :registration_answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def thankyou_message
    "THANK YOU SO MUCH!"  
  end
  
  def name
    self.user_profile.name
  end
  
  def submission_date
    self.created_at
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
