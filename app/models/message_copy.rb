###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a message copy.
###
class MessageCopy < ActiveRecord::Base
###
# Associations
###
  belongs_to :message
  belongs_to :recipient, :class_name => "UserProfile"
  belongs_to :folder

###
# Delegates
###
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :message
  
###
# Validators
###
  validates :message, :presence => true
  validates :recipient, :presence => true
end

# == Schema Information
#
# Table name: message_copies
#
#  id           :integer         not null, primary key
#  message_id   :integer
#  recipient_id :integer
#  folder_id    :integer
#  deleted      :boolean         default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

