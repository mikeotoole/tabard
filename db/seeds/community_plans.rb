unless @dont_run
  puts "Creating Community Plans"
  ###
  # Create Themes
  ###

  CommunityPlan.create!({title: "Pro",
        description: "DOUG FIX THIS IN THE SEED!",
        price_per_month_in_cents: 133700,
        is_available: true
        }, without_protection: true)
end