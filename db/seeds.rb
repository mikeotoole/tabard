# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
userResource = SystemResource.create(:name => "User")
roleResource = SystemResource.create(:name => "Role")
siteFormResource = SystemResource.create(:name => "SiteForm")
registrationApplicationResource = SystemResource.create(:name => "RegistrationApplication")
newsletterResource = SystemResource.create(:name => "Newsletter")
themeResource = SystemResource.create(:name => "Theme")

gameResource = SystemResource.create(:name => "Game")
characterResource = SystemResource.create(:name => "Character")

commentResource = SystemResource.create(:name => "Comment")

discussionSpaceResource = SystemResource.create(:name => "DiscussionSpace")
discussionResource = SystemResource.create(:name => "Discussion")

siteAnnouncementResource = SystemResource.create(:name => "SiteAnnouncement")
gameAnnouncementResource = SystemResource.create(:name => "GameAnnouncement")

pageSpaceResource = SystemResource.create(:name => "PageSpace")
pageResource = SystemResource.create(:name => "Page")

# Sample Games
wow = Game.create(:name => "World of Warcraft", :type_helper => "Wow", :is_active => true)
swtor = Game.create(:name => "Star Wars the Old Republic", :type_helper => "Swtor", :is_active => true)

# Admin User
adminProfile = UserProfile.create(:name => "Admin")
adminProfile.set_active
adminUser = User.create(:email => "admin@example.com", :password => "password", :user_profile => adminProfile)

# Sample Communities
stonewatch = Community.create(:name => "Stonewatch", 
  :slogan => "We wear pants and eat food.", 
  :label => "Guild", 
  :accepting => true)

justanotherheadshot = Community.create(:name => "Just Another Headshot", 
  :slogan => "Boom Baby!", 
  :label => "Clan", 
  :accepting => false)

adminUser.roles << stonewatch.admin_role

#Sample community activity
#Registration application site form creation
stonewatchCommunityForm = SiteForm.create(:name => "Registration Application Form", :message => "Welcome! Please follow the 3 step applcation process to apply for the guild.", :thankyou => "Thank you for submitting your application.", :published => true, :community => stonewatch)
checkboxQ = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => stonewatchCommunityForm)
PredefinedAnswer.create(:content => "Happy", :question => checkboxQ)
PredefinedAnswer.create(:content => "Sad", :question => checkboxQ)
PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ)
comboboxQ = ComboBoxQuestion.create(:content => "Combo boxes are?", :site_form => stonewatchCommunityForm)
PredefinedAnswer.create(:content => "Awesome", :question => comboboxQ)
PredefinedAnswer.create(:content => "Fun", :question => comboboxQ)
PredefinedAnswer.create(:content => "Silly", :question => comboboxQ)
PredefinedAnswer.create(:content => "Don't Care", :question => comboboxQ)
radioQ = RadioButtonQuestion.create(:content => "Radio buttons are awesome.", :site_form => stonewatchCommunityForm)
PredefinedAnswer.create(:content => "True", :question => radioQ)
PredefinedAnswer.create(:content => "False", :question => radioQ)
PredefinedAnswer.create(:content => "Don't Care", :question => radioQ)
TextBoxQuestion.create(:content => "Describe in 100 words or less how text boxes make you feel.", :site_form => stonewatchCommunityForm)
TextQuestion.create(:content => "This is a ____ text question.", :site_form => stonewatchCommunityForm)

stonewatch.update_attributes(:community_application_form => stonewatchCommunityForm)

# General User
roboBillyProfile = UserProfile.create(:name => "RoboBilly")
roboBillyProfile.set_active

blaggarth = WowCharacter.create(:name => "Blaggarth", :faction => "Alliance", :race => "Dwarf", :server => "Medivh", :level => "10", :game => wow)
eliand = WowCharacter.create(:name => "Eliand", :faction => "Alliance", :race => "Night Elf", :server => "Medivh", :level => "10", :game => wow)
yoda = SwtorCharacter.create(:name => "Yoda", :server => "Obi-Wan", :game => swtor)

roboBillyProfile.build_character(blaggarth)
roboBillyProfile.build_character(eliand)
roboBillyProfile.build_character(yoda)

roboBillyUser = User.create(:email => "billy@robo.com", :password => "password", :user_profile => roboBillyProfile)
roboBillyUser.roles << stonewatch.member_role

dMooseProfile = UserProfile.create(:name => "DiabolicalMoose")
dMooseProfile.set_active
dMooseUser = User.create(:email => "Diabolical@Moose.com", :password => "password", :user_profile => dMooseProfile)
dMooseUser.roles << stonewatch.member_role
dMooseUser.roles << justanotherheadshot.admin_role

badApplicantProfile = UserProfile.create(:name => "Your Mom")
badApplicantProfile.set_active
badApplicantProfile = User.create(:email => "Your@Mom.com", :password => "password", :user_profile => badApplicantProfile)
badApplicantProfile.roles << stonewatch.applicant_role

