class SiteForm < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :submissions, :dependent => :destroy
  
  has_many :notifications, :dependent => :destroy
  has_many :profile_notifications, :through => :notifications, :source => :user_profile
  
  #accepts_nested_attributes_for :notifications, :reject_if => lambda { |a| a[:user_profile].blank? }, :allow_destroy => true
  
  validate :only_one_registration_application_form
  
  def only_one_registration_application_form
    form = SiteForm.find(:first, :conditions => { :registration_application_form => true })
    errors.add(:id, "There can be only one!  ...registration application form.") if (form and self.registration_application_form and form.id != self.id)
  end
  
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
