FactoryGirl.define do
  # Create a basic community.
  factory :community do
    sequence(:name) {|n| "Community #{n.to_i.to_s(27).tr("0-9a-q", "A-Z")}#{(n+1).to_i.to_s(27).tr("0-9a-q", "A-Z")}"}
    slogan "Default Community Slogan"
    admin_profile_id { FactoryGirl.create(:user_profile).id }

    factory :pro_community do
      after(:create) do |community|
        FactoryGirl.create(:pro_comm_invoice_item, :community_id => community.id)
      end

      factory :pro_community_with_user_upgrade do
        after(:create) do |community|
          FactoryGirl.create(:user_pack_invoice_item, :community_id => community.id)
        end
      end
    end
  end

  factory :community_with_supported_games, :parent => :community do
    sequence(:name) {|n| "Community #{n}"}
    slogan "Default Community Slogan"
    admin_profile
    after(:create) do |community|
      FactoryGirl.create(:wow_supported_game, :community_id => community.id)
      FactoryGirl.create(:swtor_supported_game, :community_id => community.id)
    end
  end
end
