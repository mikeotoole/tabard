###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an event.
###
class Invite < ActiveRecord::Base
  validates_lengths_from_database
###
# Constants
###
  # The list of vaild status values.
  VALID_STATUSES =  %w(Attending Not\ Attending Tentative Going\ to\ be\ Late)

###
# Attribute accessors
###
  attr_accessor :comment_body

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :status, :comment_body, :user_profile, :character_proxy, :user_profile_id, :character_proxy_id, :event_id

###
# Associations
###
  belongs_to :event, inverse_of: :invites
  belongs_to :user_profile, inverse_of: :invites
  belongs_to :character_proxy

###
# Scopes
###
  scope :viewed, where{(is_viewed == true)}
  scope :unviewed, where{(is_viewed != true)}
  scope :not_responded_to, where{(status.eq "") | (status.eq nil)}
  scope :responded_to, where{status.eq_any VALID_STATUSES}
  scope :expired, lambda { where{expiration.lteq Time.zone.now} }
  scope :fresh, lambda { where{expiration.gt Time.zone.now} }

###
# Validators
###
  validates :event,  presence: true
  validates :status,  presence: true,
            inclusion: { in: VALID_STATUSES, message: "%{value} is not a valid status" }, on: :update, if: Proc.new{|invite| invite.is_viewed? }
  validates :user_profile,  presence: true
  validate :character_is_valid_for_user_profile

  delegate :supported_game, to: :event, allow_nil: true
  delegate :community, to: :event, allow_nil: true
  delegate :community_subdomain, to: :event, allow_nil: true
  delegate :community_name, to: :event, allow_nil: true
  delegate :name, to: :event, prefix: true, allow_nil: true
  delegate :start_time, to: :event, prefix: true, allow_nil: true
  delegate :end_time, to: :event, prefix: true, allow_nil: true
  delegate :name, to: :invitee, prefix: true, allow_nil: true
  delegate :avatar_url, to: :invitee, prefix: true, allow_nil: true
  delegate :display_name, to: :user_profile, prefix: true, allow_nil: true
  delegate :avatar_url, to: :user_profile, prefix: true, allow_nil: true
  delegate :avatar_url, to: :character_proxy, prefix: true, allow_nil: true

###
# Callbacks
###
  after_save :create_comment_from_body
  after_create :set_expiration_from_event
  # This creates a comment from the body.
  def create_comment_from_body
    event.comments.create({body: comment_body, user_profile_id: user_profile_id, character_proxy_id: character_proxy_id}, without_protection: true) unless comment_body.blank?
  end
  # This sets the expiration date from the event.
  def set_expiration_from_event
    self.update_column(:expiration, self.event_end_time) and return true unless self.expiration
  end
  # This updates viewed for the specified user profile.
  def update_viewed(user_profile)
    self.update_column(:is_viewed, true) if user_profile and user_profile.invites.include?(self)
  end
  # This gets the smart status
  def smart_status
    ( is_viewed and status == nil ? "No Response" : status )
  end

###
# Instance Methods
###
  ###
  # This method gets the invitee of this invite. If character proxy is not nil
  # the character is returned. Otherwise the user profile is returned. These should
  # both respond to a common interface for things like display name and avatar.
  # [Returns] The invitee, A character or user profile.
  ###
  def invitee
    if self.character_proxy
      self.character_proxy.character
    else
      self.user_profile
    end
  end

###
# Validator Methods
###
  ###
  # This method validates that the selected game is valid for the community.
  ###
  def character_is_valid_for_user_profile
    return unless self.character_proxy
    self.errors.add(:character_proxy_id, "this character is not owned by you") unless self.user_profile.character_proxies.include?(self.character_proxy)
  end

end



# == Schema Information
#
# Table name: invites
#
#  id                 :integer         not null, primary key
#  event_id           :integer
#  user_profile_id    :integer
#  character_proxy_id :integer
#  status             :string(255)
#  is_viewed          :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  expiration         :datetime
#

