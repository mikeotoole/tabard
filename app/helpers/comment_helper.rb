###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for comments.
###
module CommentHelper

  ###
  # This helper method creates an array of class names based on the given comment's attributes.
  # [Args]
  #   * +comment+ -> The comment to be inspected
  # [Returns] an array of strings
  ###
  def comment_class_names(comment)
    class_names = Array.new()
    class_names << 'removed' if comment.is_removed
    class_names << 'locked' if comment.is_locked
    class_names << 'edited' if comment.has_been_edited
    class_names << 'owned' if comment.user_profile_id == current_user.user_profile_id
    class_names
  end

  ###
  # This helper method sets a word for what happened last to the given comment.
  # [Args]
  #   * +comment+ -> The comment to be inspected
  # [Returns] a string of the action
  ###
  def last_action_word(comment)
    if comment.is_removed
      'removed'
    elsif comment.has_been_edited
      'edited'
    else
      'posted'
    end
  end

  ###
  # This method allows you to pretend a comment was unlocked for the purpose of evaluating permissions
  # [Args]
  #   * +comment+ -> The comment to be proxied
  # [Returns] a comment object
  ###
  def as_unlocked(comment)
    proxy = comment
    proxy.is_locked = false
    proxy
  end
end
