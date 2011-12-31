###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for the main application.
###
module ApplicationHelper
  ###
  # TODO Doug, Add the Args descriptions.
  # Creates a link to remove the given fields.
  # [Args]
  #   * +name+ -> The name of the link.
  #   * +f+ ->
  #   * +target+ ->
  #   * +attributes+ ->
  # [Returns] Link to remove fields.
  ###
  def link_to_remove_fields(name, f, target='this', attributes='')
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(#{target})", attributes)
  end

  ###
  # TODO Doug, Add the Args descriptions.
  # Creates a link to add the given fields.
  # [Args]
  #   * +name+ -> The name of the link.
  #   * +f+ ->
  #   * +association+ ->
  #   * +destination+ ->
  #   * +before+ ->
  #   * +after+ ->
  #   * +attributes+ ->
  # [Returns] Link to add fields.
  ###
  def link_to_add_fields(name, f, association, destination='this', before='', after='', attributes={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render association.to_s.singularize + "_fields", :f => builder
    end
    link_to_function(name, "add_fields(#{destination}, '#{association}', '#{escape_javascript(fields)}', '#{before}', '#{after}')", attributes)
  end

  ###
  # Gets a profiles avatar in the given size format.
  # [Args]
  #   * +size_format+ -> The image size.
  #   * +profile+ -> The profile with an avatar.
  # [Returns] image_tag for avatar.
  ###
  def get_avatar(size_format, profile = nil)
    if profile
      image_tag profile.avatar_url(size_format), :alt => ''
    else
      if profile_active?
        image_tag current_profile.avatar_url(size_format), :alt => ''
      else
        image_tag current_user.user_profile.avatar_url(size_format), :alt => ''
      end
    end
  end

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
    collection = [[ "\u2014 #{blank} \u2014", '' ]]
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
