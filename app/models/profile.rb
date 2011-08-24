=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a profile.
=end
class Profile < ActiveRecord::Base
  #attr_accessible :name
  #belongs_to :user

  has_many :AcknowledgmentOfAnnouncements
  has_many :Announcements, :through => :AcknowledgmentOfAnnouncement

  validates_presence_of :name

=begin
  This method gets the select options for profiles, based on subclasses.
  [Returns] An alphabetised array of subclasses as strings.
=end
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end

=begin
  This method gets the display name of this profile.
  [Returns] A string that contains the name of this profile.
=end
  def display_name
    self.name
  end

=begin
  This method gets the type.
  [Returns] The type of profile.
=end
  def type_helper
    self.type
  end

=begin
  This method sets the type.
  [Args]
    * +type+ -> A string that has the type to use.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def type_helper=(type)
    self.type = type
  end

end

# == Schema Information
#
# Table name: profiles
#
#  id                           :integer         not null, primary key
#  name                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  type                         :string(255)
#  user_id                      :integer
#  game_id                      :integer
#  user_profile_id              :integer
#  discussion_id                :integer
#  personal_discussion_space_id :integer
#  default_character_proxy_id   :integer
#  is_system_profile            :boolean
#  avatar                       :string(255)
#

