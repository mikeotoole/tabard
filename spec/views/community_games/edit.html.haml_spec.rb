require 'spec_helper'

describe "community_games/edit" do
  before(:each) do
    @community_game = assign(:community_game, stub_model(CommunityGame,
      :community_id => 1,
      :game_id => 1,
      :game_announcement_space_id => 1,
      :info => "MyText"
    ))
  end

  it "renders the edit community_game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => community_games_path(@community_game), :method => "post" do
      assert_select "input#community_game_community_id", :name => "community_game[community_id]"
      assert_select "input#community_game_game_id", :name => "community_game[game_id]"
      assert_select "input#community_game_game_announcement_space_id", :name => "community_game[game_announcement_space_id]"
      assert_select "textarea#community_game_info", :name => "community_game[info]"
    end
  end
end
