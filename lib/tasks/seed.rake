ANIMAL_NAMES = %w(Alligator Bison Ant Ape Donkey Bat Bear Beaver Camel Cat Caterpillar Cheetah Chicken Chimpanzee Deer Dolphin Dragonfly Dragon Duck
                  Eagle Echidna Elephant Falcon Goat Gorilla Hawk Jellyfish Leopard Lion Lobster Monkey Mosquito Newt Oryx Owl Penguin Pig Platypus
                  Porcupine Rabbit Raccoon Ram Rat Raven Rhino Seahorse Seal Shark Skunk Snail Snake Turkey Wolf Wombat Worm Yak Zebra Tapir Swan)

ADJ_LIST = %w(adorable beautiful clean drab elegant fancy glamorous handsome magnificent quaint sparkling unsightly wide-eyed red orange yellow green blue
              purple gray black white big colossal fat gigantic great huge immense large little mammoth massive miniature petite puny scrawny short
              small tall teeny teeny-tiny tiny agreeable brave calm delightful eager faithful gentle happy jolly kind lively nice obedient proud relieved
              silly thankful victorious witty zealous angry bewildered clumsy defeated embarrassed fierce grumpy helpless itchy jealous lazy mysterious
              nervous obnoxious panicky repulsive scary thoughtless uptight worried productive protective proud punctual quiet receptive reflective
              relieved resolute responsible rhetorical righteous romantic sedate seemly selective self-assured sensitive shrewd silly  sincere skillful
              smiling splendid steadfast stimulating successful succinct talented thoughtful thrifty tough trustworthy unbiased unusual upbeat vigorous
              vivacious warm willing wise witty wonderful zany zealous)


