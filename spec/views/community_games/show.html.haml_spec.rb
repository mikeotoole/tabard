require 'spec_helper'

describe "community_games/show" do
  before(:each) do
    @community_game = assign(:community_game, stub_model(CommunityGame,
      :community_id => 1,
      :game_id => 2,
      :game_announcement_space_id => 3,
      :info => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/MyText/)
  end
end
