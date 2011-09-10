# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  is_active  :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Swtor do
  let(:swtor) { Factory.create(:swtor) }

  it "should create a new instance given valid attributes" do
    swtor.should be_valid
  end
end
