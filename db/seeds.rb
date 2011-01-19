# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
userResource = SystemResource.create(:name => "User")
roleResource = SystemResource.create(:name => "Role")

gameResource = SystemResource.create(:name => "Game")
wow = Game.create(:name => "World of Warcraft", :type_helper => "Wow", :is_active => true)
swtor = Game.create(:name => "Star Wars the Old Republic", :type_helper => "Swtor", :is_active => true)
blaggarth = Character.create(:name => "Blaggarth", :faction => "Alliance", :race => "Dwarf", :server => "Medivh", :rank => "10", :game => wow, :type_helper => "WowCharacter")
eliand = Character.create(:name => "Eliand", :faction => "Alliance", :race => "Night Elf", :server => "Medivh", :rank => "10", :game => wow, :type_helper => "WowCharacter")
yoda = Character.create(:name => "Yoda", :faction => "Republic", :race => "Species Unknown", :server => "Obi-Wan", :rank => "10", :game => swtor, :type_helper => "SwtorCharacter")

discussionSpaceResource = SystemResource.create(:name => "DiscussionSpace")
discussionResource = SystemResource.create(:name => "Discussion")
discSpace = DiscussionSpace.create(:name => "General", :system => false)
discSpace1 = DiscussionSpace.create(:name => "Off Topic", :system => false)

pageSpaceResource = SystemResource.create(:name => "PageSpace")
pageResource = SystemResource.create(:name => "Page")
pageSpace = PageSpace.create(:name => "Boss Strategies")
page = Page.create(:title => "Sarlacc Pit", :body => "Don't get eaten! It is really bad. Instead just pew-pew-pew", :page_space => pageSpace)

adminProfile = UserProfile.create(:name => "Admin")

userProfile = UserProfile.create(:name => "RoboBilly")
wowProfile = GameProfile.create(:name => "Wow profile", :characters => [blaggarth,eliand], :game => wow, :user_profile => userProfile)
swtorProfile = GameProfile.create(:name => "SWTOR profile", :characters => [yoda], :game => swtor, :user_profile => userProfile)

allUserPermission = Permission.create(:permissionable => userResource, :name => "Full Access User", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allRolePermission = Permission.create(:permissionable => roleResource, :name => "Full Access Role", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allGamePermission = Permission.create(:permissionable => gameResource, :name => "Full Access Game", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allDiscussionSpacePermission = Permission.create(:permissionable => discussionSpaceResource, :name => "Full Access DiscussionSpace", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allDiscussionPermission = Permission.create(:permissionable => discussionResource, :name => "Full Access Discussion", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allPageSpacePermission = Permission.create(:permissionable => pageSpaceResource, :name => "Full Access PageSpace", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allPagePermission = Permission.create(:permissionable => pageResource, :name => "Full Access Page", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
adminRole = Role.create(:name => "Admin", :permissions => [allUserPermission,allRolePermission,allGamePermission,allDiscussionSpacePermission,allDiscussionPermission,allPageSpacePermission,allPagePermission])
adminUser = User.create(:email => "admin@example.com", :password => "password", :roles => [adminRole], :user_profile => adminProfile, :is_active => true)

viewUserPermission = Permission.create(:permissionable => userResource, :name => "View Access User", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewRolePermission = Permission.create(:permissionable => roleResource, :name => "View Access Role", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewGamePermission = Permission.create(:permissionable => gameResource, :name => "View Access Game", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewGeneralDiscussionSpacePermission = Permission.create(:permissionable => discSpace, :name => "View General Discussion Space", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewerRole = Role.create(:name => "Viewer", :permissions => [viewUserPermission,viewRolePermission,viewGamePermission,viewGeneralDiscussionSpacePermission])
viewUser = User.create(:email => "billy@robo.com", :password => "password", :roles => [viewerRole], :user_profile => userProfile, :is_active => true)

disc = Discussion.create(:name => "NO STICKIES!", :body => "There are no stickies!", :user_profile => adminProfile, :discussion_space => discSpace)
comment1 = Comment.create(:body => "What?! No Stickies!", :user_profile => userProfile, :commentable => disc)
comment2 = Comment.create(:body => " /facepalm", :user_profile => adminProfile, :commentable => comment1)

disc1 = Discussion.create(:name => "OMG?!?!?!??!?!", :body => "They see me trolling...", :user_profile => userProfile, :discussion_space => discSpace1)
disc2 = Discussion.create(:name => "Never gonna..", :body => "RICK ROLLED!", :user_profile => adminProfile, :discussion_space => discSpace1)

