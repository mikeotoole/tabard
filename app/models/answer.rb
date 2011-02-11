class Answer < ActiveRecord::Base
  
  def type_helper
    self.type
  end
  
  def type_helper=(type)
    self.type = type
  end
  
end
