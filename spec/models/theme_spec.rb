# == Schema Information
#
# Table name: themes
#
#  id               :integer         not null, primary key
#  community_id     :integer
#  background_image :string(255)
#  predefined_theme :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Theme do
  pending "add some examples to (or delete) #{__FILE__}"
end
