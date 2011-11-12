# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
if ENV["RAILS_ENV"] != 'test' # TODO Joe, What is this for? -MO

puts "Time: 2 months ago"
Timecop.freeze 2.months.ago

  puts "Creating TOS"
  tos_document = TermsOfService.create(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ac mollis elit. Nulla at dapibus arcu. Aenean fringilla erat sit amet purus molestie suscipit. Etiam urna nisi, feugiat at commodo sed, dapibus vitae est.\n\nNullam pulvinar volutpat tellus, a semper massa lobortis et. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed lobortis laoreet euismod. In semper justo ac massa interdum et vulputate dui accumsan. Maecenas eleifend, enim eu molestie volutpat, lacus sapien rutrum augue, vel mollis turpis arcu vel est.\n\nPellentesque pellentesque leo quis lacus convallis tempor. Maecenas interdum pellentesque justo, ut ultricies enim volutpat in.\n\nProin in diam nisi. Quisque at dolor arcu, at tincidunt tellus. Pellentesque ornare elit egestas enim fringilla eu dictum lacus varius. In hac habitasse platea dictumst. Vivamus feugiat imperdiet elementum. Fusce egestas enim in sapien vestibulum vitae tristique purus pellentesque.", version: "1")
  puts "Creating PrivacyPolicy"
  privacy_policy_document = PrivacyPolicy.create(body: "Nullam consequat pulvinar velit, eget ultrices tortor semper vel. Suspendisse potenti. Praesent ut nibh in neque malesuada tempus sit amet eget odio. Curabitur volutpat, sem semper vulputate posuere, sem metus ornare elit, ac imperdiet felis urna hendrerit nisi. Maecenas vel ligula vel erat eleifend aliquet vel id ipsum.\n\nNullam convallis iaculis erat et mollis.\n\nSed urna neque, pretium in tempus nec, dapibus in enim. Aenean dapibus ipsum sit amet diam molestie aliquet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque cursus feugiat ipsum vitae volutpat. Aenean laoreet, tortor a consequat convallis, libero dui suscipit tellus, et mollis massa nulla et libero. Vestibulum tincidunt quam nec lorem molestie id euismod urna venenatis. Aliquam erat volutpat.\n\nMauris dapibus, lorem ut lobortis blandit, enim ipsum fermentum neque, aliquet dictum nulla ligula sit amet quam. Fusce non pharetra sapien. Sed tincidunt euismod consequat.", version: "1")
  
  puts "Creating Games..."
  wow_game = Wow.create(:name => "World of Warcraft", :pretty_url => 'world-of-warcraft-guilds')
  swtor_game = Swtor.create(:name => "Star Wars the Old Republic", :pretty_url => 'star-wars-old-republic-guilds')
  
  puts "Creating RoboBilly!"
  robobilly = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "billy@robo.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Robo", :last_name => "Billy", :display_name => "Robo Billy"})
  robobilly.skip_confirmation!
  robobilly.save
  
  puts "Createing Diabolical Moose!"
  d_moose = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "diabolical@moose.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Diabolical", :last_name => "Moose", :display_name => "Diabolical Moose"})
  d_moose.skip_confirmation!
  d_moose.save
  d_moose.character_proxies.create(:user_profile => d_moose.user_profile,
    :character => WowCharacter.create(:name => "Moose Drool",
    :game => wow_game,
    :server => "Default WOW Server",
    :faction => "Horde",
    :race => "Orc",
    :level => 80)
  )
  d_moose.character_proxies.create(:user_profile => d_moose.user_profile,
    :character => SwtorCharacter.create(:name => "Moose Drool",
    :game => swtor_game,
    :server => "Alderon")
  )
  
  puts "Creating Snappy Turtle!"
  s_turtle = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "snappy@turtle.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Snappy", :last_name => "Turtle", :display_name => "Snappy Turtle"})
  s_turtle.skip_confirmation!
  s_turtle.save
  
  puts "Creating Dirty Badger!"
  d_badger = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "dirty@badger.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Dirty", :last_name => "Badger", :display_name => "Dirty Badger"})
  d_badger.skip_confirmation!
  d_badger.save
  
  puts "Creating Sleepy Pidgeon!"
  s_pidgeon = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "sleepy@pidgeon.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Sleepy", :last_name => "Pidgeon", :display_name => "Sleepy Pidgeon"})
  s_pidgeon.skip_confirmation!
  s_pidgeon.save
  
  puts "Creating Apathetic Tiger!"
  a_tiger = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "apathetic@tiger.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Apathetic", :last_name => "Tiger", :display_name => "Apathetic Tiger"})
  a_tiger.skip_confirmation!
  a_tiger.save
  
  puts "Creating Fuzzy Crab!"
  f_crab = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "fuzzy@crab.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Fuzzy", :last_name => "Crab", :display_name => "Fuzzy Crab"})
  f_crab.skip_confirmation!
  f_crab.save
  
  puts "Creating Sad Panda!"
  s_panda = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "sad@panda.com", :password => "Password",
      :user_profile_attributes => {:first_name => "Sad", :last_name => "Panda", :display_name => "Sad Panda"})
  s_panda.skip_confirmation!
  s_panda.save
  s_panda.update_attribute(:accepted_current_terms_of_service, false)
  s_panda.update_attribute(:accepted_current_privacy_policy, false)
  DocumentAcceptance.where(:user_id => s_panda.id).destroy_all
  
  
  puts "Creating Kinky Fox!"
  k_fox = User.new(:accepted_current_terms_of_service => true, :accepted_current_privacy_policy => true,
      :email => "kinky@fox.com", :password => "Password",
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
  
  def generate_application_from_user_profile(community, user_profile)
    app = community.community_applications.new(:character_proxies => user_profile.character_proxies)
    app.prep(user_profile, community.community_application_form)
    app.save
    #puts app.errors.to_yaml
    #app.submission.custom_form.questions.each do |q|
    #  case q.type
    #    when 'long_answer_question'
    #      app.submission.answers.create(:question_id => q.id, :body => 'Because you guys are awesome, and I want to be awesome too!')
    #    when 'radio_buttons_question'
    #      app.submission.answers.create(:question_id => q.id, :body => q.predefined_answers.first.body)
    #  end
    #end
    #puts app.submission.answers.to_yaml
    app
  end
  
  puts "Kinky Fox is creating Two Maidens Guild with the game WoW!"
  twom = k_fox.owned_communities.create(:name => "Two Maidens", :slogan => "One Chalice", :accepting_members => true, :email_notice_on_application => false)
  twom.games << wow_game
  
  puts "Sleepy Pidgeon and Apathetic Tiger are submitting applications to Two Maidens Guild..."
  puts "Accepting Sleepy Pidgeon & Apathic Tiger's applications"
  generate_application_from_user_profile(twom, s_pidgeon.user_profile).accept_application
  generate_application_from_user_profile(twom, a_tiger.user_profile).accept_application
  
  puts "Creating Two Maidens Guild General Discussion Space"
  twom_gds = twom.discussion_spaces.create(:name => "General Chat")
  
  puts "Creating Two Maidens Guild WoW Discussion Space"
  twom_wds = twom.discussion_spaces.create(:name => "WoW", :game_id => wow_game.id)

puts "Time: 1 month ago"
Timecop.return
Timecop.freeze 1.months.ago

  puts "Fuzzy Crab and Sad Panda are submitting applications to Two Maidens Guild..."
  puts "Accepting Fuzzy Crab and Sad Panda's applications..."
  generate_application_from_user_profile(twom, s_pidgeon.user_profile).accept_application
  generate_application_from_user_profile(twom, a_tiger.user_profile).accept_application
  generate_application_from_user_profile(twom, f_crab.user_profile).accept_application
  generate_application_from_user_profile(twom, s_panda.user_profile).accept_application
  
  puts "Apathetic Tiger is creating Jedi Kittens the game SWTOR!"
  jkit = a_tiger.owned_communities.create(:name => "Jedi Kittens", :slogan => "Nya nya nya nya", :public_roster => false)
  jkit.games << swtor_game
  
  puts "Sleeping Pidgeon and Apathetic Tiger are submitting applications to Jedi Kittens Guild..."
  puts "Accepting Dirty Badger and Robo Billy's applications"
  generate_application_from_user_profile(jkit, d_badger.user_profile).accept_application
  generate_application_from_user_profile(jkit, robobilly.user_profile).accept_application
  
  puts "RoboBilly is creating Just Another Headshot Community with the game SWTOR and WoW!"
  jahc = robobilly.owned_communities.create(:name => "Just Another Headshot", :slogan => "Boom baby!", :protected_roster => true)
  jahc.games << swtor_game
  jahc.games << wow_game
  
  puts "RoboBilly is creating a n00b role..."
  noob_role = jahc.roles.create(:name => "n00b")
  
  puts "RoboBilly is adding permissions to view roles to n00b role..."
  noob_role.permissions.create(:subject_class => "Role", :permission_level => "View")
  
  puts "RoboBilly is creating some characters and adding them to the roster..."
  rb_cp = robobilly.community_profiles.where(:community_id => jahc.id).first
  ['Yoda','Han Solo','Chewbacca','R2D2'].each do |cname|
    proxy = robobilly.character_proxies.create(:user_profile => robobilly.user_profile,
      :character => SwtorCharacter.create(:name => cname, :game => swtor_game, :server => "Alderaan"))
    ra = robobilly.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => proxy)
    ra.approve unless cname == 'Chewbacca'
  end
  ['Eliand','Blaggarth','Drejan'].each do |cname|
    proxy = robobilly.character_proxies.create(:user_profile => robobilly.user_profile,
      :character => WowCharacter.create(:name => cname, :game => wow_game, :server => "Darkspear"))
    ra = robobilly.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => proxy)
    ra.approve unless cname == 'Eliand'
  end
  
  puts "Diabolical Moose and Snappy Turtle are submitting applications to Just Another Headshot Clan..."
  puts "Accepting Diabolical Moose's and Snappy Turtle's applications"
  generate_application_from_user_profile(jahc, d_moose.user_profile).accept_application
  generate_application_from_user_profile(jahc, s_turtle.user_profile).accept_application
  
  puts "Giving D-Moose the n00b role..."
  d_moose.add_new_role(noob_role)

  puts "Snappy Turtle is creating some characters and adding them to the JAH roster..."
  dr_manhattan = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Manhattan", :game => swtor_game, :server => "Alderaan"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_manhattan)
  dr_hammer = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Hammer", :game => swtor_game, :server => "Endor"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_hammer)
  dr_horrible = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Horrible", :game => swtor_game, :server => "Hoth"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_horrible)
  dr_strangelove = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Strangelove", :game => swtor_game, :server => "Korriban"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_strangelove)
  dr_doom = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Doom", :game => swtor_game, :server => "Coruscant"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_doom)
  dr_octopus = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr Octopus", :game => swtor_game, :server => "Tatooine"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_octopus)
  dr_house = s_turtle.character_proxies.create(:user_profile => s_turtle.user_profile,
    :character => SwtorCharacter.create(:name => "Dr House", :game => swtor_game, :server => "Belsavis"))
  s_turtle.community_profiles.find_by_community_id(jahc.id).roster_assignments.create(:character_proxy => dr_house)
  
  puts "Creating Just Another Headshot Clan General Discussion Space"
  jahc_gds = jahc.discussion_spaces.create(:name => "General Chat")
  
  puts "Creating Just Another Headshot Clan WoW Discussion Space"
  jahc_wds = jahc.discussion_spaces.create(:name => "WoW", :game_id => wow_game.id)
  
  puts "Creating Just Another Headshot Clan SWTOR Discussion Space"
  jahc_sds = jahc.discussion_spaces.create(:name => "SWTOR", :game_id => swtor_game.id)
  
  puts "Creating Just Another Headshot Clan General Discussion Space Discussion"
  jahc_gd = jahc_gds.discussions.new(:name => "What up hommies!?", :body => "How was your weekend?")
  jahc_gd.user_profile = robobilly.user_profile
  jahc_gd.save
  
  puts "Creating Just Another Headshot Clan WoW Discussion Space Discussion"
  jahc_wd = jahc_wds.discussions.create(:name => "General WoW Discussion", :body => "YAY lets discuss WoW")
  
  puts "Creating Just Another Headshot Clan SWTOR Discussion Space Discussion"
  jahc_sd = jahc_sds.discussions.create(:name => "General SWTOR Discussion", :body => "YAY lets discuss SWTOR")
  
  puts "Adding comments to general discussion space discussion"
  comment1 = jahc_gd.comments.new(:body => "What's up RoboBilly!")
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
  comment2 = jahc_gd.comments.new(:body => "Herp a derp.")
  comment2.user_profile = robobilly.user_profile
  comment2.has_been_edited = true
  comment2.save

