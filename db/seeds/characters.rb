###
# Helpers
###

# Create SWTOR Empire Character
def create_empire_character(user_full_name, char_name, char_class, advanced_class, species, level, gender="Male", server=nil)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  server ||= "The Bastion"
  puts "Creating #{user_profile.name} SWTOR Empire Character #{char_name}"
  user_profile.character_proxies.create!({
      character: SwtorCharacter.create!({
        name: char_name,
        swtor: Swtor.find(:first, conditions: {faction: "Empire", server_name: server}),
        char_class: char_class,
        advanced_class: advanced_class,
        species: species,
        level: level,
        gender: gender,
        about: ""}, without_protection: true)}, without_protection: true)
end

# Create SWTOR Republic Character
def create_republic_character(user_full_name, char_name, char_class, advanced_class, species, level, gender="Male")
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} SWTOR Republic Character #{char_name}"
  user_profile.character_proxies.create!({
      character: SwtorCharacter.create!({
        name: char_name,
        swtor: Swtor.find(:first, conditions: {faction: "Republic"}),
        char_class: char_class,
        advanced_class: advanced_class,
        species: species,
        level: level,
        gender: gender,
        about: ""}, without_protection: true)}, without_protection: true)
end

# Create WoW Alliance Character
def create_alliance_character(user_full_name, char_name, char_class, race, level, gender="Male", server=nil)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  server ||= ""
  puts "Creating #{user_profile.name} WoW Alliance Character #{char_name}"
  user_profile.character_proxies.create!({
      character: WowCharacter.create!({
        name: char_name,
        wow: Wow.find(:first, conditions: {faction: "Alliance"}),
        char_class: char_class,
        race: race,
        level: level,
        gender: gender,
        about: ""}, without_protection: true)}, without_protection: true)
end

# Create WoW Horde Character
def create_horde_character(user_full_name, char_name, char_class, race, level, gender="Male")
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} WoW Horde Character #{char_name}"
  user_profile.character_proxies.create!({
      character: WowCharacter.create!({
        name: char_name,
        wow: Wow.find(:first, conditions: {faction: "Horde"}),
        char_class: char_class,
        race: race,
        level: level,
        gender: gender,
        about: ""}, without_protection: true)}, without_protection: true)
end

# Create Minecraft Character
def create_minecraft_character(user_full_name, char_name)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} Minecraft Character #{char_name}"
  user_profile.character_proxies.create!({
      character: MinecraftCharacter.create!({
        name: char_name,
        about: ""}, without_protection: true)}, without_protection: true)
end

unless @dont_run

  ###
  # Create Characters
  ###

  User.all.each do |user|
    create_empire_character(user.full_name, "Darth #{user.full_name.split(' ')[1]}", 'Sith Warrior', 'Marauder', 'Zabrak', 45)
  end

  create_horde_character('Diabolical Moose', 'Moose Drool', 'Hunter', 'Orc', 80, "Female")
  create_horde_character('Kinky Fox', 'Miss Fox', 'Hunter', 'Goblin', 20, "Female")

  %w(Yoda Han\ Solo Chewbacca R2D2).each do |cname|
    create_empire_character('Robo Billy', cname, 'Bounty Hunter', 'Mercenary', 'Cyborg', 33, "Female")
  end

  %w(Eliand Blaggarth Drejan).each do |cname|
    create_horde_character('Robo Billy', cname, 'Druid', 'Troll', 20)
  end

  %w(Robo\ Billy Kinky\ Fox Mike\ O'Toole Diabolical\ Moose).each do |user_full_name|
    create_minecraft_character(user_full_name, "Boxy #{user_full_name.split(' ')[1]}")
  end
end
