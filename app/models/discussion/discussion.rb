class Discussion < ActiveRecord::Base
end

# == Schema Information
#
# Table name: discussions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  comments_enabled    :boolean         default(TRUE)
#  has_been_locked     :boolean         default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

