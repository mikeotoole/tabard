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
    classes.push 'my_profile' if defined?(@user_profile) and user_signed_in? and current_user.user_profile == @user_profile
    return classes
  end

  ###
  # Formats text for body (page, discussion, etc.)
  ###
  def format_content(content)
    content = Nokogiri::HTML::DocumentFragment.parse(content)
    content = Rinku.auto_link content.to_s, :urls, 'target="blank" rel="nofollow"'
    raw content
  end

  ###
  # Formats text for comments
  ###
  def format_comment(content)
    content = strip_tags content
    content = Rinku.auto_link content, :urls, 'target="_blank" rel="nofollow"'
    raw content
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
  # Provides a list of characters that are within scope of the current action.
  # [Returns] array of characters.
  ###
  def available_characters
    current_user.available_characters(current_community,current_game)
  end

  ###
  # Checks the object, looking for errors on common avatar field names
  # [Returns] true if any errors or found, otherwise false.
  ###
  def object_has_avatar_errors(obj)
    obj.errors[:avatar].any? || obj.errors[:remote_avatar].any? || obj.errors[:remove_avatar_url].any?
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

  ###
  # This method returns an array of US states
  # [Returns] Array of arrays containing US state name and abbreviation
  ###
  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

end
