###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an event.
###
class Invite < ActiveRecord::Base
###
# Constants
###
  # The list of vaild status values.
  VALID_STATUSES =  %w(Attending Not\ Attending Tentative Late)

###
# Attribute accessors
###
  attr_accessor :comment_body

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :status, :comment_body

###
# Associations
###
  belongs_to :event
  belongs_to :user_profile
  belongs_to :character_proxy

###
# Validators
###
  validates :event,  :presence => true
  validates :status,  :presence => true,
            :inclusion => { :in => VALID_STATUSES, :message => "%{value} is not a valid status" }, :on => :update
  validates :user_profile,  :presence => true
  validate :character_is_valid_for_user_profile

###
# Callbacks
###
  after_save :create_comment_from_body

  def create_comment_from_body
    event.comments.create({body: comment_body, user_profile_id: user_profile_id, character_proxy_id: character_proxy_id}, without_protection: true) unless comment_body.blank?
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
#