#More General Users
1.upto(20) { |n|
  g_profile = UserProfile.create(:name => "guser_#{n}")
  g_profile.set_active
  g_user = User.create(:email => "g#{n}@user.com", :password => "password", :user_profile => g_profile)
}

#Generate some normal activity for stonewatch

# Sample Discussion Spaces
discSpace = DiscussionSpace.create(:name => "General", :system => false, :user_profile => adminProfile, :community => stonewatch)
discSpace1 = DiscussionSpace.create(:name => "Off Topic", :system => false, :user_profile => adminProfile, :community => stonewatch)

#Sample Discussions
disc = Discussion.create(:name => "NO STICKIES!", :body => "There are no stickies!", :user_profile => adminProfile, :discussion_space => discSpace)
comment1 = Comment.create(:body => "What?! No Stickies!", :user_profile => roboBillyProfile, :commentable => disc, :has_been_deleted => true)
comment2 = Comment.create(:body => " /facepalm", :user_profile => adminProfile, :commentable => comment1)
comment3 = Comment.create(:body => "WTF", :user_profile => dMooseProfile, :commentable => comment1)

disc1 = Discussion.create(:name => "OMG?!?!?!??!?!", :body => "They see me trolling...", :user_profile => roboBillyProfile, :discussion_space => discSpace, :has_been_locked => true)
disc2 = Discussion.create(:name => "Never gonna..", :body => "RICK ROLLED!", :user_profile => roboBillyProfile, :discussion_space => discSpace1)
comment4 = Comment.create(:body => "In before locked", :user_profile => dMooseProfile, :commentable => disc1, :has_been_locked => true)

# Sample Announcements
#GameAnnouncement.create(:name => "Star Wars is bad ass!", :body => "Raids are super cool. The new vent channel is open for SWTOR", :game => swtor)
#SiteAnnouncement.create(:name => "Website is up and running!", :body => "This new website is off the hook!")

# Sample Page Space/Pages
bossPageSpace = PageSpace.create(:name => "SWTOR Boss Strategies", :game => swtor, :community => stonewatch)
sarlaccPage = Page.create(:title => "Sarlacc Pit Strategy", :body => "Don't get eaten! It is really bad. Instead just pew-pew-pew", :page_space => bossPageSpace, :featured_page => true)
rockLobsterPage = Page.create(:title => "Rock Lobster", :body => "Bring a pot, this boss is super delicious!", :page_space => bossPageSpace)

guildInformationPageSpace = PageSpace.create(:name => "Guild Information", :community => stonewatch)
guildCharterPage = Page.create(:title => "Guild Charter", :body => "[Insert epic story]", :page_space => guildInformationPageSpace, :featured_page => true)
guildRulesPage = Page.create(:title => "Guild Rules", :body => "IF YOU DON'T KNOW WHAT TO DO THAT IS A 50 KPD MINUS!", :page_space => guildInformationPageSpace, :featured_page => true)

#Generate some normal activity for justanotherheadshot

# Sample Discussion Space
jahGeneral = DiscussionSpace.create(:name => "General", :system => false, :user_profile => dMooseProfile, :community => justanotherheadshot)
jahHax = DiscussionSpace.create(:name => "Hax Info", :system => false, :user_profile => dMooseProfile, :community => justanotherheadshot)

#Sample Discussions
haxDisc1 = Discussion.create(:name => "1337 Hax Website", :body => "www.1337hax.com/OMGWTFBBQPWNSAUCE/pewpewpew", :user_profile => dMooseProfile, :discussion_space => jahHax)

# Sample Page Space/Pages
jahInfoPage = PageSpace.create(:name => "JAH Information", :community => justanotherheadshot)
Page.create(:title => "Da Rules", :body => "OMG COME GET SOME!", :page_space => jahInfoPage, :featured_page => true)

#Test site form creation
#testForm = SiteForm.create(:name => "Test Form", :message => "This is a test form for testing submissions.", :thankyou => "Thank you for submitting this form.", :registration_application_form => false, :published => true)
#checkboxQ = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => testForm)
#PredefinedAnswer.create(:content => "Happy", :question => checkboxQ)
#PredefinedAnswer.create(:content => "Sad", :question => checkboxQ)
#PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ)

#testForm2 = SiteForm.create(:name => "Test Form 2", :message => "This is a test form for testing submissions. This is not published.", :thankyou => "Thank you for submitting this form.", :registration_application_form => false, :published => false)
#checkboxQ2 = CheckBoxQuestion.create(:content => "A check box makes me feel.", :site_form => testForm2)
#PredefinedAnswer.create(:content => "Happy", :question => checkboxQ2)
#PredefinedAnswer.create(:content => "Sad", :question => checkboxQ2)
#PredefinedAnswer.create(:content => "WTF?!", :question => checkboxQ2)
