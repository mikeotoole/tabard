class Community < ActiveRecord::Base
  validates :name, :uniqueness => { :case_sensitive => false }, 
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 ]+\z/, :message => "Only letters, numbers, and spaces are allowed" }
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => %w(Guild Team Clan), :message => "%{value} is not currently a supported label" }
  
  before_save :update_subdomain
  
  def update_subdomain
    self.subdomain = self.name.downcase.gsub(/\s/, "-")
  end
end
