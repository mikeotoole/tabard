# == Schema Information
#
# Table name: character_proxies
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  character_id    :integer
#  character_type  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class CharacterProxyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
