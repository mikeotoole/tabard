VALID_SWTOR_SERVERS = [
    ["Belgoth's Beacon", 'PvE'],
    ["Bondar Crystal", 'PvE'],
    ["Jedi Covenant", 'PvE'],
    ["Sylvar", 'PvE'],
    ["Tarro Blood", 'PvP'],
    ["Vulkar Highway", 'PvP'],
    ["The Shadowlands", 'PvP'],
    ["Prophecy of the Five", 'PvP']
  ]

  puts "Creating SWTOR Games..."
  VALID_SWTOR_SERVERS.each do |server_name, server_type|
    Swtor.create(:faction => "Republic", :server_name => server_name, :server_type => server_type)
    Swtor.create(:faction => "Empire", :server_name => server_name, :server_type => server_type)
  end
