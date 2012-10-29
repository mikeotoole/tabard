require 'spec_helper'

describe "community_games/index" do
  before(:each) do
    assign(:community_games, [
      stub_model(CommunityGame,
        :community_id => 1,
        :game_id => 2,
        :game_announcement_space_id => 3,
        :info => "MyText"
      ),
      stub_model(CommunityGame,
        :community_id => 1,
        :game_id => 2,
        :game_announcement_space_id => 3,
        :info => "MyText"
      )
    ])
  end

  it "renders a list of community_games" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
