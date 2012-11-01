###
# Helpers
###

def create_discussion_space(creator_full_name, community_name, space_name, faction='')
  puts "Creating #{community_name} discussion space #{space_name}"
  community = Community.find_by_name(community_name)

  case faction
    when 'Horde', 'Alliance'
      game = Wow.all.first
    when 'Empire', 'Republic'
      game = Swtor.all.first
    else
      game = nil
  end
  community_game = game ? community.community_games.where(game_id: game.id).has_faction(faction).limit(1).first : nil

  puts "With game #{community_game.full_name}" if community_game
  ds = community.discussion_spaces.create!(name: space_name, community_game: community_game)
  creator = UserProfile.find_by_full_name(creator_full_name)
  Activity.create!({user_profile: creator, community: community, target: ds, action: "created"}, without_protection: true)
  return ds
end

def create_discussion(community_name, space_name, name, body, poster_full_name)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_full_name(poster_full_name)

  puts "#{user_profile.name} is creating #{community_name} #{space_name} Space Discussion #{name}"
  discussion = community.discussion_spaces.find_by_name(space_name).discussions.new(name: name, body: body)
  discussion.user_profile = user_profile
  discussion.save!
  return discussion
end

def create_comment(commentable, body, poster_full_name)
  user_profile = UserProfile.find_by_full_name(poster_full_name)
  comment = commentable.comments.new(body: body)
  comment.user_profile = user_profile
  comment.save!
  return comment
end

def create_announcement(community_name, name, body, poster_full_name, community_game = nil)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_full_name(poster_full_name)

  puts "#{user_profile.name} is creating #{community_name} Announcement #{name}"
  announcement = community.announcements.new(name: name, body: body, community_game: community_game)
  announcement.user_profile = user_profile
  announcement.save!
  return announcement
end

unless @dont_run

  ###
  # Create Discussion Spaces, Discussions, and Comments
  ###

  # Two Maiden
  create_discussion_space('Kinky Fox', 'Two Maidens', 'General Chat')
  create_discussion_space('Kinky Fox', 'Two Maidens', 'WoW', 'Horde')

  # Just Another Headshot
  create_discussion_space('Robo Billy', 'Just Another Headshot', 'General Chat')
  create_discussion_space('Robo Billy', 'Just Another Headshot', 'WoW Discussions', 'Horde')
  create_discussion_space('Robo Billy', 'Just Another Headshot', 'SWTOR Discussions', 'Empire')

  jahc_gd = create_discussion('Just Another Headshot', 'General Chat', 'What up hommies!?', 'How was your weekend?', 'Robo Billy')
  create_discussion('Just Another Headshot', 'WoW Discussions', 'General WoW Discussion', 'YAY lets discuss WoW', 'Snappy Turtle')
  create_discussion('Just Another Headshot', 'SWTOR Discussions', 'General SWTOR Discussion', 'YAY lets discuss SWTOR', 'Dirty Badger')

  puts "Adding comments to general discussion space discussion"
  comment1 = create_comment(jahc_gd, "What's up RoboBilly!", 'Diabolical Moose')
  comment1a = create_comment(comment1, "What's up Diabolical Moose!", 'Snappy Turtle')
  comment1b = create_comment(comment1, "You guys are weird.", 'Dirty Badger')
  comment1b2 = create_comment(comment1b, "No, you are.", 'Diabolical Moose')
  comment2 = create_comment(jahc_gd, "Herp a derp.", 'Robo Billy')
  comment2.update_attributes!(has_been_edited: true)

  puts "Time: 3 weeks ago"
  Timecop.freeze(3.weeks.ago)
  create_announcement('Just Another Headshot',
                      'This announcement is derp old',
                      "So old in fact, it's in Latin! Nunc sem purus, posuere eu ullamcorper ac, vulputate ac dolor. Donec id mi eget lacus venenatis dignissim.",
                      'Robo Billy')

  puts "Time: Now"
  Timecop.return

  create_announcement('Just Another Headshot',
                      'Website is up and running!',
                      "This new website is off the hook!.",
                      'Robo Billy')
  create_announcement('Just Another Headshot',
                      'WoW is now supported!',
                      "Everyone add your WoW characters.",
                      'Robo Billy')
  create_announcement('Just Another Headshot',
                      'Star Wars is bad ass!',
                      "Raids are super cool. The new vent channel is open for SWTOR.",
                      'Robo Billy',
                      Community.find_by_name('Just Another Headshot').community_games.find_by_game_id(Swtor.all.first.id))
  create_announcement('Just Another Headshot',
                      'This is my favorite community_game',
                      "LOLOLOLOLOLOLOLOLOL",
                      'Robo Billy',
                      Community.find_by_name('Just Another Headshot').community_games.find_by_game_id(Wow.all.first.id))
  create_announcement('Jedi Kittens',
                      'Star Wars is mew mew mew!',
                      "Raids are super mew. The new vent channel is open for SWTOR.",
                      'Apathetic Tiger',
                      Community.find_by_name('Just Another Headshot').community_games.find_by_game_id(Swtor.all.first.id))

end
