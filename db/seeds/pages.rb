###
# Helpers
###

# Create a page space
def create_page_space(creator_full_name, community_name, space_name, faction='')
  puts "Creating #{community_name} page space #{space_name}"
  community = Community.find_by_name(community_name)

  case faction
    when 'Horde', 'Alliance'
      game = Wow.all.first
    when 'Empire', 'Republic'
      game = Swtor.all.first
    else
      game = nil
  end
  community_game = game ? CommunityGame.find_by_game_and_faction(community, game, faction) : nil

  creator = UserProfile.find_by_full_name(creator_full_name)

  puts "With game #{community_game.game_full_name}" if community_game
  ps = community.page_spaces.create!(name: space_name, community_game: community_game)
  Activity.create!({user_profile: creator, community: community, target: ps, action: "created"}, without_protection: true)
  return ps
end

# Create a page with Lorem Ipsum body
def create_page(creator_full_name, community_name, space_name, page_name, markup=nil)
  puts "Creating #{community_name} #{page_name} page"
  markup ||= "##Heading\n###H3\nPhasellus ornare lacus eu neque hendrerit iaculis in in neque. Phasellus dolor velit, ultrices tempor porttitor eget, lacinia id risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non. Phasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sapien."
  creator = UserProfile.find_by_full_name(creator_full_name)
  community = Community.find_by_name(community_name)
  page = community.page_spaces.find_by_name(space_name).pages.create!(name: page_name,
    markup: markup)
  Activity.create!({user_profile: creator, community: community, target: page, action: "created"}, without_protection: true)
end

unless @dont_run

  ###
  # Create Pages
  ###

  # Just Another Headshot
  create_page_space('Robo Billy', 'Just Another Headshot', 'Guild Info')
  create_page_space('Robo Billy', 'Just Another Headshot', 'WoW Resources', 'Horde')

  create_page('Robo Billy', 'Just Another Headshot', 'Guild Info', 'Guild Rules')
  create_page('Robo Billy', 'Just Another Headshot', 'WoW Resources', 'WoW Strategies')

end
