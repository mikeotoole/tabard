=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a message copy.
=end
class MessageCopy < ActiveRecord::Base
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :message
  belongs_to :message
  belongs_to :recipient, :class_name => "UserProfile"
  belongs_to :folder

=begin
  This method defines how show permissions are determined for this message copy.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this message copy, otherwise false.
=end
  def check_user_show_permissions(user)
    self.recipient == user
  end

=begin
  This method defines how create permissions are determined for this message copy.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this message copy, otherwise false.
=end
  def check_user_create_permissions(user)
    false
  end

=begin
  This method defines how update permissions are determined for this message copy.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this message copy, otherwise false.
=end
  def check_user_update_permissions(user)
    false
  end

=begin
  This method defines how delete permissions are determined for this message copy.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this message copy, otherwise false.
=end
  def check_user_delete_permissions(user)
    self.recipient == user
  end
end

# == Schema Information
#
# Table name: message_copies
#
#  id           :integer         not null, primary key
#  recipient_id :integer
#  message_id   :integer
#  folder_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#  deleted      :boolean         default(FALSE)
#

