class Question < ActiveRecord::Base
  has_many :predefined_answers, :dependent => :destroy 
  belongs_to :site_form
  
  accepts_nested_attributes_for :predefined_answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
  
  def self.select_options_human
    self.select_options.collect{ |opt| 
      case opt
      when "TextBoxQuestion"
        ["Long Answer Question", opt]
      when "TextQuestion"
        ["Short Answer Question", opt]
      else
        [opt.scan(/[A-Z][a-z0-9]*/).join(" "), opt] 
      end
    }
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
  
  def check_user_show_permissions(user)
    user.can_show("SiteForm")
  end
  
  def check_user_create_permissions(user)
    user.can_create("SiteForm")
  end
  
  def check_user_update_permissions(user)
    user.can_update("SiteForm")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("SiteForm")
  end
  
end
