# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
if ENV["RAILS_ENV"] != 'test' # TODO Joe, What is this for? -MO


# Create a default user
puts "Creating default active admin user"
AdminUser.create!(:email => 'admin@example.com', :password => 'Password', :password_confirmation => 'Password')

puts "Creating Games..."
wow_game = Wow.create(:name => "World of Warcraft", :pretty_url => 'world-of-warcraft-guilds')
swtor_game = Swtor.create(:name => "Star Wars the Old Republic", :pretty_url => 'star-wars-old-republic-guilds')

puts "Creating RoboBilly!"
robobilly = User.new(:email => "billy@robo.com", :password => "Password",
    :user_profile_attributes => {:first_name => "Robo", :last_name => "Billy", :display_name => "Robo Billy"})
robobilly.skip_confirmation!
robobilly.save

puts "Createing Diabolical Moose!"
d_moose = User.new(:email => "diabolical@moose.com", :password => "Password",
    :user_profile_attributes => {:first_name => "Diabolical", :last_name => "Moose", :display_name => "Diabolical Moose"})
d_moose.skip_confirmation!
d_moose.save

puts "Creating Snappy Turtle!"
s_turtle = User.new(:email => "snappy@turtle.com", :password => "Password",
                   :user_profile_attributes => {:first_name => "Snappy", :last_name => "Turtle", :display_name => "Snappy Turtle"})
s_turtle.skip_confirmation!
s_turtle.save

puts "Creating Dirty Badger!"
d_badger = User.new(:email => "dirty@badger.com", :password => "Password",
                    :user_profile_attributes => {:first_name => "Dirty", :last_name => "Badger", :display_name => "Dirty Badger"})
d_badger.skip_confirmation!
d_badger.save

puts "Creating Kinky Fox!"
k_fox = User.new(:email => "kinky@fox.com", :password => "Password",
                   :user_profile_attributes => {:first_name => "Kinky", :last_name => "Fox", :display_name => "Kinky Fox"})
k_fox.skip_confirmation!
k_fox.save
miss_fox = WowCharacter.create(:name => "Miss Fox",
  :game => wow_game,
  :server => "Default WOW Server",
  :faction => "Horde",
  :race => "Goblin",
  :level => 20)
k_fox.character_proxies.create(:user_profile => k_fox.user_profile,
  :character => miss_fox
)

puts "RoboBilly is creating Just Another Headshot Community with the game SWTOR!"
jahc = robobilly.owned_communities.create(:name => "Just Another Headshot", :slogan => "Boom baby!")
jahc.games << swtor_game
jahc.games << wow_game

puts "RoboBilly is creating a n00b role..."
noob_role = jahc.roles.create(:name => "n00b")

puts "RoboBilly is adding permissions to view roles to n00b role..."
noob_role.permissions.create(:subject_class => "Role", :permission_level => "Show")

puts "RoboBilly is getting some characters..."
rb_cp = robobilly.community_profiles.where(:community_id => jahc.id).first
['Yoda','Han Solo','Chewbacca','R2D2'].each do |cname|
  proxy = robobilly.user_profile.character_proxies.create(:character => SwtorCharacter.create(:name => cname, :server => "Herp Derp", :game => swtor_game))
  rb_cp.approved_character_proxies << proxy
end
['Eliand','Blaggarth','Drejan'].each do |cname|
  proxy = robobilly.user_profile.character_proxies.create(:character => WowCharacter.create(:name => cname, :server => "Manamana", :game => wow_game))
  rb_cp.approved_character_proxies << proxy
end

# TODO Mike/Joe Make DMoose + STurtle Apply to the community -JW

puts "Making Diabolical Moose, Snappy Turtle and Dirty Badger members of Just Another Headshot Clan..."
jahc.promote_user_profile_to_member(d_moose.user_profile)
jahc.promote_user_profile_to_member(s_turtle.user_profile)
jahc.promote_user_profile_to_member(d_badger.user_profile)

puts "Giving D-Moose the n00b role..."
d_moose.add_new_role(noob_role)

