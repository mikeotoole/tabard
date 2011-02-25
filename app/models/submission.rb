class Submission < ActiveRecord::Base
  belongs_to :user_profile
  
  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers  
  
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true  
  
  def name
    self.user_profile.name
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
    myanswers = self.answers
    if myanswers != nil
      form = myanswers.first.question.form_id
    else
      form = nil
    end
    form
  end
  
end

