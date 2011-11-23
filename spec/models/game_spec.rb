# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  pretty_url :string(255)
#

require 'spec_helper'

describe Game do
  let(:swtor) { Factory.create(:swtor) }

  pending
end
