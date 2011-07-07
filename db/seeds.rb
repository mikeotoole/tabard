# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
userResource = SystemResource.create(:name => "User")
roleResource = SystemResource.create(:name => "Role")
siteFormResource = SystemResource.create(:name => "SiteForm")
registrationApplicationResource = SystemResource.create(:name => "RegistrationApplication")
newsletterResource = SystemResource.create(:name => "Newsletter")
themeResource = SystemResource.create(:name => "Theme")
teamspeakResource = SystemResource.create(:name => "Teamspeak")

gameResource = SystemResource.create(:name => "Game")
characterResource = SystemResource.create(:name => "Character")

# Sample Games
wow = Game.create(:name => "World of Warcraft", :type_helper => "Wow", :is_active => true)
swtor = Game.create(:name => "Star Wars the Old Republic", :type_helper => "Swtor", :is_active => true)

commentResource = SystemResource.create(:name => "Comment")

discussionSpaceResource = SystemResource.create(:name => "DiscussionSpace")
discussionResource = SystemResource.create(:name => "Discussion")

siteAnnouncementResource = SystemResource.create(:name => "SiteAnnouncement")
gameAnnouncementResource = SystemResource.create(:name => "GameAnnouncement")

pageSpaceResource = SystemResource.create(:name => "PageSpace")
pageResource = SystemResource.create(:name => "Page")

# Sample Communities
stonewatch = Community.create(:name => "Stonewatch", :slogan => "We wear pants and eat food.", :label => "Guild", :accepting => true)
just_another_headshot = Community.create(:name => "Just Another Headshot", :slogan => "Boom baby!", :label => "Clan", :accepting => false)


# Admin User
adminProfile = UserProfile.create(:name => "Admin")
adminProfile.set_active

