=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a community.
=end
class Community < ActiveRecord::Base
  #attr_accessible :name, :slogan, :label, :accepting, :email_notice_on_applicant
  
  validates :name, :uniqueness => { :case_sensitive => false }, 
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 \-]+\z/, :message => "Only letters, numbers, dashes and spaces are allowed" }
  validates :name, :community_name => true, :on => :create
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => %w(Guild Team Clan Faction Squad), :message => "%{value} is not currently a supported label" }
  
  belongs_to :admin_role, :class_name => "Role"
  belongs_to :applicant_role, :class_name => "Role"
  belongs_to :member_role, :class_name => "Role"
  belongs_to :community_application_form, :class_name => "SiteForm"
  
  has_many :discussion_spaces
  has_many :discussions, :through => :discussion_spaces
  has_many :page_spaces
  has_many :pages, :through => :page_spaces
  has_many :site_forms
  has_many :roles
  has_many :supported_games
  has_many :games, :through => :supported_games
  has_many :registration_applications, :through => :community_application_form, :source => "submissions"
  has_many :comments
  has_many :community_announcements
  has_many :game_announcements
  
  before_save :update_subdomain
  after_create :setup_admin_role, :setup_applicant_role, :setup_member_role, :setup_application_form

=begin
  This method gets the display name for this community.
  [Returns] The string that has this community's name followed by this community's label.
=end
  def display_name
    # "#{self.name} #{self.label}"
    self.name
  end

=begin
  This method gets the acceptable labels for this community.
  [Returns] An array that contains the acceptable labels for a community.
=end
  def self.acceptable_labels
    %w(Guild Team Clan Faction Squad)
  end
  
=begin
  This method gets the user profile of the admin for this community.
  [Returns] The user_profile of the user who has the admin role for this community.
=end  
  def leader_profile
    self.admin.user_profile
  end
  
=begin
  This method gets the admin of this community.
  [Returns] The user who is the admin of this community.
=end
  def admin
    self.admin_role.users.first #TODO might want to get a better way of doing this.
  end
  
=begin
  This method gets all users for this community.
  [Returns] An array that contains all of the users in this community.
=end
  def all_users
    users = Array.new
    users << self.admin_role.users
    users << self.applicant_role.users
    users << self.member_role.users
    users << self.roles.collect {|role| role.users}
    users.flatten.uniq
  end
  
=begin
  This method gets the recent discussion spaces for this community.
  [Args]
    * +number_of_discussion_spaces+ -> The maximum number of discussion spaces to be returned. This defaults to 10.
  [Returns] An array that contains the most recent discussion spaces.
=end
  def recent_discussion_spaces(number_of_discussion_spaces=10)
    cID = self.id
    DiscussionSpace.where{community_id == cID}.order{created_at.desc}.limit(number_of_discussion_spaces)
  end
  
=begin
  This method gets the recent page spaces for this community.
  [Args]
    * +number_of_page_spaces+ -> The maximum number of page spaces to be returned. This defaults to 10.
  [Returns] An array that contains the most recent page spaces.
=end
  def recent_page_spaces(number_of_page_spaces=10)
    cID = self.id
    PageSpace.where{community_id == cID}.order{created_at.desc}.limit(number_of_page_spaces)
  end
  
=begin
  This method gets the recent discussions for this community.
  [Args]
    * +number_of_discussions+ -> The maximum number of discussions to be returned. This defaults to 10.
  [Returns] An array that contains the most recent discussions.
=end
  def recent_discussions(number_of_discussions=10)
    cID = self.id
    my_disc_spaces = DiscussionSpace.where{community_id == cID}
    Discussion.where{discussion_space_id.in(my_disc_spaces.select{id})}.order{created_at.desc}.limit(number_of_discussions)
  end
  
=begin
  This method gets the recent pages for this community.
  [Args]
    * +number_of_pages+ -> The maximum number of pages to be returned. This defaults to 10.
  [Returns] An array that contains the most recent pages.
=end
  def recent_pages(number_of_pages=10)
    cID = self.id
    my_page_spaces = PageSpace.where{community_id == cID}
    Page.where{page_space_id.in(my_page_spaces.select{id})}.order{created_at.desc}.limit(number_of_pages)
  end
  
=begin
  This method gets the recent comments for this community.
  [Args]
    * +number_of_comments+ -> The maximum number of comments to be returned. This defaults to 10.
  [Returns] An array that contains the most recent comments.
