# == Schema Information
#
# Table name: acknowledgements
#
#  id                   :integer         not null, primary key
#  community_profile_id :integer
#  announcement_id      :integer
#  has_been_viewed      :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Acknowledgement do
  pending "add some examples to (or delete) #{__FILE__}"
end
