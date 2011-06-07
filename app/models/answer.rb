class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :submission 
  
  def qHelp
    self.question.id if question
  end
  
  def type_helper
    self.type
  end
  
  def type_helper=(type)
    self.type = type
  end
  
end
