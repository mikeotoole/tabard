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
  attr_accessible :name, :markup
  attr_accessible :name, :markup, :show_in_navigation, :as => :community_admin

###
# Associations
###
  belongs_to :page_space
  has_one :community, :through => :page_space

  scope :navigation_pages, :conditions => {:show_in_navigation => true}
  scope :alphabetical, order("name ASC")

###
# Callbacks
###
  after_update :remove_action_item

###
# Delegates
###
  delegate :name, :to => :page_space, :prefix => true, :allow_nil => true
  delegate :game, :to => :page_space, :prefix => true, :allow_nil => true
  delegate :game_name, :to => :page_space, :allow_nil => true
  delegate :admin_profile_id, :to => :community, :prefix => true, :allow_nil => true

###
# Validators
###
  validates :name, :presence => true, :length => { :maximum => MAX_NAME_LENGTH }
  validates :markup, :presence => true
  validates :page_space, :presence => true

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
  # _after_update_
  #
  # This method removes action item from community.
  ###
  def remove_action_item
    if self.community.home_page and self.community.home_page.id == self.id and self.community.action_items.any?
      self.community.action_items.delete(:update_home_page)
      self.community.save
    end
  end
end








# == Schema Information
#
# Table name: pages
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  markup        :text
#  page_space_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime
#

