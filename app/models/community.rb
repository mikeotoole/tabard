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
  has_many :pages, :through => :page_spaces
  has_many :site_forms
  has_many :roles
  has_many :supported_games
  has_many :games, :through => :supported_games
  
  belongs_to :admin_role, :class_name => "Role"
  belongs_to :applicant_role, :class_name => "Role"
  belongs_to :member_role, :class_name => "Role"
  
  belongs_to :community_application_form, :class_name => "SiteForm"
  
  before_save :update_subdomain
  
  after_create :setup_admin_role, :setup_applicant_role, :setup_member_role
  
  def display_name
    "#{self.name} #{self.label}"
  end
  
  def admin
    self.admin_role.users.first #TODO might want to get a better way of doing this.
  end
  
  def update_subdomain
    self.subdomain = self.name.downcase.gsub(/\s/, "-")
  end
  
  def setup_admin_role
    self.update_attributes(:admin_role => Role.create(:name => "Admin", 
      :permissions => SystemResource.all.collect{|resource|
        Permission.create(:permissionable => resource, 
          :name => "Full Access #{resource.name}", 
          :show_p => true, 
          :create_p => true, 
          :update_p => true, 
          :delete_p => true, 
          :access => (resource.name == "Discussion" or resource.name == "Comment" ? "lock" : nil)
        )
      },
      :community => self
    ))
  end
  
  def setup_applicant_role
    self.update_attributes(:applicant_role => Role.create(:name => "Applicant",
      :community => self
    ))
  end
  
  def setup_member_role
    self.update_attributes(:member_role => Role.create(:name => "Applicant",
      :community => self
    ))
  end
end
