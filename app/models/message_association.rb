###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a message association to a mssage, its recipient and the folder it is in.
###
class MessageAssociation < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :deleted, :recipient_id, :folder_id, :message_id, :has_been_read

###
# Associations
###
  belongs_to :message
  belongs_to :recipient, :class_name => "UserProfile"
  belongs_to :folder

###
# Delegates
###
  delegate :author, :subject, :body, :recipients, :author_avatar_url, :system_sent, :to => :message
  delegate :name, :id, :to => :author, :prefix => true, :allow_nil => true
  delegate :name, :to => :folder, :prefix => true

###
# Validators
###
  validates :message, :presence => true
  validates :recipient, :presence => true

  default_scope :order => "created_at DESC"

###
# Instance Methods
###
  def original_message_id
    self.message_id
  end

end









# == Schema Information
#
# Table name: message_associations
#
#  id            :integer         not null, primary key
#  message_id    :integer
#  recipient_id  :integer
#  folder_id     :integer
#  deleted       :boolean         default(FALSE)
#  has_been_read :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

