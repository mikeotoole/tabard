unless @dont_run
  puts "Creating Community Plans"
  ###
  # Create Themes
  ###

  plan = CommunityPlan.create!({title: "Pro",
        description: "DOUG FIX THIS IN THE SEED!",
        price_per_month_in_cents: 1337,
        is_available: true
        }, without_protection: true)
  plan.community_upgrades.create!({
    title: "20 User Pack"
    description: "DOUG FIX THIS IN THE SEED!"
    price_per_month_in_cents: 1337,
    max_number_of_upgrades: nil
    }, without_protection: true)
end