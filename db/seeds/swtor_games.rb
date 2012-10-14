VALID_SWTOR_SERVERS = [
   # US
  ["The Bastion", 'PvP', "West"],
  ["Begeren Colony", 'RP-PvE', "West"],
  ["The Harbinger", 'PvE', "West"],
  ["The Shadowlands", 'PvE', "East"],
  ["Jung Ma", 'RP-PvP', "East"],
  ["The Ebon Hawk", 'RP-PvE', "East"],
  ["Prophecy of the Five", 'PvP', "East"],
  ["Jedi Covenant", 'PvE', "East"],

  # European
  ["T3-M4", 'PvE', "German"],
  ["Darth Nihilus", 'PvP', "French"],
  ["Tomb of Freedon Nadd", 'PvP', "English"],
  ["Jar'Kai Sword", 'PvP', "German"],
  ["The Progenitor", 'RP-PvE', "English"],
  ["Vanjervalis Chain", 'RP-PvE', "German"],
  ["Battle Meditation", 'RP-PvE', "French"],
  ["Mantle of the Force", 'PvE', "French"],
  ["The Red Eclipse", 'PvE', "English"],

  # Asia Pacific
  ["Master Dar'Nala", 'PvP', "English"],
  ["Gav Daragon", 'RP-PvE', "English"],
  ["Dalborra", 'PvE', "English"]
]

puts "Creating SWTOR Games..."
VALID_SWTOR_SERVERS.each do |server_name, server_type|
  Swtor.create!(faction: "Republic", server_name: server_name, server_type: server_type)
  Swtor.create!(faction: "Empire", server_name: server_name, server_type: server_type)
end