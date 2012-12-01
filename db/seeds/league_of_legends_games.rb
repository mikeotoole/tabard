VALID_CHAMPIONS =
  "Ahri| http://na.leagueoflegends.com/champions/103/ahri_the_nine_tailed_fox| nil,
  Akali| http://na.leagueoflegends.com/champions/84/akali_the_fist_of_shadow| nil,
  Alistar| http://na.leagueoflegends.com/champions/12/alistar_the_minotaur| nil,
  Amumu| http://na.leagueoflegends.com/champions/32/amumu_the_sad_mummy| nil,
  Anivia| http://na.leagueoflegends.com/champions/34/anivia_the_cryophoenix| nil,
  Annie| http://na.leagueoflegends.com/champions/1/annie_the_dark_child| nil,
  Ashe| http://na.leagueoflegends.com/champions/22/ashe_the_frost_archer| nil,
  Blitzcrank| http://na.leagueoflegends.com/champions/53/blitzcrank_the_great_steam_golem| nil,
  Brand| http://na.leagueoflegends.com/champions/63/brand_the_burning_vengeance| nil,
  Caitlyn| http://na.leagueoflegends.com/champions/51/caitlyn_the_sheriff_of_piltover| nil,
  Cassiopeia| http://na.leagueoflegends.com/champions/69/cassiopeia_the_serpent_s_embrace| nil,
  Cho'Gath| http://na.leagueoflegends.com/champions/31/cho_gath_the_terror_of_the_void| nil,
  Corki| http://na.leagueoflegends.com/champions/42/corki_the_daring_bombardier| nil,
  Darius| http://na.leagueoflegends.com/champions/122/darius_the_hand_of_noxus| nil,
  Diana| http://na.leagueoflegends.com/champions/131/diana_scorn_of_the_moon| nil,
  Dr. Mundo| http://na.leagueoflegends.com/champions/36/dr_mundo_the_madman_of_zaun| nil,
  Draven| http://na.leagueoflegends.com/champions/119/draven_the_glorious_executioner| nil,
  Elise| http://na.leagueoflegends.com/champions/60/elise_the_spider_queen| nil"

puts "Creating League Of Legends Game..."
LeagueOfLegends.create!(name: "League Of Legends", champions: VALID_CHAMPIONS.gsub(/[\r\n]/,""), aliases: "LOL")
