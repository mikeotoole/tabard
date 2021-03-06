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
  task all: [:extra, :comments, :max] do
    puts "All data seeded!"
  end

  desc "Seeds extra users and communities"
  task extra: :environment do
    puts "Seeding extra users and communities.."

    @dont_run = Rails.env.development?
     %w{ users characters communities roles_permissions discussions pages messages custom_forms }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    headshot = Community.find_by_name("Just Another Headshot")
    more_headshot = Community.find_by_name("Even More Headshots")
    billy = UserProfile.find_by_full_name('RoboBilly')

    ANIMAL_NAMES.each do |animal|
      full_name = "#{ADJ_LIST[rand(ADJ_LIST.length)].capitalize} #{animal}"
      begin
        full_name = "#{ADJ_LIST[rand(ADJ_LIST.length)].capitalize} #{animal}"
      end while not UserProfile.find_by_full_name(full_name).blank?
      create_user(full_name, full_name.gsub(/\s+|-+/, ""))
      create_swtor_character(full_name, "Darth #{animal}", 'Sith Warrior', 'Marauder', 'Zabrak', 'Empire', 45, 'Male', Swtor.first.server_names.first)
      create_minecraft_character(full_name, "Boxy #{animal}")
      comm = create_community(full_name, "Sith #{full_name}s".slice(0,25), "The #{ADJ_LIST[rand(ADJ_LIST.length)].capitalize} #{animal}s will PWN you", %w(Empire))
      generate_application(comm, 'Kinky Fox').accept_application(UserProfile.find_by_full_name(full_name))
      generate_application(headshot, full_name).accept_application(billy)
      generate_application(more_headshot, full_name)
    end
  end

  desc "Seeds extra discussions and comments"
  task comments: :environment do
    @dont_run = true
     %w{ discussions }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    adj = ADJ_LIST[rand(ADJ_LIST.length)].capitalize

    for i in 0..50
      Timecop.freeze(rand(20).days.ago)
      com = Community.find_by_name("Just Another Headshot")
      discussion = create_discussion(com.name, 'Community', "#{adj} Herp Derp #{i}", "#{adj} Herp Derp #{i}", com.admin_profile.full_name)
      puts "With 100 Comments"
      for j in 0..100
        create_comment(discussion, "#{adj} Herp Derp #{i}-#{j}", com.admin_profile.full_name)
      end
    end
  end

  desc "Seeds content with max length values"
  task max: :environment do
    @dont_run = true
     %w{ users characters communities roles_permissions discussions pages messages custom_forms }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end

    puts "Creating user maxlength@digitalaugment.com"
    max = create_user(create_w_string(UserProfile::MAX_NAME_LENGTH), "Max")
    user_profile = max.user_profile
    user_profile.location = create_w_string(UserProfile::MAX_LOCATION_LENGTH)
    user_profile.description = create_w_string(UserProfile::MAX_DESCRIPTION_LENGTH)
    user_profile.title = create_w_string(UserProfile::MAX_TITLE_LENGTH)
    user_profile.save!
    max2 = create_user(create_w_string(UserProfile::MAX_NAME_LENGTH), "Max2")

    puts "Creating characters with max length attributes"
    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")

    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")

    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_swtor_character(max.full_name, create_w_string(SwtorCharacter::MAX_NAME_LENGTH), "Sith Warrior", "Juggernaut", "Sith Pureblood", "Empire", 50, "Female", "The Bastion")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")
    create_wow_character(max.full_name, create_w_string(WowCharacter::MAX_NAME_LENGTH), "Death Knight", "Worgen", "Alliance", 90, "Female", "Steamwheedle Cartel")

    puts "Creating community with max length attributes"
    max_community = create_community(max.full_name, create_w_string(Community::MAX_NAME_LENGTH), create_w_string(Community::MAX_SLOGAN_LENGTH), %w(Alliance Republic))
    max_community.save!
    max_community.update_column(:is_public_roster, false)


    #application = generate_application(max_community, max2.full_name)
    #character_hash_map = find_character_mapping(max_community, application)
    #application.accept_application(user_profile, character_hash_map)

    discussion_space = create_discussion_space(max.full_name, max_community.name, create_w_string(DiscussionSpace::MAX_NAME_LENGTH), "Republic")
    discussion = create_discussion(max_community.name, discussion_space.name, create_w_string(Discussion::MAX_NAME_LENGTH), create_w_string(Discussion::MAX_BODY_LENGTH), max.full_name)

    comment1 = create_comment(discussion, create_w_string(Comment::MAX_BODY_LENGTH), max.full_name)
    comment1a = create_comment(comment1, create_w_string(Comment::MAX_BODY_LENGTH), max.full_name)
    comment1b = create_comment(comment1, create_w_string(Comment::MAX_BODY_LENGTH), max.full_name)
    comment1b2 = create_comment(comment1b, create_w_string(Comment::MAX_BODY_LENGTH), max.full_name)

    create_announcement(max_community.name,
                    create_w_string(Announcement::MAX_NAME_LENGTH),
                    create_w_string(Announcement::MAX_BODY_LENGTH),
                    max.full_name,
                    max_community.community_games.find_by_game_id(Game.find_by_type("Swtor")))
    create_announcement(max_community.name,
                    create_w_string(Announcement::MAX_NAME_LENGTH),
                    create_w_string(Announcement::MAX_BODY_LENGTH),
                    max.full_name,
                    max_community.community_games.find_by_game_id(Game.find_by_type("Swtor")))

    page_space = create_page_space(max.full_name, max_community.name, create_w_string(PageSpace::MAX_NAME_LENGTH), "Republic")
    create_page(max.full_name, max_community.name, page_space.name, create_w_string(Page::MAX_NAME_LENGTH), create_w_string(300))

    create_max_custom_form(max_community.name, true)

    create_role(max_community.name, create_w_string(Role::MAX_NAME_LENGTH), %w(PageSpace), %w(Create), [max2.full_name])

    create_message(max.full_name, create_w_string(Message::MAX_SUBJECT_LENGTH), [max2.full_name], create_w_string(Message::MAX_BODY_LENGTH))
    create_message(max2.full_name, create_w_string(Message::MAX_SUBJECT_LENGTH), [max.full_name], create_w_string(Message::MAX_BODY_LENGTH))
  end

  desc "Seeds content with max length values"
  task update_themes: :environment do
    puts "Updating Cyborg: "
    success = Theme.find(2).update_attributes(name: "Cyborg", css: "cyborg", background_author: "Mac Rebisz", background_author_url: "http://maciejrebisz.com", thumbnail: "cyborg.jpg")
    puts success
    puts Theme.find(2).to_yaml

    puts "Updating Metropolis: "
    Theme.find(3).update_attributes(name: "Metropolis", css: "metropolis", background_author: "Igor Vitkovskiy", background_author_url: "http://m3-f.deviantart.com", thumbnail: "metropolis.jpg")
    puts success
    puts Theme.find(3).to_yaml

    puts "Updating Wasteland: "
    Theme.find(4).update_attributes(name: "Wasteland", css: "wasteland", background_author: "Craig Soulsby", background_author_url: "http://xblitzcraigx.deviantart.com", thumbnail: "wasteland.jpg")
    puts success
    puts Theme.find(4).to_yaml

    puts "Updating Hailstone: "
    Theme.find(5).update_attributes(name: "Hailstone", css: "hailstone", background_author: "Mac Rebisz", background_author_url: "http://maciejrebisz.com", thumbnail: "hailstone.jpg")
    puts success
    puts Theme.find(5).to_yaml
  end

  def create_w_string(length=1)
    w_string = ""
    (1..length).each do
      w_string = w_string + "W"
    end
    return w_string
  end
end