namespace :seed do
  desc "Seeds all data"
  task :all => [:extra, :comments] do
    puts "All data seeded!"
  end

  desc "Seeds extra users and communities"
  task :extra => :environment do
    puts "Seeding extra users and communities.."

    @dont_run = Rails.env.development?
     %w{ users characters communities roles_permissions discussions pages messages custom_forms }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    headshot = Community.find_by_name("Just Another Headshot")
    billy = UserProfile.find_by_last_name('Billy')

    ANIMAL_NAMES.each do |last_name|
      create_user(ADJ_LIST[rand(ADJ_LIST.length)].capitalize, last_name)
      create_empire_character(last_name, "Darth #{last_name}", 'Sith Warrior', 'Marauder', 'Zabrak', 45)
      comm = create_community(last_name, "Sith #{last_name}s", "The #{ADJ_LIST[rand(ADJ_LIST.length)].capitalize} #{last_name}s will PWN you", %w(Empire))
      generate_application(comm, 'Fox').accept_application(UserProfile.find_by_last_name(last_name))
      generate_application(headshot, last_name).accept_application(billy)
    end
  end

  desc "Seeds extra discussions and comments"
  task :comments => :environment do
    @dont_run = true
     %w{ discussions }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    adj = ADJ_LIST[rand(ADJ_LIST.length)].capitalize

    for i in 0..50
      Timecop.freeze(rand(20).days.ago)
      discussion = create_discussion('Just Another Headshot', 'Community', "#{adj} Herp Derp #{i}", "#{adj} Herp Derp #{i}", 'Billy')
      puts "With 100 Comments"
      for j in 0..100
        create_comment(discussion, "#{adj} Herp Derp #{i}-#{j}", 'Billy')
      end
    end
  end
  
  desc "Seeds content with max length values"
  task :max => :environment do
    @dont_run = true
     %w{ users characters communities roles_permissions discussions pages messages custom_forms }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    puts "Creating user maxlength@digitalaugment.com"
    max = create_user("Max", "Length", create_w_string(UserProfile::MAX_NAME_LENGTH))
    user_profile = max.user_profile
    user_profile.location = create_w_string(UserProfile::MAX_LOCATION_LENGTH)
    user_profile.description = create_w_string(UserProfile::MAX_DESCRIPTION_LENGTH)
    user_profile.title = create_w_string(UserProfile::MAX_TITLE_LENGTH)
    user_profile.save!
    max2 = create_user("Max2", "Length2", create_w_string(UserProfile::MAX_NAME_LENGTH))
    max3 = create_user("Max3", "Length3", create_w_string(UserProfile::MAX_NAME_LENGTH))
    
    puts "Creating characters with max length attributes"
    create_empire_character("Length", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_empire_character("Length", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_alliance_character("Length", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    create_alliance_character("Length", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    
    create_empire_character("Length2", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_empire_character("Length2", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_alliance_character("Length2", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    create_alliance_character("Length2", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    
    create_empire_character("Length3", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_empire_character("Length3", create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", 99, "Female", "Phateem Halls of Knowledge")
    create_alliance_character("Length3", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    create_alliance_character("Length3", create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Night", "Pandaren", 99, "Female", "Steamwheedle Cartel")
    
    puts "Creating community with max length attributes"
    max_community = create_community("Length", create_w_string(Community::MAX_NAME_LENGTH), create_w_string(Community::MAX_SLOGAN_LENGTH), %w(Alliance Republic))
    max_community.pitch = create_w_string(Community::MAX_PITCH_LENGTH)
    max_community.save!
    max_community.update_attribute(:is_public_roster, false)
    
    application = generate_application(max_community, "Length2")
    character_hash_map = find_character_mapping(max_community, application)
    application.accept_application(user_profile, character_hash_map)
    application = generate_application(max_community, "Length3")
    character_hash_map = find_character_mapping(max_community, application)
    
    discussion_space = create_discussion_space("Length", max_community.name, create_w_string(DiscussionSpace::MAX_NAME_LENGTH), "Republic")
    discussion = create_discussion(max_community.name, discussion_space.name, create_w_string(Discussion::MAX_NAME_LENGTH), create_w_string(Discussion::MAX_BODY_LENGTH), "Length")
    
    comment1 = create_comment(discussion, create_w_string(Comment::MAX_BODY_LENGTH), 'Length')
    comment1a = create_comment(comment1, create_w_string(Comment::MAX_BODY_LENGTH), 'Length')
    comment1b = create_comment(comment1, create_w_string(Comment::MAX_BODY_LENGTH), 'Length')
    comment1b2 = create_comment(comment1b, create_w_string(Comment::MAX_BODY_LENGTH), 'Length')
    
    create_announcement(max_community.name,
                    create_w_string(Announcement::MAX_NAME_LENGTH),
                    create_w_string(Announcement::MAX_BODY_LENGTH),
                    'Length',
                    max_community.supported_games.find_by_game_type("Swtor"))
    create_announcement(max_community.name,
                    create_w_string(Announcement::MAX_NAME_LENGTH),
                    create_w_string(Announcement::MAX_BODY_LENGTH),
                    'Length',
                    max_community.supported_games.find_by_game_type("Swtor"))
                    
    page_space = create_page_space('Length', max_community.name, create_w_string(PageSpace::MAX_NAME_LENGTH), "Republic")
    create_page('Length', max_community.name, page_space.name, create_w_string(Page::MAX_NAME_LENGTH), create_w_string(300))
    
    create_max_custom_form(max_community.name, true)
    
    create_role(max_community.name, create_w_string(Role::MAX_NAME_LENGTH), %w(PageSpace), %w(Create), %w(Length2))
    
    create_message('Length', create_w_string(Message::MAX_SUBJECT_LENGTH), %w(Length2), create_w_string(Message::MAX_BODY_LENGTH))
    create_message('Length2', create_w_string(Message::MAX_SUBJECT_LENGTH), %w(Length), create_w_string(Message::MAX_BODY_LENGTH))
  end
  
  def create_w_string(length=1)
    w_string = "" 
    (1..length).each do
      w_string = w_string + "W"
    end
    return w_string
  end
end
