###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :slogan, :label, :accepting_members, :email_notice_on_application

###
# Validators
###
  validates :name, :uniqueness => { :case_sensitive => false },
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 \-]+\z/, :message => "Only letters, numbers, dashes and spaces are allowed" }
  validates :name, :community_name => true, :on => :create
  validate :can_not_change_name, :on => :update
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => %w(Guild Team Clan Faction Squad), :message => "%{value} is not currently a supported label" }

###
# Callbacks
###
  before_save :update_subdomain

###
# Protected Methods
###
protected

  ###
  # _before_save_
  #
  # This method automatically updates this community's subdomain from this community's name.
  # [Returns] False if an error occured, otherwise true.
  ###
  def update_subdomain
    self.subdomain = Community.convert_to_subdomain(name)
  end

  ###
  # This method converts the name passed to it into the corrosponding subdomain representation.
  # [Args]
  #   * +name+ -> The string to convert using the subdomain transformation.
  # [Returns] A string who is downcased and has spaces and dashes removed.
  ###
  def self.convert_to_subdomain(name)
    return false if name.blank?
    name.downcase.gsub(/[\s\-]/,"")
  end

  ###
  # This method ensures that the name is not changed.
  ###
  def can_not_change_name
    if self.name_changed?
      self.name = self.name_was
      self.errors.add(:name, "can not be changed.")
      return false
    end
  end
end

# == Schema Information
#
# Table name: communities
#
#  id                          :integer         not null, primary key
#  name                        :string(255)
#  slogan                      :string(255)
#  label                       :string(255)
#  accepting_members           :boolean         default(TRUE)
#  email_notice_on_application :boolean         default(TRUE)
#  subdomain                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