puts "Time: 3 weeks ago"
Timecop.return
Timecop.freeze(3.weeks.ago)
  
  puts "Dirty Badger and Kinky Fox are submitting applications to Just Another Headshot Clan..."
  puts "Accepting Dirty Badger's applications"
  generate_application_from_user_profile(jahc, d_badger.user_profile).accept_application
  generate_application_from_user_profile(jahc, k_fox.user_profile)

  puts "Adding an old announcement for Just Another Headshot Clan"
  jahc_a_old = jahc.community_announcement_space.discussions.new(:name => "This announcement is derp old", :body => "So old in fact, it's in Latin! Nunc sem purus, posuere eu ullamcorper ac, vulputate ac dolor. Donec id mi eget lacus venenatis dignissim.")
  jahc_a_old.user_profile = robobilly.user_profile
  jahc_a_old.save

puts "Time: now"
Timecop.return

puts "Adding newer announcements for Just Another Headshot Clan"
jahc_a1 = jahc.community_announcement_space.discussions.new(:name => "Website is up and running!", :body => "This new website is off the hook!")
jahc_a1.user_profile = robobilly.user_profile
jahc_a1.save
jahc_a2 = jahc.game_announcement_spaces.first.discussions.new(:name => "Star Wars is bad ass!", :body => "Raids are super cool. The new vent channel is open for SWTOR.")
jahc_a2.user_profile = robobilly.user_profile
jahc_a2.save
jahc_a3 = jahc.game_announcement_spaces.last.discussions.new(:name => "WoW is now supported!", :body => "Everyone add your WoW characters.")
jahc_a3.user_profile = robobilly.user_profile
jahc_a3.save

