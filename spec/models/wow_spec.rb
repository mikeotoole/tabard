# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  info       :hstore
#  aliases    :string(255)
#

require 'spec_helper'

describe Wow do
  let(:wow) { create(:wow) }

  it "should create a new instance given valid attributes" do
    wow.should be_valid
  end
end
