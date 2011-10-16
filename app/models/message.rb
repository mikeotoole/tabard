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
  attr_accessible :subject, :body, :to

###
# Associations
###
  belongs_to :author, :class_name => "UserProfile"
  has_many :message_associations, :dependent => :destroy, :autosave => true
  has_many :recipients, :through => :message_associations

###
# Callbacks
###
  before_create :prepare_message_associations

###
# Delegates
###
  delegate :avatar_url, :to => :author, :prefix => true

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
  # This method prepares all of the message associations for this message before it is created.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def prepare_message_associations
    self.number_recipients = 0
    return if to.blank?
    to.each do |recipient|
      userProfile = UserProfile.find_by_id(recipient)
      message_associations.build(:recipient_id => userProfile.id, :folder_id => userProfile.inbox.id)
      self.number_recipients += 1
    end
  end
end


# == Schema Information
#
# Table name: messages
#
#  id                :integer         not null, primary key
#  subject           :string(255)
#  body              :text
#  author_id         :integer
#  number_recipients :integer
#  system_sent       :boolean         default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

