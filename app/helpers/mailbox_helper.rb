###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for messages.
###
module MailboxHelper

  ###
  # This helper method creates an array of class names based on the given message's attributes.
  # [Args]
  #   * +message+ -> The message to be inspected
  # [Returns] an array of strings
  ###
  def message_class_names(message)
    class_names = Array.new()
    class_names << message.folder_name.downcase.gsub(/[^a-z0-9]/,'') if message.respond_to?('folder_name')
    class_names << 'open' if message == @message
    class_names << 'sent' if !message.respond_to?('folder_name') && message.author_id == current_user.id
    class_names << 'read' if message.respond_to?('has_been_read') && message.has_been_read?
    class_names
  end

end