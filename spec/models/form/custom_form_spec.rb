# == Schema Information
#
# Table name: custom_forms
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  message      :text
#  thankyou     :string(255)
#  published    :boolean         default(FALSE)
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe CustomForm do
  pending "add some examples to (or delete) #{__FILE__}"
end