puts "Creating Just Another Headshot Clan Guild Info Page Space"
jahc_gips = jahc.page_spaces.create(:name => "Guild Info")

puts "Creating Just Another Headshot Clan WoW Page Space"
jahc_wps = jahc.page_spaces.create(:name => "WoW Resources", :game_id => wow_game.id)

puts "Creating Just Another Headshot Clan Guild Rules Page"
jahc_g_rules = jahc_gips.pages.new(:name => "Guild Rules", :markup => "##Guild Rules##\n 1. Don't be dumb\n 2. IF YOU DON'T KNOW WHAT TO DO THAT IS A 50 KPD MINUS!")
jahc_g_rules.user_profile = robobilly.user_profile
jahc_g_rules.save

puts "Creating Just Another Headshot WoW Strategies Page"
jahc_wow_strategies = jahc_wps.pages.new(:name => "WoW Strategies", :markup => "##WoW Strategies##\n###Sarlacc Pit Strategy###\n* Don't get eaten!\n** It is really bad.\n** Instead just pew-pew-pew")
jahc_wow_strategies.user_profile = s_turtle.user_profile
jahc_wow_strategies.save

puts "Creating Example Messages"
robobilly.sent_messages.create(:subject => "What up Homies?", :body => "This is a test message created in the seed file. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet ultrices metus, ut tempus diam sollicitudin in. Nullam justo arcu, fringilla non mollis nec, blandit id orci. Maecenas condimentum tortor in felis ullamcorper ullamcorper. Nulla et lacus ac orci semper adipiscing eu laoreet leo.", :to => [d_moose.id, d_badger.id, k_fox.id])

