FactoryGirl.define do
  # Create a basic community profile.
  factory :community_profile do
    user_profile
    community
    roles { [community.member_role] }
    community_application { FactoryGirl.create(:community_application, characters: Array.new, community: community, user_profile: user_profile, submission: FactoryGirl.create(:submission, :custom_form_id => community.community_application_form.id, :user_profile_id => user_profile.id))}
  end

  factory :community_profile_with_community_games, :parent => :community_profile do
    community { FactoryGirl.create(:community_with_community_games) }
  end

  factory :community_profile_with_nil_community, :parent => :community_profile do
    after(:build) do |profile|
      profile.community_id = nil
    end
  end

  factory :community_profile_with_characters, :parent => :community_profile do
    community { FactoryGirl.create(:community_with_community_games) }
    after(:create) do |community_profile|
      wow_game = community_profile.community.community_games.joins{:game}.where{games.type == 'Wow'}.first
      swtor_game = community_profile.community.community_games.joins{:game}.where{games.type == 'Swtor'}.first
      3.times do
        community_profile.approved_roster_assignments.create(:character => FactoryGirl.create(:wow_character, :user_profile => community_profile.user_profile), :community_game => wow_game) if wow_game
        community_profile.approved_roster_assignments.create(:character => FactoryGirl.create(:swtor_character, :user_profile => community_profile.user_profile), :community_game => swtor_game) if swtor_game
      end
      2.times do
        community_profile.pending_roster_assignments.create(:character => FactoryGirl.create(:wow_character, :user_profile => community_profile.user_profile), :community_game => wow_game) if wow_game
        community_profile.pending_roster_assignments.create(:character => FactoryGirl.create(:swtor_character, :user_profile => community_profile.user_profile), :community_game => swtor_game) if swtor_game
      end
    end
  end
end
