# == Schema Information
#
# Table name: themes
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  css        :string(255)
#  author     :string(255)
#  author_url :string(255)
#  thumbnail  :string(255)
#

require 'spec_helper'

describe Theme do
  pending "add some examples to (or delete) #{__FILE__}"
end
