class SiteForm < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :submissions, :dependent => :destroy
  
  validates_uniqueness_of :registration_application_form
  
  def self.application_form
    SiteForm.find(:first, :conditions => { :registration_application_form => true })
  end
  
  def self.published
    SiteForm.find(:all, :conditions => { :published => true, :registration_application_form => false })
  end
  
  def check_user_show_permissions(user)
    return true if self.published
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
