###
# Helpers
###

def create_event(community_name, name, body, start_in_days, hours, creator_full_name, invite_full_name_array, game_id=nil)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_full_name(creator_full_name)
  community_game = game_id ? community.community_games.find_by_game_id(game_id).first : nil
  start_time = Date.today + start_in_days.days
  end_time = start_time.in(3600 * hours)
  puts "#{user_profile.name} is creating #{community_name} Event #{name}"
  event = community.events.new(name: name, body: body, start_time: start_time, end_time: end_time, community_game: community_game)
  event.creator = user_profile
  event.save!

  event.invites.create!(user_profile: user_profile)
  invite_full_name_array.each do |full_name|
    event.invites.create!(user_profile: UserProfile.find_by_full_name(full_name))
  end

  return event
end


###
# Create Events
###
unless @dont_run
  create_event('Just Another Headshot',
               'Community Meeting',
               "We will be voting on officers.",
               1, 2,
               'Robo Billy',
               %w(Diabolical\ Moose Snappy\ Turtle Dirty\ Badger Mike\ O'Toole))

  create_event('Just Another Headshot',
               'Raid',
               "Lets try not to suck it up.",
               2, 6,
               'Robo Billy',
               %w(Diabolical\ Moose Snappy\ Turtle Dirty\ Badger))

  create_event('Just Another Headshot',
               'Raid 2',
               "Lets try not to suck it up.",
               31, 4,
               'Robo Billy',
               %w(Diabolical\ Moose Snappy\ Turtle Dirty\ Badger))
end