class Submission < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :site_form
  
  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers
  
  has_one :community, :through => :site_form  
  
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true  
  
  def contains_predefined_answer(panswer)
    self.answers.each do |answer|
      if answer.question_id == panswer.question_id and answer.content == panswer.content
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end
  
  def contains_predefined_answer_from_collection(panswer_collection)
    panswer_collection.each do |panswer|
      return self.contains_predefined_answer(panswer) if self.contains_predefined_answer(panswer) != nil
    end
    nil
  end
  
  def contains_answer_to_question(question)
    self.answers.each do |answer|
      if answer.question_id == question.id
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end
  
  def name
    self.user_profile.name if self.user_profile
  end
  
  def thankyou_message
    self.site_form.thankyou
  end
  
  def submission_date
    self.created_at
  end
  
  def all_answers
    self.answers
  end
  
  def all_questions
    self.answers.collect { |answer|answer.question }.uniq
  end
  
  def form
    self.site_form
  end
  
  def status_string
    if is_applicant
      "Applicant"
    elsif is_accepted
      "Accepted"
    elsif is_inactive
      "Deactivated User"
    elsif is_rejected
      "Rejected"  
    else
      "Unknown"
    end
  end
  
  def is_applicant
    if self.status == 1
      return true
    else
      return false
    end
  end
  
  def is_accepted
    if self.status == 2
      return true
    else
      return false  
    end
  end
  
  def is_inactive
    if self.status == 3
      return true
    else
      return false  
    end   
  end
  
  def is_rejected
    if self.status == 4
      return true
    else
      return false  
    end   
  end
  
  def set_applicant
    self.status = 1
  end
  
  def set_accepted
    self.status = 2
    self.user_profile.user.roles << self.community.member_role
  end
  
  def set_inactive
    self.status = 3   
  end
  
  def set_rejected
    self.status = 4
  end
end

