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
  
end
