class SiteForm < ActiveRecord::Base
  has_many :questions
  
  validate :only_one_registration_application_form
  
  def only_one_registration_application_form
    errors.add(:id, "There can be only one!  ...registration applicaiton form.") if (SiteForm.where(:registration_application_form => true).exists? and self.registration_application_form)
  end
  
  def self.application_form
    SiteForm.find(:first, :conditions => { :registration_application_form => true })
  end
  
  def self.published
    SiteForm.find(:all, :conditions => { :published => true, :registration_application_form => false })
  end
  
end