=end
  def recent_comments(number_of_comments=10)
    cID = self.id
    Comment.where{community_id == cID}.order{created_at.desc}.limit(number_of_comments) 
  end
  
=begin
  This method gets the recent members for this community.
  [Args]
    * +number_of_members+ -> The maximum number of members to be returned. This defaults to 10.
  [Returns] An array that contains the most recent users (members).
=end
  def recent_members(number_of_members=10)
    member_role_id = self.member_role.id
    User.joins{roles_users.user}.where{roles_users.role_id == member_role_id}.order{roles_users.created_at.desc}.limit(number_of_members)
  end
  
=begin
  This method gets all of the characters from all of the users this community, scoped by the specified game.
  [Args]
    * +game+ -> The game that the characters are a part of.
  [Returns] An array that contains all the character who are part of the specified game.
=end
  def get_characters_for_game(game)
    self.all_users.collect{|user| 
       user.get_characters(game)
    }.flatten.compact
  end

=begin
  This method converts the name passed to it into the corrosponding subdomain representation.
  [Args]
    * +name+ -> The string to convert using the subdomain transformation.
  [Returns] A string who is downcased and has spaces and dashes removed.
=end  
  def self.convert_to_subdomain(name)
    name.downcase.gsub(/[\s\-]/,"")
  end
  
=begin
  _before_save_
  
  This method automatically updates this community's subdomain from this community's name. 
  [Returns] False if an error occured, otherwise true.
=end
  def update_subdomain
    self.subdomain = Community.convert_to_subdomain(name)
  end
  
=begin
  This method assigns this community's admin role to the specified user.
  [Args]
    * +user+ -> The user to assign admin role to.
  [Returns] False if the operation could not be preformed, otherwise true.
=end
  def assign_admin_role(user)
    return false if self.admin_role.users.size > 1
    user.roles << self.member_role if not user.roles.include?(self.member_role)
    user.roles << self.admin_role
  end
  
=begin
  This method upgrades the specified user to .
  [Args]
    * +name+ -> The string to convert using the subdomain transformation.
  [Returns] A string who is downcased and has spaces and dashes removed.
=end
  def upgrade_applicant_to_member(user)
    return false unless user.roles.includes?(self.applicant_role)
    user.roles.delete(self.applicant_role)
    user.roles << self.member_role
  end
  
=begin
  _after_create_
  
  This method sets up the admin role for this community.
  [Returns] False if there was an error, otherwise true.
=end
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
      :description => "",
      :community => self
    ))
  end

=begin
  _after_create_

  This method sets up the default applicant role for this community.
  [Returns] False if there was an error, otherwise true.
=end  
  def setup_applicant_role
    self.update_attributes(:applicant_role => Role.create(:name => "Applicant",
      :description => "",
      :community => self
    ))
  end

=begin
  _after_create_

  This method sets up the default member role for this community.
  [Returns] False if there was an error, otherwise true.
=end  
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
        #Remove Registration application
      },
      :description => "",
      :community => self
    ))
  end

=begin
  _after_create_

  This method sets up the default applicant form for this community.
  [Returns] False if there was an error, otherwise true.
=end  
  def setup_application_form
    self.update_attributes(:community_application_form => SiteForm.create(:name => "Registration Application Form", 
      :message => "Please fill out the form to apply for #{self.label}.", 
      :thankyou => "Thank you for submitting your application.", 
      :published => true, 
      :community => self))
  end

=begin
  This method defines how show permissions are determined for this community.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this community, otherwise false.
=end  
  def check_user_show_permissions(user)
    true
  end

=begin
  This method defines how create permissions are determined for this community.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this community, otherwise false.
=end  
  def check_user_create_permissions(user)
    true
  end

=begin
  This method defines how update permissions are determined for this community.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this community, otherwise false.
=end  
  def check_user_update_permissions(user)
    self.admin_role.users.include?(user)
  end

=begin
  This method defines how delete permissions are determined for this community.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this community, otherwise false.
=end  
  def check_user_delete_permissions(user)
    self.admin_role.users.include?(user)
  end
end


# == Schema Information
#
# Table name: communities
#
#  id                            :integer         not null, primary key
#  name                          :string(255)
#  subdomain                     :string(255)
#  slogan                        :string(255)
#  label                         :string(255)
#  accepting                     :boolean         default(TRUE)
#  created_at                    :datetime
#  updated_at                    :datetime
#  admin_role_id                 :integer
#  applicant_role_id             :integer
#  member_role_id                :integer
#  community_application_form_id :integer
#  email_notice_on_applicant     :boolean         default(TRUE)
#