puts "Time: 3 days ago"
Timecop.freeze(3.days.ago)
  puts "Creating some messages..."
  s_turtle.sent_messages.create(:subject => "April O'Neil is so hawt", :body => "Mauris ac felis felis, quis facilisis augue. Aenean at posuere orci. Etiam porttitor pulvinar purus a gravida. Nullam vel ipsum lectus. Nunc condimentum laoreet ultrices. Aliquam tincidunt auctor mauris nec sagittis. Nunc ante ligula, dapibus non gravida eget, varius id nibh. Morbi sed magna tortor, ut venenatis sapien.", :to => [robobilly.id])
  d_moose.sent_messages.create(:subject => "I'm a magical ninja!", :body => "Vestibulum in interdum sem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec ut dictum leo. Sed eget ipsum sem, vitae eleifend ipsum. Integer neque nisl, aliquet a iaculis sed, tempor vel nibh. Pellentesque tristique tristique odio, non vulputate metus porta id.", :to => [robobilly.id])

puts "Time: 2 days ago"
Timecop.return
Timecop.freeze(2.days.ago)
  puts "Creating a message..."
  d_moose.sent_messages.create(:subject => "I'm a bus!", :body => "Vestibulum in interdum sem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec ut dictum leo. Sed eget ipsum sem, vitae eleifend ipsum. Integer neque nisl, aliquet a iaculis sed, tempor vel nibh. Pellentesque tristique tristique odio, non vulputate metus porta id.", :to => [robobilly.id])

puts "Time: 1 day ago"
Timecop.return
Timecop.freeze(1.days.ago)
  puts "Creating some messages..."
  k_fox.sent_messages.create(:subject => "Hey you're cute", :body => "Hey, baby. Donec sed odio quis elit varius lobortis. Proin nec tortor sed justo dictum pellentesque in et enim.\n\nInteger lacus turpis, ultricies vel vulputate porttitor, bibendum at mi.", :to => [robobilly.id])
  s_turtle.sent_messages.create(:subject => "Dudes, let's hang out Friday", :body => "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non.\n\nPhasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sa Who exactly is your father, and where is hiserit iaculis in in porttitor eget, lacinia id risus.", :to => [robobilly.id, d_moose.id, d_badger.id])
  d_moose.sent_messages.create(:subject => "I'm a potato gun!", :body => "Vestibulum in interdum sem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec ut dictum leo. Sed eget ipsum sem, vitae eleifend ipsum. Integer neque nisl, aliquet a iaculis sed, tempor vel nibh. Pellentesque tristique tristique odio, non vulputate metus porta id.", :to => [robobilly.id])

puts "Time: now"
Timecop.return

puts "Creating a message..."
d_badger.sent_messages.create(:subject => "Mushroom, mushroom!", :body => "Phasellus ornare lacus eu neque hendrerit iaculis in in neque. Phasellus dolor velit, ultrices tempor porttitor eget, lacinia id risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non. Phasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sapien.", :to => [robobilly.id, k_fox.id])

end
