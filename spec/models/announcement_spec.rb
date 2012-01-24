# == Schema Information
#
# Table name: announcements
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  community_id       :integer
#  supported_game_id  :integer
#  is_locked          :boolean         default(FALSE)
#  deleted_at         :datetime
#  has_been_edited    :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Announcement do
  pending "add some examples to (or delete) #{__FILE__}"
end
