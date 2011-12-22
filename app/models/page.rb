###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a page.
###
class Page < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # The max number of pages the user can have displayed in the navigation.
  MAX_NUMBER_OF_NAVIGATION_PAGES = 5
  # Used by validators and view to restrict name length
  MAX_NAME_LENGTH = 30

###
# Attribute accessible
###
  attr_accessible :name, :markup, :show_in_navigation

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
  validates :name, :presence => true,
                   :length => { :maximum => MAX_NAME_LENGTH }
  validates :markup, :presence => true
  validates :page_space, :presence => true
  validate :limit_number_of_pages

###
# Delegates
###
  delegate :name, :to => :page_space, :prefix => true, :allow_nil => true
  delegate :game, :to => :page_space, :prefix => true, :allow_nil => true
  delegate :game_name, :to => :page_space, :allow_nil => true
  delegate :admin_profile_id, :to => :community, :prefix => true, :allow_nil => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  #
  ###
  def body
    markdown = RDiscount.new(self.markup, :autolink, :filter_styles, :smart)
    html = markdown.to_html
    Sanitize.clean(html, Sanitize::Config::CUSTOM).html_safe
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
#  markup             :text
#  page_space_id      :integer
#  show_in_navigation :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#

