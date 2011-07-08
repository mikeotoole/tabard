class Community < ActiveRecord::Base
  validates :name, :uniqueness => { :case_sensitive => false }, 
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 ]+\z/, :message => "Only letters, numbers, and spaces are allowed" }
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => %w(Guild Team Clan), :message => "%{value} is not currently a supported label" }
  
  has_many :discussion_spaces
  has_many :page_spaces
  has_many :site_forms
  has_many :roles
  
  belongs_to :admin_role, :class_name => "Role"
  belongs_to :applicant_role, :class_name => "Role"
  belongs_to :member_role, :class_name => "Role"
  
  before_save :update_subdomain
  
  def display_name
    "#{self.name} #{self.label}"
  end
  
  def update_subdomain
    self.subdomain = self.name.downcase.gsub(/\s/, "-")
  end
end
