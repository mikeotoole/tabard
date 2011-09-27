# == Schema Information
#
# Table name: pages
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  page_space_id      :integer
#  show_in_navigation :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
