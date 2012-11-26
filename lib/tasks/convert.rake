desc "This task converts data"
task :convert => :environment do
    VALID_WOW_SERVERS =
    "Aegwynn| PvP| US,
    Aerie Peak| PvE| US,
    Agamaggan| PvP| US,
    Aggramar| PvE| US,
    Akama| PvP| US,
    Alexstrasza| PvE| US,
    Alleria| PvE| US,
    Altar of Storms| PvP| US,
    Alterac Mountains| PvP| US,
    AmanThul| PvE| Oceanic,
    Andorhal| PvP| US,
    Anetheron| PvP| US,
    Antonidas| PvE| US,
    Anubarak| PvP| US,
    Anvilmar| PvE| US,
    Arathor| PvE| US,
    Archimonde| PvP| US,
    Area 52| PvE| US,
    Argent Dawn| RP| US,
    Arthas| PvP| US,
    Arygos| PvE| US,
    Auchindoun| PvP| US,
    Azgalor| PvP| US,
    Azjol-Nerub| PvE| US,
    Azralon| PvP| Brazil,
    Azshara| PvP| US,
    Azuremyst| PvE| US,
    Baelgun| PvE| US,
    Balnazzar| PvP| US,
    Barthilas| PvP| Oceanic,
    Black Dragonflight| PvP| US,
    Blackhand| PvE| US,
    Blackrock| PvP| US,
    Blackwater Raiders| RP| US,
    Blackwing Lair| PvP| US,
    Blades Edge| PvE| US,
    Bladefist| PvE| US,
    Bleeding Hollow| PvP| US,
    Blood Furnace| PvP| US,
    Bloodhoof| PvE| US,
    Bloodscalp| PvP| US,
    Bonechewer| PvP| US,
    Borean Tundra| PvE| US,
    Boulderfist| PvP| US,
    Bronzebeard| PvE| US,
    Burning Blade| PvP| US,
    Burning Legion| PvP| US,
    Caelestrasz| PvE| Oceanic,
    Cairne| PvE| US,
    Cenarion Circle| RP| US,
    Cenarius| PvE| US,
    Chogall| PvP| US,
    Chromaggus| PvP| US,
    Coilfang| PvP| US,
    Crushridge| PvP| US,
    Daggerspine| PvP| US,
    Dalaran| PvE| US,
    Dalvengyr| PvP| US,
    Dark Iron| PvP| US,
    Darkspear| PvP| US,
    Darrowmere| PvE| US,
    DathRemar| PvE| Oceanic,
    Dawnbringer| PvE| US,
    Deathwing| PvP| US,
    Demon Soul| PvP| US,
    Dentarg| PvE| US,
    Destromath| PvP| US,
    Dethecus| PvP| US,
    Detheroc| PvP| US,
    Doomhammer| PvE| US,
    Draenor| PvE| US,
    Dragonblight| PvE| US,
    Dragonmaw| PvP| US,
    DrakTharon| PvP| US,
    Drakthul| PvE| US,
    Draka| PvE| US,
    Drakkari| PvP| Latin America,
    Dreadmaul| PvP| Oceanic,
    Drenden| PvE| US,
    Dunemaul| PvP| US,
    Durotan| PvE| US,
    Duskwood| PvE| US,
    Earthen Ring| RP| US,
    Echo Isles| PvE| US,
    Eitrigg| PvE| US,
    EldreThalas| PvE| US,
    Elune| PvE| US,
    Emerald Dream| RP PvP| US,
    Eonar| PvE| US,
    Eredar| PvP| US,
    Executus| PvP| US,
    Exodar| PvE| US,
    Farstriders| RP| US,
    Feathermoon| RP| US,
    Fenris| PvE| US,
    Firetree| PvP| US,
    Fizzcrank| PvE| US,
    Frostmane| PvP| US,
    Frostmourne| PvP| Oceanic,
    Frostwolf| PvP| US,
    Galakrond| PvE| US,
    Gallywix| PvE| Brazil,
    Garithos| PvP| US,
    Garona| PvE| US,
    Garrosh| PvE| US,
    Ghostlands| PvE| US,
    Gilneas| PvE| US,
    Gnomeregan| PvE| US,
    Goldrinn| PvE| Brazil,
    Gorefiend| PvP| US,
    Gorgonnash| PvP| US,
    Greymane| PvE| US,
    Grizzly Hills| PvE| US,
    Guldan| PvP| US,
    Gundrak| PvP| Oceanic,
    Gurubashi| PvP| US,
    Hakkar| PvP| US,
    Haomarush| PvP| US,
    Hellscream| PvE| US,
    Hydraxis| PvE| US,
    Hyjal| PvE| US,
    Icecrown| PvE| US,
    Illidan| PvP| US,
    Jaedenar| PvP| US,
    JubeiThos| PvP| Oceanic,
    Kaelthas| PvE| US,
    Kalecgos| PvP| US,
    Kargath| PvE| US,
    KelThuzad| PvP| US,
    Khadgar| PvE| US,
    Khazgoroth| PvE| Oceanic,
    Khaz Modan| PvE| US,
    Kiljaeden| PvP| US,
    Kilrogg| PvE| US,
    Kirin Tor| RP| US,
    Korgath| PvP| US,
    Korialstrasz| PvE| US,
    Kul Tiras| PvE| US,
    Laughing Skull| PvP| US,
    Lethon| PvP| US,
    Lightbringer| PvE| US,
    Lightnings Blade| PvP| US,
    Lightninghoof| RP PvP| US,
    Llane| PvE| US,
    Lothar| PvE| US,
    Madoran| PvE| US,
    Maelstrom| RP PvP| US,
    Magtheridon| PvP| US,
    Maiev| PvP| US,
    MalGanis| PvP| US,
    Malfurion| PvE| US,
    Malorne| PvP| US,
    Malygos| PvE| US,
    Mannoroth| PvP| US,
    Medivh| PvE| US,
    Misha| PvE| US,
    MokNathal| PvE| US,
    Moon Guard| RP| US,
    Moonrunner| PvE| US,
    Mugthol| PvP| US,
    Muradin| PvE| US,
    Nagrand| PvE| Oceanic,
    Nathrezim| PvP| US,
    Nazgrel| PvE| US,
    Nazjatar| PvP| US,
    Nemesis| PvP| Brazil,
    Nerzhul| PvP| US,
    Nesingwary| PvE| US,
    Nordrassil| PvE| US,
    Norgannon| PvE| US,
    Onyxia| PvP| US,
    Perenolde| PvE| US,
    Proudmoore| PvE| US,
    Queldorei| PvE| US,
    QuelThalas| PvE| Latin America,
    Ragnaros| PvP| Latin America,
    Ravencrest| PvE| US,
    Ravenholdt| RP PvP| US,
    Rexxar| PvE| US,
    Rivendare| PvP| US,
    Runetotem| PvE| US,
    Sargeras| PvP| US,
    Saurfang| PvE| Oceanic,
    Scarlet Crusade| RP| US,
    Scilla| PvP| US,
    Senjin| PvE| US,
    Sentinels| RP| US,
    Shadow Council| RP| US,
    Shadowmoon| PvP| US,
    Shadowsong| PvE| US,
    Shandris| PvE| US,
    Shattered Halls| PvP| US,
    Shattered Hand| PvP| US,
    Shuhalo| PvE| US,
    Silver Hand| RP| US,
    Silvermoon| PvE| US,
    Sisters of Elune| RP| US,
    Skullcrusher| PvP| US,
    Skywall| PvE| US,
    Smolderthorn| PvP| US,
    Spinebreaker| PvP| US,
    Spirestone| PvP| US,
    Staghelm| PvE| US,
    Steamwheedle Cartel| RP| US,
    Stonemaul| PvP| US,
    Stormrage| PvE| US,
    Stormreaver| PvP| US,
    Stormscale| PvP| US,
    Suramar| PvE| US,
    Tanaris| PvE| US,
    Terenas| PvE| US,
    Terokkar| PvE| US,
    Thaurissan| PvP| Oceanic,
    The Forgotten Coast| PvP| US,
    The Scryers| RP| US,
    The Underbog| PvP| US,
    The Venture Co| RP PvP| US,
    Thorium Brotherhood| RP| US,
    Thrall| PvE| US,
    Thunderhorn| PvE| US,
    Thunderlord| PvP| US,
    Tichondrius| PvP| US,
    Tol Barad| PvP| Brazil,
    Tortheldrin| PvP| US,
    Trollbane| PvE| US,
    Turalyon| PvE| US,
    Twisting Nether| RP PvP| US,
    Uldaman| PvE| US,
    Uldum| PvE| US,
    Undermine| PvE| US,
    Ursin| PvP| US,
    Uther| PvE| US,
    Vashj| PvP| US,
    Veknilash| PvE| US,
    Velen| PvE| US,
    Warsong| PvP| US,
    Whisperwind| PvE| US,
    Wildhammer| PvP| US,
    Windrunner| PvE| US,
    Winterhoof| PvE| US,
    Wyrmrest Accord| RP| US,
    Ysera| PvE| US,
    Ysondre| PvP| US,
    Zangarmarsh| PvE| US,
    Zuljin| PvE| US,
    Zuluhed| PvP| US"
  puts "Creating WoW Game..."
  Wow.create!(name: "World of Warcraft", servers: VALID_WOW_SERVERS.gsub(/[\r\n]/,""), aliases: "WoW")

  VALID_SWTOR_SERVERS =
     # US
     # European
     # Asia Pacific
    "The Bastion| PvP| West,
    Begeren Colony| RP-PvE| West,
    The Harbinger| PvE| West,
    The Shadowlands| PvE| East,
    Jung Ma| RP-PvP| East,
    The Ebon Hawk| RP-PvE| East,
    Prophecy of the Five| PvP| East,
    Jedi Covenant| PvE| East,

    T3-M4| PvE| German,
    Darth Nihilus| PvP| French,
    Tomb of Freedon Nadd| PvP| English,
    JarKai Sword| PvP| German,
    The Progenitor| RP-PvE| English,
    Vanjervalis Chain| RP-PvE| German,
    Battle Meditation| RP-PvE| French,
    Mantle of the Force| PvE| French,
    The Red Eclipse| PvE| English,

    Master DarNala| PvP| English,
    Gav Daragon| RP-PvE| English,
    Dalborra| PvE| English"

  puts "Creating SWTOR Game..."
  Swtor.create!(name: "Star Wars: The Old Republic", servers: VALID_SWTOR_SERVERS.gsub(/[\r\n]/,""), aliases: "SWTOR SW:TOR")

  puts "Creating Minecraft Game..."
  Minecraft.create!(name: "Minecraft")

  SupportedGame.all.each do |sg|
    cg = CommunityGame.new
    cg.community_id = sg.community_id
    cg.game_announcement_space_id = sg.game_announcement_space_id
    case sg.game_type.to_s
    when "Wow"
      cg.game = Wow.first
      cg.faction = sg.faction
      cg.server_name = sg.server_name
    when "Swtor"
      cg.game = Swtor.first
      cg.faction = sg.faction
      cg.server_name = sg.server_name
    when "Minecraft"
      cg.game = Minecraft.first
      cg.server_type = sg.server_type
    end
    cg.save!
    sg.roster_assignments.update_all(community_game_id: cg.id)
    sg.announcements.update_all(community_game_id: cg.id)
    sg.discussion_spaces.update_all(community_game_id: cg.id)
    sg.page_spaces.update_all(community_game_id: cg.id)
    sg.events.update_all(community_game_id: cg.id)
  end
  #*Translate all characters
  CharacterProxy.all.each do |proxy|
    game = Game.find_by_name(proxy.game_name)
    played_game = proxy.user_profile.played_games.find_or_create_by_game_id(game.id)
    played_game.save!
    new_character = Character.new
    case game.class.to_sg
    when "Wow"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:char_class,:race,:level,:about,:gender))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    when "Swtor"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:char_class,:advanced_class,:species,:level,:about,:gender))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    when "Minecraft"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:about))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    end
    new_character.save!
    proxy.roster_assignments.update_all(character_id: new_character.id)
    Announcement.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Comment.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Discussion.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Invite.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    proxy.community_applications.each do |app|
      app.characters << new_character
    end
  end
end
