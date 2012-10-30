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
Swtor.create!(name: "Star Wars: The Old Republic", servers: VALID_SWTOR_SERVERS.gsub(/[\r\n]/,""))