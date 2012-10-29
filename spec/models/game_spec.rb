# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#

require 'spec_helper'

describe Game do
  let(:swtor) { create(:swtor) }

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