puts "Creating Just Another Headshot Clan General Discussion Space"
gds = jahc.discussion_spaces.create(:name => "General Chat")

puts "Creating Just Another Headshot Clan WoW Discussion Space"
wds = jahc.discussion_spaces.create(:name => "WoW", :game_id => wow_game.id)

puts "Creating Just Another Headshot Clan SWTOR Discussion Space"
sds = jahc.discussion_spaces.create(:name => "SWTOR", :game_id => swtor_game.id)

puts "Creating Just Another Headshot Clan General Discussion Space Discussion"
gd = gds.discussions.new(:name => "What up hommies!?", :body => "How was your weekend?")
gd.user_profile = robobilly.user_profile
gd.save

puts "Creating Just Another Headshot Clan WoW Discussion Space Discussion"
wd = wds.discussions.create(:name => "General WoW Discussion", :body => "YAY lets discuss WoW")

puts "Creating Just Another Headshot Clan SWTOR Discussion Space Discussion"
sd = sds.discussions.create(:name => "General SWTOR Discussion", :body => "YAY lets discuss SWTOR")

puts "Adding comments to general discussion space discussion"
comment1 = gd.comments.new(:body => "What's up RoboBilly!")
comment1.user_profile = d_moose.user_profile
comment1.save
comment1a = comment1.comments.new(:body => "What's up Diabolical Moose!")
comment1a.user_profile = s_turtle.user_profile
comment1a.save
comment1b = comment1.comments.new(:body => "You guys are weird.")
comment1b.user_profile = d_badger.user_profile
comment1b.save
comment1b2 = comment1b.comments.new(:body => "No, you are.")
comment1b2.user_profile = d_moose.user_profile
comment1b2.save
comment2 = gd.comments.new(:body => "Herp a derp.")
comment2.user_profile = k_fox.user_profile
comment2.has_been_edited = true
comment2.save

puts "Adding announcements for Just Another Headshot Clan"
announcement1 = jahc.community_announcement_space.discussions.new(:name => "Website is up and running!", :body => "This new website is off the hook!")
announcement1.user_profile = robobilly.user_profile
announcement1.save
announcement2 = jahc.game_announcement_spaces.first.discussions.new(:name => "Star Wars is bad ass!", :body => "Raids are super cool. The new vent channel is open for SWTOR.")
announcement2.user_profile = robobilly.user_profile
announcement2.save
announcement3 = jahc.game_announcement_spaces.last.discussions.new(:name => "WoW is now supported!", :body => "Everyone add your WoW characters.")
announcement3.user_profile = robobilly.user_profile
announcement3.save

puts "Creating Just Another Headshot Clan Guild Info Page Space"
gips = jahc.page_spaces.create(:name => "Guild Info")

puts "Creating Just Another Headshot Clan WoW Page Space"
wps = jahc.page_spaces.create(:name => "WoW Resources", :game_id => wow_game.id)

puts "Creating Just Another Headshot Clan Guild Rules Page"
g_rules = gips.pages.new(:name => "Guild Rules", :markup => "##Guild Rules##\n 1. Don't be dumb\n 2. IF YOU DON'T KNOW WHAT TO DO THAT IS A 50 KPD MINUS!")
g_rules.user_profile = robobilly.user_profile
g_rules.save

puts "Creating Just Another Headshot WoW Strategies Page"
wow_strategies = wps.pages.new(:name => "WoW Strategies", :markup => "##WoW Strategies##\n###Sarlacc Pit Strategy###\n* Don't get eaten!\n** It is really bad.\n** Instead just pew-pew-pew")
wow_strategies.user_profile = s_turtle.user_profile
wow_strategies.save

puts "Creating Example Messages"
robobilly.sent_messages.create(:subject => "Test Seeded Message From robobilly", :body => "This is a test message created in the seed file.", :to => [d_moose.id, d_badger.id])
d_moose.sent_messages.create(:subject => "Test Seeded Message From moose", :body => "This is a test message created in the seed file.", :to => [robobilly.id, d_badger.id])

end
