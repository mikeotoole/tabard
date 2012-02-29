###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for the main application.
###
module ApplicationHelper

###
# Public Methods
###

  ###
  # Adds a new message to the flash messsages array
  # [Args]
  #   * +message_body+ -> The body of the message.
  #   * +message_class+ -> What type of message it is, including but not limited to "alert", "notice", "success", "announcement", etc.
  #   * +message_title+ -> The title of the message.
  ###
  def add_new_flash_message(message_body, message_class="notice", message_title="")
    flash[:messages] = Array.new unless flash[:messages]
    flash[:messages] << { :class => message_class, :title => message_title, :body => message_body }
  end

  # Removes all flash messages
  def clear_flash_messages
    flash.delete(:alert)
    flash.delete(:error)
    flash.delete(:notice)
    flash.delete(:messages)
    session.delete(:hide_announcements)
  end

  ###
  # Adds the ability to pass a default value when delivering yeilds in the view.
  # [Args]
  #   * +content_sym+ -> The yield value.
  #   * +default+ -> The default value for the yield.
  # [Returns] output for yield.
  ###
  def yield_for(content_sym, default)
    output = content_for(content_sym)
    output = default if output.blank?
    output
  end

  ###
  # Provides a clean way to set the page title within a view and adds the text " | Crumblin".
  # [Args]
  #   * +page_title+ -> The page title.
  # [Returns] :title for the yield.
  ###
  def title(page_title)
    content_for(:title) { "#{page_title} | Crumblin" }
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create a collection based on an array of objects.
  # [Args]
  #   * +objects+ -> An array of objects.
  #   * +blank+ -> The string to be used for the blank field.
  #   * +name_attr+ -> The method invoked to find the name attribute.
  #   * +id_attr+ -> The method invoked to find the id attribute.
  # [Returns] an array used for a simple_form collection
  ###
  def collection_with_blank(objects, blank="None", name_attr=:name, id_attr=:id)
    collection = [[ blank, '' ]]
    collection.concat(objects.map{ |o| [o.send(name_attr), o.send(id_attr)] })
  end

  ###
  # Provides a list of character proxies that are within scope of the current action.
  # [Returns] array of character proxies.
  ###
  def available_characters
    current_user.available_character_proxies(current_community,current_game)
  end

end
