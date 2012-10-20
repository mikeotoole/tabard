###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a message.
###
class Message < ActiveRecord::Base
  validates_lengths_from_database except: [:subject, :body]
###
# Constants
###
  # This is the max subject length
  MAX_SUBJECT_LENGTH = 60
  # This is the max body length
  MAX_BODY_LENGTH = 10000

###
# Attribute accessor
###
  # This attribute is an array of recipient (user_profile) ids.
  attr_accessor  :to

###
# Attribute accessible
###
  attr_accessible :subject, :body, :to, :dont_send_email

###
# Associations
###
  belongs_to :author, class_name: "UserProfile"
  has_many :message_associations, dependent: :destroy, autosave: true
  has_many :recipients, through: :message_associations

###
# Callbacks
###
  before_create :prepare_message_associations

###
# Delegates
###
  delegate :avatar_url, :name, to: :author, prefix: true, allow_nil: true

###
# Validators
###
  validates :subject, presence: true, length: { maximum: MAX_SUBJECT_LENGTH }
  validates :body,  presence: true, length: { maximum: MAX_BODY_LENGTH }
  validates :to,  presence: true

  default_scope order: "created_at DESC"

###
# Class Methods
###
  def self.create_system(message_params)
    begin
      message = Message.new(message_params)
      message.is_system_sent = true
      message.save!
    rescue
      logger.error("Could not send system message #{self.message}. #{message.errors}")
    end
  end

###
# Instance Methods
###
  def original_message_id
    self.id
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method prepares all of the message associations for this message before it is created.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def prepare_message_associations
    self.number_recipients = 0
    return if to.blank?
    to.each do |recipient|
      if !recipient.blank?
        userProfile = UserProfile.find_by_id(recipient)
        message_associations.build(recipient_id: userProfile.id, folder_id: userProfile.inbox.id)
        self.number_recipients += 1
      end
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                :integer          not null, primary key
#  subject           :string(255)
#  body              :text
#  author_id         :integer
#  number_recipients :integer
#  is_system_sent    :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  dont_send_email   :boolean          default(FALSE)
#

