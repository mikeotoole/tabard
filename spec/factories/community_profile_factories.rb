FactoryGirl.define do
  # Create a basic community profile.
  factory :community_profile do
    user_profile
    community
    roles { [community.member_role] }
  end

  factory :community_profile_with_supported_games, :parent => :community_profile do
    community { FactoryGirl.create(:community_with_supported_games) }
  end

  factory :community_profile_with_nil_community, :parent => :community_profile do
    after_build do |profile|
      profile.update_attribute(:community, nil)
    end
  end

  factory :community_profile_with_characters, :parent => :community_profile do
    community { FactoryGirl.create(:community_with_supported_games) }
    after_create do |community_profile|
      3.times do
        community_profile.approved_roster_assignments.create(:character_proxy => FactoryGirl.create(:character_proxy_with_wow_character, :user_profile => community_profile.user_profile), :supported_game => community_profile.community.supported_games.where(:game_type => "Wow").first) if community_profile.community.supported_games.where(:game_type => "Wow").first 
        community_profile.approved_roster_assignments.create(:character_proxy => FactoryGirl.create(:character_proxy_with_swtor_character, :user_profile => community_profile.user_profile), :supported_game => community_profile.community.supported_games.where(:game_type => "Swtor").first) if community_profile.community.supported_games.where(:game_type => "Swtor").first
      end
      2.times do
        community_profile.pending_roster_assignments.create(:character_proxy => FactoryGirl.create(:character_proxy_with_wow_character, :user_profile => community_profile.user_profile), :supported_game => community_profile.community.supported_games.where(:game_type => "Wow").first) if community_profile.community.supported_games.where(:game_type => "Wow").first 
        community_profile.pending_roster_assignments.create(:character_proxy => FactoryGirl.create(:character_proxy_with_swtor_character, :user_profile => community_profile.user_profile), :supported_game => community_profile.community.supported_games.where(:game_type => "Swtor").first) if community_profile.community.supported_games.where(:game_type => "Swtor").first
      end
    end
  end
end