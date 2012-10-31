###
# Helpers
###

# Create SWTOR Character
def create_swtor_character(user_full_name, char_name, character_class, advanced_class, species, faction, level, gender, server_name)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} SW:TOR Character #{char_name}"
  custom_game = Game.where{(name == "Star Wars: The Old Republic")}.first_or_create
  cgi = custom_game.id
  pg = user_profile.played_games.where{(game_id == cgi)}.first_or_create
  SwtorCharacter.create!({
    name: char_name,
    char_class: character_class,
    advanced_class: advanced_class,
    species: species,
    level: level,
    gender: gender,
    faction: faction,
    server_name: server_name,
    played_game: pg
    }, without_protection: true)
end

# Create a WOW Character
def create_wow_character(user_full_name, char_name, character_class, race, faction, level, gender, server_name)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} WoW Character #{char_name}"
  custom_game = Game.where{(name == "World of Warcraft")}.first_or_create
  cgi = custom_game.id
  pg = user_profile.played_games.where{(game_id == cgi)}.first_or_create
  WowCharacter.create!({
    name: char_name,
    race: race,
    level: level,
    char_class: character_class,
    gender: gender,
    faction: faction,
    server_name: server_name,
    played_game: pg
    }, without_protection: true)
end

# Create Minecraft Character
def create_minecraft_character(user_full_name, char_name)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "Creating #{user_profile.name} Minecraft Character #{char_name}"
  custom_game = Game.where{(name == "Minecraft")}.first_or_create
  cgi = custom_game.id
  pg = user_profile.played_games.where{(game_id == cgi)}.first_or_create
  MinecraftCharacter.create!({
    name: char_name,
    about: "",
    played_game: pg
    }, without_protection: true)
end

unless @dont_run

  ###
  # Create Characters
  ###

  User.all.each do |user|
    create_swtor_character(user.full_name, "Darth #{user.full_name.split(' ')[1]}", 'Sith Warrior', 'Marauder', 'Zabrak', "Empire", 45, "Male", Swtor.first.server_names.first)
  end

  create_wow_character('Diabolical Moose', 'Moose Drool', 'Hunter', 'Orc', "Horde", 80, "Female", Wow.first.server_names.first)
  create_wow_character('Kinky Fox', 'Miss Fox', 'Hunter', 'Goblin', "Horde", 20, "Female",  Wow.first.server_names.first)

  %w(Yoda Han\ Solo Chewbacca R2D2).each do |cname|
    create_swtor_character('Robo Billy', cname, 'Bounty Hunter', 'Mercenary', 'Cyborg', "Empire", 33, "Female", Swtor.first.server_names.first)
  end

  %w(Eliand Blaggarth Drejan).each do |cname|
    create_wow_character('Robo Billy', cname, 'Druid', 'Troll', "Horde", 20, "Male", Wow.first.server_names.first)
  end

  %w(Robo\ Billy Kinky\ Fox Mike\ O'Toole Diabolical\ Moose).each do |user_full_name|
    create_minecraft_character(user_full_name, "Boxy #{user_full_name.split(' ')[1]}")
 end
end
