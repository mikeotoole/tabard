unless @dont_run
  puts "Creating Community Plans"
  ###
  # Create Themes
  ###

  plan = CommunityPlan.create!({
      title: "Pro Community",
      description: "Full featured access for up to 100 members.",
      price_per_month_in_cents: 1000,
      is_available: true,
      max_number_of_users: 100
    }, without_protection: true)

  plan.community_upgrades.create!({
      title: "20 Member Pack",
      description: "Add room for 20 more members to your Pro Community.",
      type: "CommunityUserPackUpgrade",
      price_per_month_in_cents: 200,
      upgrade_options: {number_of_users: 20},
      max_number_of_upgrades: 45
    }, without_protection: true)
end