###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a message association to a mssage, its recipient and the folder it is in.
###
class MessageAssociation < ActiveRecord::Base
  validates_lengths_from_database
###
# Attribute accessible
###
  attr_accessible :is_removed, :recipient_id, :folder_id, :message_id, :has_been_read

###
# Associations
###
  belongs_to :message
  belongs_to :recipient, class_name: "UserProfile"
  belongs_to :folder

###
# Delegates
###
  delegate :author, :subject, :body, :recipients, :author_avatar_url, :is_system_sent, to: :message
  delegate :name, :id, to: :author, prefix: true, allow_nil: true
  delegate :name, to: :folder, prefix: true

###
# Validators
###
  validates :message, presence: true
  validates :recipient, presence: true

  default_scope order: "created_at DESC"

###
# Callbacks
###
  before_destroy :delete_message_if_system_sent

###
# Instance Methods
###
  def original_message_id
    self.message_id
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_destroy_
  #
  # Will delete associated message if it's system sent.
  ###
  def delete_message_if_system_sent
    self.message.delete if self.message.is_system_sent
  end
end

# == Schema Information
#
# Table name: message_associations
#
#  id            :integer          not null, primary key
#  message_id    :integer
#  recipient_id  :integer
#  folder_id     :integer
#  is_removed    :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  has_been_read :boolean          default(FALSE)
#

