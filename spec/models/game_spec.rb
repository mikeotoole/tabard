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

  it "should not allow new instance of base class" do
    assert_raises(ActiveRecord::StatementInvalid) do
      Game.new
    end
  end

  describe "all games" do
    it "should return all games" do
        Game.all_games.should eql Wow.all + Swtor.all
    end
  end  
end
