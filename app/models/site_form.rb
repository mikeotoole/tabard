class SiteForm < ActiveRecord::Base
  has_many :questions
  
  validate :only_one_registration_application_form
  
  def only_one_registration_application_form
    errors.add(:id, "There can be only one!  ...registration applicaiton form.") if (SiteForm.where(:registration_application_form => true).exists? and self.registration_application_form)
  end
  
  def application_form
    SiteForm.where(:registration_application_form => true)
  end
  
end
