# == Schema Information
#
# Table name: messages
#
#  id                :integer         not null, primary key
#  subject           :string(255)
#  body              :text
#  author_id         :integer
#  number_recipients :integer
#  system_sent       :boolean         default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
end
