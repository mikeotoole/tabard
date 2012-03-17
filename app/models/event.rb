###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an event.
###
class Event < ActiveRecord::Base
###
# Constants
###
  # This is the max title length
  MAX_NAME_LENGTH = 60
  # This is the max body length
  MAX_BODY_LENGTH = 10000

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :invites_attributes, :body, :start_time, :end_time, :supported_game_id, :is_public, :location

###
# Associations
###
  belongs_to :supported_game
  belongs_to :creator, :class_name => "UserProfile"
  belongs_to :community
  has_many :invites
  has_many :comments, :as => :commentable

  accepts_nested_attributes_for :invites, :allow_destroy => true

###
# Validators
###
  validates :name, :presence => true, :length => { :maximum => MAX_NAME_LENGTH }
  validates :body, :presence => true, :length => { :maximum => MAX_BODY_LENGTH }
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validate :starttime_after_endtime
  validates :creator, :presence => true
  validates :community, :presence => true
 
###
# Delegates
###
  delegate :display_name, :to => :creator, :prefix => true, :allow_nil => true
  delegate :smart_name, :to => :supported_game, :prefix => true, :allow_nil => true

###
# Protected Methods
###
protected

###
# Validation Methods
###
  def starttime_after_endtime
    if self.start_time and self.end_time
      if (self.start_time >= self.end_time)
        self.errors[:start_time] << "Start time must be before than end time"
        self.errors[:end_time] << "End time must be after start time"
        return false
      else
        return true  
      end
    end     
  end
end


# == Schema Information
#
# Table name: events
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  body              :text
#  start_time        :datetime
#  end_time          :datetime
#  creator_id        :integer
#  supported_game_id :integer
#  community_id      :integer
#  is_public         :boolean         default(FALSE)
#  location          :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

