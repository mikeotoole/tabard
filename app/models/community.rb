class Community < ActiveRecord::Base
  validates :name, :uniqueness => { :case_sensitive => false }, 
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 \-]+\z/, :message => "Only letters, numbers, dashes and spaces are allowed" },
                   :community_name => true
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => %w(Guild Team Clan Faction Squad), :message => "%{value} is not currently a supported label" }
  
  has_many :discussion_spaces
  has_many :page_spaces
  has_many :pages, :through => :page_spaces
  has_many :site_forms
  has_many :roles
  has_many :supported_games
  has_many :games, :through => :supported_games
  has_many :registration_applications, :through => :community_application_form, :source => "submissions"
  
  belongs_to :admin_role, :class_name => "Role"
  belongs_to :applicant_role, :class_name => "Role"
  belongs_to :member_role, :class_name => "Role"
  
  belongs_to :community_application_form, :class_name => "SiteForm"
  
  before_save :update_subdomain
  
  after_create :setup_admin_role, :setup_applicant_role, :setup_member_role, :setup_application_form
  
  def display_name
    # "#{self.name} #{self.label}"
    self.name
  end
  
  def self.acceptable_labels
    %w(Guild Team Clan Faction Squad)
  end
  
  def leader_profile
    self.admin_role.users.first.user_profile
  end
  
  def admin
    self.admin_role.users.first #TODO might want to get a better way of doing this.
  end
  
  def all_users
    users = Array.new
    users << self.admin_role.users
    users << self.applicant_role.users
    users << self.member_role.users
    users << self.roles.collect {|role| role.users}
    users.flatten.uniq
  end
  
  def recent_discussion_spaces(number_of_discussion_spaces=10)
    cID = self.id
    DiscussionSpace.where{community_id == cID}.order{created_at.desc}.limit(number_of_discussion_spaces)
  end
  
  def recent_page_spaces(number_of_page_spaces=10)
    cID = self.id
    PageSpace.where{community_id == cID}.order{created_at.desc}.limit(number_of_page_spaces)
  end
  
  def recent_discussions(number_of_discussions=10)
    cID = self.id
    my_disc_spaces = DiscussionSpace.where{community_id == cID}
    Discussion.where{discussion_space_id.in(my_disc_spaces.select{id})}.order{created_at.desc}.limit(number_of_discussions)
  end
  
  def recent_pages(number_of_pages=10)
    cID = self.id
    my_page_spaces = PageSpace.where{community_id == cID}
    Page.where{page_space_id.in(my_page_spaces.select{id})}.order{created_at.desc}.limit(number_of_pages)
  end
  
  def recent_comments(number_of_comments=10)
    cID = self.id
    Comment.where{community_id == cID}.order{created_at.desc}.limit(number_of_comments) 
  end
  
  def recent_members(number_of_members=10)
    member_role_id = self.member_role.id
    User.joins{roles_users.user}.where{roles_users.role_id == member_role_id}.order{roles_users.created_at.desc}.limit(number_of_members)
  end
  
  def get_characters_for_game(game)
    self.all_users.collect{|user| 
       user.get_characters(game)
    }.flatten.compact
  end
  
  def self.convert_to_subdomain(name)
    name.downcase.gsub(/[\s\-]/,"")
  end
  def update_subdomain
    self.subdomain = Community.convert_to_subdomain(name)
  end
  
  def assign_admin_role(user)
    return if self.admin_role.users.size > 1
    user.roles << self.member_role if not user.roles.include?(self.member_role)
    user.roles << self.admin_role
  end
  
  def upgrade_applicant_to_member(user)
    return unless user.roles.includes?(self.applicant_role)
    user.roles.delete(self.applicant_role)
    user.roles << self.member_role
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
    self.update_attributes(:member_role => Role.create(:name => "Member",
    :permissions => SystemResource.all.collect{|resource|
        Permission.create(:permissionable => resource, 
          :name => "View Access #{resource.name}", 
          :show_p => true, 
          :create_p => false, 
          :update_p => false, 
          :delete_p => false
        )
      },
      :community => self
    ))
  end
  
  def setup_application_form
    self.update_attributes(:community_application_form => SiteForm.create(:name => "Registration Application Form", 
      :message => "Please fill out the form to apply for #{self.label}.", 
      :thankyou => "Thank you for submitting your application.", 
      :published => true, 
      :community => self))
  end
  
  def check_user_show_permissions(user)
    true
  end
  
  def check_user_create_permissions(user)
    true
  end
  
  def check_user_update_permissions(user)
    self.admin_role.users.include?(user)
  end
  
  def check_user_delete_permissions(user)
    self.admin_role.users.include?(user)
  end
end
