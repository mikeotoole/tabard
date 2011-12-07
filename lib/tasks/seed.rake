namespace :seed do
  desc "Seeds all data"
  task :all => [:extra] do
    puts "All data seeded!"
  end
  
  desc "Seeds extra data"
  task :extra => :environment do
    puts "Seeding extra users and communities.."
    
    @dont_run = true
     %w{ users characters communities discussions }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/../../db/seeds/#{part}.rb"
    end
    
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
  
    headshot = Community.find_by_name("Just Another Headshot")
  
    ANIMAL_NAMES.each do |last_name|
      create_user(ADJ_LIST[rand(ADJ_LIST.length)].capitalize, last_name)
      create_empire_character(last_name, "Darth #{last_name}", 'Sith Warrior', 'Marauder', 'Zabrak', 45)
      comm = create_community(last_name, "Sith #{last_name}s", "The #{ADJ_LIST[rand(ADJ_LIST.length)].capitalize} #{last_name}s will PWN you", %w(Empire))
      generate_application(comm, 'Fox').accept_application
      generate_application(headshot, last_name).accept_application
    end
    
    for i in 0..50
      Timecop.freeze(rand(20).days.ago)
      discussion = create_discussion('Just Another Headshot', 'Community', 'Herp Derp', 'Herp Derp', 'Billy')
      for i in 0..100
        create_comment(discussion, 'Herp Derp', 'Billy')
      end
    end
  end
end