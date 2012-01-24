class Acknowledgement < ActiveRecord::Base
end

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

