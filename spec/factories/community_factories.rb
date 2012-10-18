FactoryGirl.define do
  # Create a basic community.
  factory :community do
    sequence(:name) {|n| "Community #{n.to_i.to_s(27).tr("0-9a-q", "A-Z")}#{(n+1).to_i.to_s(27).tr("0-9a-q", "A-Z")}"}
    slogan "Default Community Slogan"
    admin_profile_id { FactoryGirl.create(:user_profile).id }

    factory :pro_community do
      after(:create) do |community|
        community_plan = FactoryGirl.create(:pro_community_plan)
        token = Stripe::Token.create(
            :card => {
            :number => "4242424242424242",
            :exp_month => 8,
            :exp_year => 2023,
            :cvc => 314
          },
        )
        invoice = community.admin_profile.user.current_invoice
        invoice_hash = { "invoice_items_attributes" => { "0" => { "community_id"=>"#{community.id}",
                                                            "item_type"=>"CommunityPlan",
                                                            "quantity"=>"1",
                                                            "item_id"=>"#{community_plan.id}" }}}
        invoice.update_attributes_with_payment(invoice_hash, token.id)
      end

      factory :pro_community_with_user_upgrade do
        after(:create) do |community|
          upgrade = community.current_community_plan.community_upgrades.first
          token = Stripe::Token.create(
              :card => {
              :number => "4242424242424242",
              :exp_month => 8,
              :exp_year => 2023,
              :cvc => 314
            },
          )
          invoice = community.admin_profile.user.current_invoice
          invoice_hash = invoice.invoice_items_attributes
          invoice_hash << { "community_id"=>"#{community.id}",
                                                            "item_type"=>"#{upgrade.class}",
                                                            "quantity"=>"1",
                                                            "item_id"=>"#{upgrade.id}" }
          invoice.update_attributes_with_payment(invoice_hash)
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
