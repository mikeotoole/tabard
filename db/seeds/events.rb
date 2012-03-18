###
# Helpers
###

def create_event(community_name, name, body, start_in_days, hours, creator_last_name, invite_last_name_array, game_type=nil)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_last_name(creator_last_name)
  supported_game = game_type ? community.supported_games.find_by_game_type(game_type).first : nil
  start_time = Date.today + start_in_days.days
  end_time = start_time.in(3600 * hours)
  puts "#{user_profile.name} is creating #{community_name} Event #{name}"
  event = community.events.new(:name => name, :body => body, :start_time => start_time, :end_time => end_time, :supported_game => supported_game)
  event.creator = user_profile
  event.save!
  
  event.invites.create!(:user_profile => user_profile)
  invite_last_name_array.each do |last_name|
    event.invites.create!(:user_profile => UserProfile.find_by_last_name(last_name))
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
               'Billy',
               %w(Moose Turtle Badger O'Toole))

  create_event('Just Another Headshot',
               'Raid',
               "Lets try not to suck it up.",
               2, 6,
               'Billy',
               %w(Moose Turtle Badger))

  create_event('Just Another Headshot',
               'Raid 2',
               "Lets try not to suck it up.",
               31, 4,
               'Billy',
               %w(Moose Turtle Badger))
end