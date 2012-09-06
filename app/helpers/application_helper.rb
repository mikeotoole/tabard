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
  # Provides a clean way to set the page title within a view and adds the text " | Tabard".
  # [Args]
  #   * +page_title+ -> The page title.
  # [Returns] :title for the yield.
  ###
  def title(page_title)
    content_for(:title) { raw "#{page_title} | Tabard&trade;" }
  end

  ###
  # Gives an array of classes to help view/css rendering on the body tag
  # [Returns] Array of strings (class names)
  ###
  def body_classes
    classes = [params[:controller].gsub(/\//,' '), params[:action]]
    classes.push 'signed_in' if user_signed_in?
    classes.push 'top_level' if current_community
    classes.push 'qstring' unless request.query_string.blank?
    classes.push 'with_action_items' if has_action_items?
    return classes
  end

  ###
  # Checks to see if the page is going to render action items for the community
  # [Returns] True or False
  ###
  def has_action_items?
    current_community and user_signed_in? and current_user.user_profile == current_community.admin_profile and current_community.action_items.any?
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

  ###
  # Shortens long words by placing a separator in the middle of them
  # [Returns] string of shortened words
  ###
  def shorten_words(string, max_size=15, separator='...')
    half_size = (max_size / 2).floor.to_s
    regex = '([^\s]{'+half_size+'})[^\s]{2,}([^\s]{'+half_size+'})'
    string.gsub /#{regex}/, '\1'+separator+'\2'
  end

  ###
  # This method provides the view for a sortable column
  # [Args]
  #   * +column+ -> The DB column to sort on.
  #   * +title+ -> The title for the column.
  # [Returns] the link for the column header.
  ###
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = 'sortable' + (column == sort_column ? " current #{sort_direction}" : '')
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(sort: column, direction: direction, page: nil), {class: css_class}
  end
end
