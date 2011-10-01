# == Schema Information
#
# Table name: message_copies
#
#  id           :integer         not null, primary key
#  message_id   :integer
#  recipient_id :integer
#  folder_id    :integer
#  deleted      :boolean         default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe MessageCopy do
  pending "add some examples to (or delete) #{__FILE__}"
end
