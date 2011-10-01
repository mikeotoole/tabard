# == Schema Information
#
# Table name: folders
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Folder do
  pending "add some examples to (or delete) #{__FILE__}"
end
