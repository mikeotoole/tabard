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
  has_many :user_profiles, :through => :invites
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
  delegate :subdomain, :to => :community, :prefix => true, :allow_nil => true

###
# Callbacks
###
  before_save :notify_users
###
# Protected Methods
###
protected

def notify_users
  if name_changed? or body_changed?
    if name_changed? and body_changed?
      message_the_invites("had the name and/or body changed")
    else
      message_the_invites("had the name changed") if name_changed?
      message_the_invites("had the body changed") if body_changed?
    end
  end
  if start_time_changed? or end_time_changed? 
    if start_time_changed? and end_time_changed?
      message_the_invites("had the starting and ending time changed")
    else
      message_the_invites("had the starting time changed") if start_time_changed?
      message_the_invites("had the ending time changed") if end_time_changed?
    end
    self.invites.update_all({is_viewed: false})
    self.invites.update_all({status: nil})
  end
end

def message_the_invites(reason)
  Message.create_system(:subject => "An event you were invited to has changed",
      :body => "The #{name_was} event you were invited to has #{reason}",
      :to => self.user_profiles.map{|profile| profile.id})
end

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

