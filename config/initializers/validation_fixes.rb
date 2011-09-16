class ActiveModel::Errors
  alias :old_full_messages :full_messages
  def full_messages
    old_full_messages.uniq
  end
end