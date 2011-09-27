###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a page.
###
class Page < ActiveRecord::Base
###
# Constants
###
  # The max number of pages the user can have displayed in the navigation.
  MAX_NUMBER_OF_NAVIGATION_PAGES =  5

###
# Attribute accessible
###
  attr_accessible :name, :body, :show_in_navigation

###
# Associations
###
  belongs_to :page_space
  has_one :community, :through => :page_space

  scope :navigation_pages, :conditions => {:show_in_navigation => true}
  scope :alphabetical, order("name ASC")

###
# Validators
###
  validates :name, :presence => true
  validates :body, :presence => true
  validates :page_space, :presence => true
  validates :user_profile, :presence => true
  validate :limit_number_of_pages

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the poster of this discussion. If character proxy is not nil
  # the character is returned. Otherwise the user profile is returned. These should
  # both respond to a common interface for things like display name and avatar.
  # [Returns] The poster, A character or user profile.
  ###
  def poster
    if self.character_proxy
      self.character_proxy.character
    else
      self.user_profile
    end
  end

  ###
  # This method checks to see if a character posted this discussion.
  # [Returns] True if a character made this discussion, otherwise false.
  ###
  def charater_posted?
    character_proxy != nil
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _validate_
  #
  # This method ensures that the total number of navigation pages is at most a specified number of pages.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def limit_number_of_pages
    if(MAX_NUMBER_OF_NAVIGATION_PAGES <= Page.navigation_pages.size and self.show_in_navigation)
      errors.add(:show_in_navigation, "The maximum number of navigation pages [#{MAX_NUMBER_OF_NAVIGATION_PAGES}] has been reached. Please unselect one to make room.")
      false
    else
      true  
    end            
  end

end

# == Schema Information
#
# Table name: pages
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  page_space_id      :integer
#  show_in_navigation :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

