# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
if ENV["RAILS_ENV"] != 'test'
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

puts "RoboBilly is creating Just Another Headshot Clan..."
jahc = robobilly.owned_communities.create(:name => "Just Another Headshot", :slogan => "Boom baby!", :label => "Clan")

puts "RoboBilly is creating a n00b role..."
noob_role = jahc.roles.create(:name => "n00b")

puts "RoboBilly is adding permissions to view roles to n00b role..."
noob_role.permissions.create(:subject_class => "Role", :permission_level => "Show")

# TODO Mike/Joe Make DMoose + STurtle Apply to the community -JW

puts "Making Diabolical Moose, Snappy Turtle and Dirty Badger members of Just Another Headshot Clan..."
jahc.promote_user_profile_to_member(d_moose.user_profile)
jahc.promote_user_profile_to_member(s_turtle.user_profile)
jahc.promote_user_profile_to_member(d_badger.user_profile)

puts "Giving D-Moose the n00b role..."
d_moose.add_new_role(noob_role)

puts "Creating SWTOR Game"
swtor = Game.create(:name => "Star Wars the Old Republic", :type => "Swtor")

puts "Creating WoW Game"
wow = Game.create(:name => "World of Warcraft", :type => "Wow")

puts "Creating Just Another Headshot Clan General Discussion Space"
gds = jahc.discussion_spaces.new(:name => "General Discussion Space")
gds.user_profile = robobilly.user_profile
gds.save

puts "Creating Just Another Headshot Clan WoW Discussion Space"
wds = jahc.discussion_spaces.new(:name => "WoW Discussion Space", :game => wow)
wds.user_profile = robobilly.user_profile
wds.save

puts "Creating Just Another Headshot Clan SWTOR Discussion Space"
sds = jahc.discussion_spaces.new(:name => "SWTOR Discussion Space", :game => swtor)
sds.user_profile = robobilly.user_profile
sds.save

puts "Creating Just Another Headshot Clan General Discussion Space Discussion"
gd = gds.discussions.new(:name => "General Discussion Space", :body => "Whats up team?")
gd.user_profile = robobilly.user_profile
gd.save

puts "Creating Just Another Headshot Clan WoW Discussion Space Discussion"
wd = wds.discussions.new(:name => "General WoW Discussion", :body => "YAY lets discuss WoW")
wd.user_profile = robobilly.user_profile
wd.save

puts "Creating Just Another Headshot Clan SWTOR Discussion Space Discussion"
sd = sds.discussions.new(:name => "General SWTOR Discussion", :body => "YAY lets discuss WoW")
sd.user_profile = robobilly.user_profile
sd.save

puts "Adding comments to general discussion space discussion"
comment1 = gd.comments.new(:body => "What's up RoboBilly!")
comment1.user_profile = d_moose.user_profile
comment1.save
comment2 = comment1.comments.new(:body => "What's up Diabolical Moose!")
comment2.user_profile = s_turtle.user_profile
comment2.save

end
