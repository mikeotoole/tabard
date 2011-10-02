# == Schema Information
#
# Table name: message_associations
#
#  id           :integer         not null, primary key
#  message_id   :integer
#  recipient_id :integer
#  folder_id    :integer
#  deleted      :boolean         default(FALSE)
#  updated_at   :datetime
#

require 'spec_helper'

describe MessageAssociation do
  pending "add some examples to (or delete) #{__FILE__}"
end
