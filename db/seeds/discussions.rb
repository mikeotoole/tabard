###
# Helpers
###

def create_discussion_space(creater_last_name, community_name, space_name, faction='')
  puts "Creating #{community_name} discussion space #{space_name}"
  community = Community.find_by_name(community_name)

  case faction
    when 'Horde'
      game = Wow.find(:first, :conditions => {:faction => "Horde"})
    when 'Alliance'
      game = Wow.find(:first, :conditions => {:faction => "Alliance"})
    when 'Empire'
      game = Swtor.find(:first, :conditions => {:faction => "Empire"})
    when 'Republic'
      game = Swtor.find(:first, :conditions => {:faction => "Republic"})
    else
      game = nil
  end
  supported_game = game ? community.supported_games.find_by_game_id_and_game_type(game.id, game.class.name) : nil

  puts "With game #{supported_game.game_name}" if supported_game
  ds = community.discussion_spaces.create!(:name => space_name, :supported_game => supported_game)
  creater = UserProfile.find_by_last_name(creater_last_name)
  Activity.create!(:user_profile => creater, :community => community, :target => ds, :action => "created")
end

def create_discussion(community_name, space_name, name, body, poster_last_name)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_last_name(poster_last_name)

  puts "#{user_profile.name} is creating #{community_name} #{space_name} Space Discussion #{name}"
  discussion = community.discussion_spaces.find_by_name(space_name).discussions.new(:name => name, :body => body)
  discussion.user_profile = user_profile
  discussion.save!
  return discussion
end

def create_comment(commentable, body, poster_last_name)
  user_profile = UserProfile.find_by_last_name(poster_last_name)
  comment = commentable.comments.new(:body => body)
  comment.user_profile = user_profile
  comment.save!
  return comment
end

def create_announcement(community_name, name, body, poster_last_name)
  community = Community.find_by_name(community_name)
  user_profile = UserProfile.find_by_last_name(poster_last_name)

  puts "#{user_profile.name} is creating #{community_name} Announcement #{name}"
  announcement = community.community_announcement_space.discussions.new(:name => name, :body => body)
  announcement.user_profile = user_profile
  announcement.save!
  return announcement
end

unless @dont_run

  ###
  # Create Discussion Spaces, Discussions, and Comments
  ###

  # Two Maiden
  create_discussion_space('Fox', 'Two Maidens', 'General Chat')
  create_discussion_space('Fox', 'Two Maidens', 'WoW', 'Horde')

  # Just Another Headshot
  create_discussion_space('Billy', 'Just Another Headshot', 'General Chat')
  create_discussion_space('Billy', 'Just Another Headshot', 'WoW Discussions', 'Horde')
  create_discussion_space('Billy', 'Just Another Headshot', 'SWTOR Discussions', 'Empire')

  jahc_gd = create_discussion('Just Another Headshot', 'General Chat', 'What up hommies!?', 'How was your weekend?', 'Billy')
  create_discussion('Just Another Headshot', 'WoW Discussions', 'General WoW Discussion', 'YAY lets discuss WoW', 'Turtle')
  create_discussion('Just Another Headshot', 'SWTOR Discussions', 'General SWTOR Discussion', 'YAY lets discuss SWTOR', 'Badger')

  puts "Adding comments to general discussion space discussion"
  comment1 = create_comment(jahc_gd, "What's up RoboBilly!", 'Moose')
  comment1a = create_comment(comment1, "What's up Diabolical Moose!", 'Turtle')
  comment1b = create_comment(comment1, "You guys are weird.", 'Badger')
  comment1b2 = create_comment(comment1b, "No, you are.", 'Moose')
  comment2 = create_comment(jahc_gd, "Herp a derp.", 'Billy')
  comment2.update_attributes!(:has_been_edited => true)

  puts "Time: 3 weeks ago"
  Timecop.freeze(3.weeks.ago)
  create_announcement('Just Another Headshot',
                      'This announcement is derp old',
                      "So old in fact, it's in Latin! Nunc sem purus, posuere eu ullamcorper ac, vulputate ac dolor. Donec id mi eget lacus venenatis dignissim.",
                      'Billy')

  puts "Time: Now"
  Timecop.return

  create_announcement('Just Another Headshot',
                      'Website is up and running!',
                      "This new website is off the hook!.",
                      'Billy')
  create_announcement('Just Another Headshot',
                      'WoW is now supported!',
                      "Everyone add your WoW characters.",
                      'Billy')
  create_announcement('Just Another Headshot',
                      'Star Wars is bad ass!',
                      "Raids are super cool. The new vent channel is open for SWTOR.",
                      'Billy')

end
