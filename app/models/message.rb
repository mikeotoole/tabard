###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a message.
###
class Message < ActiveRecord::Base
###
# Attribute accessor
###
  # This attribute is an array of recipient (user_profile) ids.
  attr_accessor  :to
  
###
# Attribute accessible
###
  attr_accessible :subject, :body

###
# Associations
###
  belongs_to :author, :class_name => "UserProfile"
  has_many :message_copies, :dependent => :destroy
  has_many :recipients, :through => :message_copies

###
# Callbacks
###
  before_create :prepare_copies

###
# Validators
###
  validates :subject, :presence => true
  validates :body,  :presence => true
  validates :to,  :presence => true

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
  # This method prepares all of the message copies for this message before it is created.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def prepare_copies
    return if to.blank?
    to.each do |recipient|
      userProfile = UserProfile.find_by_id(recipient.id)
      message_copies.build(:recipient_id => userProfile.id, :folder_id => userProfile.inbox.id)
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  subject     :string(255)
#  body        :text
#  author_id   :integer
#  system_sent :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

