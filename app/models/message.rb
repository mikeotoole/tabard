=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a message.
=end
class Message < ActiveRecord::Base
  attr_accessor  :to # array of people to send to
  #attr_accessible :subject, :body, :to, :author
  
  belongs_to :author, :class_name => "UserProfile"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  
  before_create :prepare_copies
  
  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :to
  
=begin
  _before_create_
  
  This method prepares all of the message copies for this message before it is created.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def prepare_copies
    return if to.blank?
    to.each do |recipient|
      userProfile = UserProfile.find(recipient)
      message_copies.build(:recipient_id => userProfile.id, :folder_id => userProfile.inbox.id)
    end
  end
  
=begin
  This method defines how show permissions are determined for this message.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this message, otherwise false.
=end
  def check_user_show_permissions(user)
    self.author == user
  end
  
=begin
  This method defines how create permissions are determined for this message.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this message, otherwise false.
=end
  def check_user_create_permissions(user)
    true
  end
  
=begin
  This method defines how update permissions are determined for this message.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this message, otherwise false.
=end
  def check_user_update_permissions(user)
    false
  end
  
=begin
  This method defines how delete permissions are determined for this message.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this message, otherwise false.
=end
  def check_user_delete_permissions(user)
    self.recipients.each do |recipient|
      return true if recipient == user
    end
    false
  end
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  author_id  :integer
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

