=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a question.
=end
class Question < ActiveRecord::Base
  #attr_accessible :content, :site_form
  
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
      when "ComboBoxQuestion"
        ["Dropdown Question", opt]
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
  
=begin
  This method defines how show permissions are determined for this question.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this question, otherwise false.
=end
  def check_user_show_permissions(user)
    user.can_show("SiteForm")
  end
  
=begin
  This method defines how create permissions are determined for this question.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this question, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create("SiteForm")
  end
  
=begin
  This method defines how update permissions are determined for this question.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this question, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update("SiteForm")
  end
  
=begin
  This method defines how delete permissions are determined for this question.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this question, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("SiteForm")
  end
  
end

# == Schema Information
#
# Table name: questions
#
#  id           :integer         not null, primary key
#  content      :text
#  created_at   :datetime
#  updated_at   :datetime
#  site_form_id :integer
#  type         :string(255)
#

