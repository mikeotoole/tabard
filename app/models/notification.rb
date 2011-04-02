class Notification < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :site_form
  
  validates_presence_of :user_profile, :site_form
end