allUserPermission = Permission.create(:permissionable => userResource, :name => "Full Access User", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allRolePermission = Permission.create(:permissionable => roleResource, :name => "Full Access Role", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allGamePermission = Permission.create(:permissionable => gameResource, :name => "Full Access Game", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allCharacterPermission = Permission.create(:permissionable => characterResource, :name => "Full Access Character", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allSiteAnnouncementPermission = Permission.create(:permissionable => siteAnnouncementResource, :name => "Full Access SiteAnnouncement", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allGameAnnouncementPermission = Permission.create(:permissionable => gameAnnouncementResource, :name => "Full Access GameAnnouncement", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allDiscussionSpacePermission = Permission.create(:permissionable => discussionSpaceResource, :name => "Full Access DiscussionSpace", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allDiscussionPermission = Permission.create(:permissionable => discussionResource, :name => "Full Access Discussion", :show_p => true, :create_p => true, :update_p => true, :delete_p => true, :access => "lock")
allCommentPermission = Permission.create(:permissionable => commentResource, :name => "Full Access Comment", :show_p => true, :create_p => true, :update_p => true, :delete_p => true, :access => "lock")
allPageSpacePermission = Permission.create(:permissionable => pageSpaceResource, :name => "Full Access PageSpace", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allPagePermission = Permission.create(:permissionable => pageResource, :name => "Full Access Page", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allSiteFormPermission = Permission.create(:permissionable => siteFormResource, :name => "Full Access Site Form", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allRegistrationApplicationPermission = Permission.create(:permissionable => registrationApplicationResource, :name => "Full Access Registration Application", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allNewsletterPermission = Permission.create(:permissionable => newsletterResource, :name => "Full Access Newsletter", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allThemePermission = Permission.create(:permissionable => themeResource, :name => "Full Access Theme", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
allTeamspeakPermission = Permission.create(:permissionable => teamspeakResource, :name => "Full Access Teamspeak", :show_p => true, :create_p => true, :update_p => true, :delete_p => true)
adminRole = Role.create(:name => "Admin", :permissions => [allUserPermission,allRolePermission,allGamePermission,allCharacterPermission,allDiscussionSpacePermission,allSiteAnnouncementPermission,allGameAnnouncementPermission,allDiscussionPermission,allCommentPermission,allPageSpacePermission,allPagePermission,allSiteFormPermission,allRegistrationApplicationPermission,allNewsletterPermission,allThemePermission,allTeamspeakPermission])
adminUser = User.create(:email => "admin@example.com", :password => "password", :roles => [adminRole], :user_profile => adminProfile)

# Sample Discussion Spaces
discSpace = DiscussionSpace.create(:name => "General", :system => false, :user_profile => adminProfile)
discSpace1 = DiscussionSpace.create(:name => "Off Topic", :system => false, :user_profile => adminProfile)

# General User
userProfile = UserProfile.create(:name => "RoboBilly")
userProfile.set_active

blaggarth = WowCharacter.create(:name => "Blaggarth", :faction => "Alliance", :race => "Dwarf", :server => "Medivh", :level => "10", :game => wow)
eliand = WowCharacter.create(:name => "Eliand", :faction => "Alliance", :race => "Night Elf", :server => "Medivh", :level => "10", :game => wow)
yoda = SwtorCharacter.create(:name => "Yoda", :server => "Obi-Wan", :game => swtor)



wowProfile = GameProfile.create(:name => "Wow profile", :game => wow, :user_profile => userProfile)
swtorProfile = GameProfile.create(:name => "SWTOR profile", :game => swtor, :user_profile => userProfile)

bcp = CharacterProxy.create(:character => blaggarth, :game_profile => wowProfile)
ecp = CharacterProxy.create(:character => eliand, :game_profile => wowProfile)
ycp = CharacterProxy.create(:character => yoda, :game_profile => swtorProfile)

viewUserPermission = Permission.create(:permissionable => userResource, :name => "View Access User", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewRolePermission = Permission.create(:permissionable => roleResource, :name => "View Access Role", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewGamePermission = Permission.create(:permissionable => gameResource, :name => "View Access Game", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewCharacterPermission = Permission.create(:permissionable => characterResource, :name => "View Access Character", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewGeneralDiscussionSpacePermission = Permission.create(:permissionable => discSpace, :name => "View General Discussion Space", :show_p => true, :create_p => false, :update_p => false, :delete_p => false)
viewCommentPermission = Permission.create(:permissionable => commentResource, :name => "Full Access Comment", :show_p => true, :create_p => true, :update_p => true, :delete_p => false)
viewerRole = Role.create(:name => "Viewer", :default_role => true, :permissions => [viewUserPermission,viewRolePermission,viewGamePermission,viewCharacterPermission,viewGeneralDiscussionSpacePermission,viewCommentPermission])
viewUser = User.create(:email => "billy@robo.com", :password => "password", :user_profile => userProfile)

dMooseProfile = UserProfile.create(:name => "DiabolicalMoose")
dMooseProfile.set_active
dMooseUser = User.create(:email => "Diabolical@Moose.com", :password => "password", :user_profile => dMooseProfile)

#More General Users
1.upto(20) { |n|
  g_profile = UserProfile.create(:name => "guser_#{n}")
  g_profile.set_active
  g_user = User.create(:email => "g#{n}@user.com", :password => "password", :user_profile => g_profile)
}



#Registration application site form creation
defaultForm = SiteForm.create(:name => "Registration Application Form", :message => "Welcome! Please follow the 3 step applcation process to apply for the guild.", :thankyou => "Thank you for submitting your application.", :registration_application_form => true, :published => true)
checkboxQ = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => defaultForm)
PredefinedAnswer.create(:content => "Happy", :question => checkboxQ)
PredefinedAnswer.create(:content => "Sad", :question => checkboxQ)
PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ)
comboboxQ = ComboBoxQuestion.create(:content => "Combo boxes are?", :site_form => defaultForm)
PredefinedAnswer.create(:content => "Awesome", :question => comboboxQ)
PredefinedAnswer.create(:content => "Fun", :question => comboboxQ)
PredefinedAnswer.create(:content => "Silly", :question => comboboxQ)
PredefinedAnswer.create(:content => "Don't Care", :question => comboboxQ)
radioQ = RadioButtonQuestion.create(:content => "Radio buttons are awesome.", :site_form => defaultForm)
PredefinedAnswer.create(:content => "True", :question => radioQ)
PredefinedAnswer.create(:content => "False", :question => radioQ)
PredefinedAnswer.create(:content => "Don't Care", :question => radioQ)
TextBoxQuestion.create(:content => "Describe in 100 words or less how text boxes make you feel.", :site_form => defaultForm)
TextQuestion.create(:content => "This is a ____ text question.", :site_form => defaultForm)

#Generate some normal activity for demonstration purposes

# Sample Discussions
disc = Discussion.create(:name => "NO STICKIES!", :body => "There are no stickies!", :user_profile => adminProfile, :discussion_space => discSpace)
comment1 = Comment.create(:body => "What?! No Stickies!", :user_profile => userProfile, :commentable => disc, :has_been_deleted => true)
comment2 = Comment.create(:body => " /facepalm", :user_profile => adminProfile, :commentable => comment1)
comment3 = Comment.create(:body => "WTF", :user_profile => dMooseProfile, :commentable => comment1)

disc1 = Discussion.create(:name => "OMG?!?!?!??!?!", :body => "They see me trolling...", :user_profile => userProfile, :discussion_space => discSpace, :has_been_locked => true)
disc2 = Discussion.create(:name => "Never gonna..", :body => "RICK ROLLED!", :user_profile => adminProfile, :discussion_space => discSpace1)
comment4 = Comment.create(:body => "In before locked", :user_profile => dMooseProfile, :commentable => disc1, :has_been_locked => true)

# Sample Announcements
GameAnnouncement.create(:name => "Star Wars is bad ass!", :body => "Raids are super cool. The new vent channel is open for SWTOR", :game => swtor)
SiteAnnouncement.create(:name => "Website is up and running!", :body => "This new website is off the hook!")

# Sample Page Space/Pages
bossPageSpace = PageSpace.create(:name => "SWTOR Boss Strategies", :game => swtor)
sarlaccPage = Page.create(:title => "Sarlacc Pit Strategy", :body => "Don't get eaten! It is really bad. Instead just pew-pew-pew", :page_space => bossPageSpace, :featured_page => true)
rockLobsterPage = Page.create(:title => "Rock Lobster", :body => "Bring a pot, this boss is super delicious!", :page_space => bossPageSpace)

guildInformationPageSpace = PageSpace.create(:name => "Guild Information")
guildCharterPage = Page.create(:title => "Guild Charter", :body => "[Insert epic story]", :page_space => guildInformationPageSpace, :featured_page => true)
guildRulesPage = Page.create(:title => "Guild Rules", :body => "IF YOU DON'T KNOW WHAT TO DO THAT IS A 50 KPD MINUS!", :page_space => guildInformationPageSpace, :featured_page => true)

#Test site form creation
testForm = SiteForm.create(:name => "Test Form", :message => "This is a test form for testing submissions.", :thankyou => "Thank you for submitting this form.", :registration_application_form => false, :published => true)
checkboxQ = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => testForm)
PredefinedAnswer.create(:content => "Happy", :question => checkboxQ)
PredefinedAnswer.create(:content => "Sad", :question => checkboxQ)
PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ)

testForm2 = SiteForm.create(:name => "Test Form 2", :message => "This is a test form for testing submissions. This is not published.", :thankyou => "Thank you for submitting this form.", :registration_application_form => false, :published => false)
checkboxQ2 = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => testForm2)
PredefinedAnswer.create(:content => "Happy", :question => checkboxQ2)
PredefinedAnswer.create(:content => "Sad", :question => checkboxQ2)
PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ2)
