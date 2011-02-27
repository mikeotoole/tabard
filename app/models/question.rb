class Question < ActiveRecord::Base
  has_many :predefined_answers, :dependent => :destroy 
  belongs_to :site_form
  
  accepts_nested_attributes_for :predefined_answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
  
  def type_helper
    self.type
  end
  
  def type_helper=(type)
    self.type = type
  end
  
  def answers(submission_id)
    Answer.where(:submission_id => submission_id, :question_id => self.id)
  end
  
end
