###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an event.
###
class Event < ActiveRecord::Base
  include Rails.application.routes.url_helpers # FIXME wrap this in a method to get at helpers. See: http://railscasts.com/episodes/132-helpers-outside-views

  validates_lengths_from_database except: [:name, :body]
###
# Constants
###
  # This is the max title length
  MAX_NAME_LENGTH = 60
  # This is the max body length
  MAX_BODY_LENGTH = 10000

###
# Scopes
###
  scope :not_expired, lambda { where("events.end_time > ?", Time.now).order('events.start_time asc') }
  scope :expired, lambda { where("events.end_time < ?", Time.now).order('events.start_time desc') }

###
# Attribute accessor
###
  attr_accessor :start_time_date, :start_time_hours, :start_time_minutes, :start_time_meridian, :end_time_date, :end_time_hours, :end_time_minutes, :end_time_meridian

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :invites_attributes, :body, :start_time, :end_time, :supported_game_id, :supported_game, :is_public, :location, :start_time_date,
                  :start_time_hours, :start_time_minutes, :start_time_meridian, :end_time_date, :end_time_hours, :end_time_minutes, :end_time_meridian

###
# Associations
###
  belongs_to :supported_game
  belongs_to :creator, class_name: "UserProfile"
  belongs_to :community
  has_many :invites, inverse_of: :event, include: :user_profile, order: 'LOWER(user_profiles.display_name) ASC', dependent: :destroy
  has_many :user_profiles, through: :invites
  has_many :attending_invites, class_name: "Invite", conditions: {status: "Attending"}
  has_many :not_attending_invites, class_name: "Invite", conditions: {status: "Not Attending"}
  has_many :tentative_invites, class_name: "Invite", conditions: {status: "Tentative"}
  has_many :late_invites, class_name: "Invite", conditions: {status: "Going to be Late"}

  has_many :comments, as: :commentable

  accepts_nested_attributes_for :invites, allow_destroy: true

###
# Validators
###
  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :body, presence: true, length: { maximum: MAX_BODY_LENGTH }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :starttime_after_endtime
  validates :creator, presence: true
  validates :community, presence: true

###
# Delegates
###
  delegate :display_name, to: :creator, prefix: true, allow_nil: true
  delegate :avatar_url, to: :creator, prefix: true, allow_nil: true
  delegate :smart_name, to: :supported_game, prefix: true, allow_nil: true
  delegate :subdomain, to: :community, prefix: true, allow_nil: true
  delegate :name, to: :community, prefix: true, allow_nil: true
  delegate :member_profiles, to: :community, prefix: true, allow_nil: true
  delegate :id, to: :creator, prefix: true

  delegate :url_helpers, to: 'Rails.application.routes'

###
# Callbacks
###
  before_validation :update_event_times
  before_save :notify_users, on: :update

###
# Public Methods
###
  # The number of minutes the event lasts for
  def duration_minutes
    (end_time.to_time - start_time.to_time) / 60
  end
  # The number of hours the event lasts for (rounded up)
  def duration_hours
    (duration_minutes / 60).ceil
  end
  # The start time date
  def start_time_date
    @start_time_date ||= start_time ? start_time.to_date : ''
  end
  # The start time hours
  def start_time_hours
    @start_time_hours ||= start_time ? (start_time.hour <= 12 ? start_time.hour : start_time.hour - 12) : ''
  end
  # The start time minutes
  def start_time_minutes
   @start_time_minutes ||= start_time ? (start_time.min > 0 ? start_time.min.to_s : '00') : '00'
  end
  # The start time meridian
  def start_time_meridian
    @start_time_meridian ||= start_time ? (start_time.hour < 12 ? 'AM' : 'PM') : ''
  end
  # The end time date
  def end_time_date
    @end_time_date ||= end_time ? end_time.to_date : ''
  end
  # The end time hours
  def end_time_hours
    @end_time_hours ||= end_time ? (end_time.hour <= 12 ? end_time.hour : end_time.hour - 12) : ''
  end
  # The end time minutes
  def end_time_minutes
    @end_time_minutes ||= end_time ? (end_time.min > 0 ? end_time.min.to_s : '00') : '00'
  end
  # The end time meridian
  def end_time_meridian
    @end_time_meridian ||= end_time ? (end_time.hour < 12 ? 'AM' : 'PM') : ''
  end
  # This updates viewed for the provided user
  def update_viewed(user_profile)
    self.invites.where(user_profile_id: user_profile.id).first.update_column(:is_viewed, true) if user_profile and self.invites.where(user_profile_id: user_profile.id).exists?
  end

###
# Scopes
###
  # Events that overlap a given range
  def self.intersects_with(start_day, end_day)
    where {(start_time <= end_day) & (end_time >= start_day)}
  end

###
# Protected Methods
###
protected

def notify_users
  return true unless self.persisted?
  return true if self.invites.blank?
  if name_changed? or body_changed?
    self.invites.unscoped.update_all({is_viewed: false})
    message_the_invites
  elsif start_time_changed? or end_time_changed?
    self.invites.unscoped.update_all({status: nil, expiration: self.end_time, is_viewed: false})
    message_the_invites('Please update your RSVP status.')
  end
  return true
end

# This messages the invited person
def message_the_invites(text='')
  default_url_options[:host] = ENV["RAILS_ENV"] == 'production' ? "#{community.subdomain}.guild.io" : "#{community.subdomain}.lvh.me:3000"
  Message.create_system(subject: "Event Changed",
      body: "The event, [#{name}](#{event_url(self)}), has changed. #{text}\n\t\n> **Start:** #{start_time.strftime('%b %e, %y @ %l:%M %p')}  \n**End:** #{end_time.strftime('%b %e, %y @ %l:%M %p')}\n\t\n> #{body}",
      to: self.user_profiles.map{|profile| profile.id}) unless self.user_profiles.blank?
end

###
# _before_validation_
#
# Sets start_time and end_time based on individual date/time attributes
###
def update_event_times
  unless start_time_date.blank? or start_time_hours.blank? or start_time_minutes.blank? or start_time_meridian.blank?
    self.start_time_hours = start_time_hours.to_i + 12 if start_time_meridian == 'PM'
    self.start_time = Time.zone.parse("#{start_time_date} #{start_time_hours ? sprintf('%02d', start_time_hours) : '00'}:#{start_time_minutes ? start_time_minutes : '00'}")
  end
  unless end_time_date.blank? or end_time_hours.blank? or end_time_minutes.blank? or end_time_meridian.blank?
    self.end_time_hours = end_time_hours.to_i + 12 if end_time_meridian == 'PM'
    self.end_time = Time.zone.parse("#{end_time_date} #{end_time_hours ? sprintf('%02d', end_time_hours) : '00'}:#{end_time_minutes ? end_time_minutes : '00'}")
  end
  return true
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
#  id                :integer          not null, primary key
#  name              :string(255)
#  body              :text
#  start_time        :datetime
#  end_time          :datetime
#  creator_id        :integer
#  supported_game_id :integer
#  community_id      :integer
#  is_public         :boolean          default(FALSE)
#  location          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

