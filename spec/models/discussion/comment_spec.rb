# == Schema Information
#
# Table name: comments
#
#  id                 :integer         not null, primary key
#  body               :text
#  user_profile_id    :integer
#  character_proxy_id :integer
#  community_id       :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  has_been_deleted   :boolean         default(FALSE)
#  has_been_edited    :boolean         default(FALSE)
#  has_been_locked    :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
