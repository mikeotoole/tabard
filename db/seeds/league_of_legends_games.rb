VALID_CHAMPIONS =
  "Ahri| http://na.leagueoflegends.com/champions/103/ahri_the_nine_tailed_fox| nil,
  Akali| http://na.leagueoflegends.com/champions/84/akali_the_fist_of_shadow| nil,
  Alistar| http://na.leagueoflegends.com/champions/12/alistar_the_minotaur| nil,
  Amumu| http://na.leagueoflegends.com/champions/32/amumu_the_sad_mummy| nil,
  Anivia| http://na.leagueoflegends.com/champions/34/anivia_the_cryophoenix| nil,
  Annie| http://na.leagueoflegends.com/champions/1/annie_the_dark_child| nil"

puts "Creating League Of Legends Game..."
LeagueOfLegends.create!(name: "League Of Legends", champions: VALID_CHAMPIONS.gsub(/[\r\n]/,""), aliases: "LOL")
