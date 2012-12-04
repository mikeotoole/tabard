VALID_CHAMPIONS =
  "Ahri,
  Akali,
  Alistar,
  Amumu,
  Anivia,
  Annie,
  Ashe,
  Blitzcrank,
  Brand,
  Caitlyn,
  Cassiopeia,
  Cho'Gath,
  Corki,
  Darius,
  Diana,
  Dr. Mundo,
  Draven,
  Elise,
  Evelynn,
  Ezreal,
  Fiddlesticks,
  Fiora,
  Fizz,
  Galio,
  Gangplank,
  Garen,
  Gragas,
  Graves,
  Hecarim,
  Heimerdinger,
  Irelia,
  Janna,
  Jarvan IV,
  Jax,
  Jayce,
  Karma,
  Karthus,
  Kassadin,
  Katarina,
  Kayle,
  Kennen,
  Kha'Zix,
  Kog'Maw,
  LeBlanc,
  Lee Sin,
  Leona,
  Lulu,
  Lux,
  Malphite,
  Malzahar,
  Maokai,
  Master Yi,
  Miss Fortune,
  Mordekaiser,
  Morgana,
  Nasus,
  Nautilus,
  Nidalee,
  Nocturne,
  Nunu,
  Olaf,
  Orianna,
  Pantheon,
  Poppy,
  Rammus,
  Renekton,
  Rengar,
  Riven,
  Rumble,
  Ryze,
  Sejuani,
  Shaco,
  Shen,
  Shyvana,
  Singed,
  Sion,
  Sivir,
  Skarner,
  Sona,
  Soraka,
  Swain,
  Syndra,
  Talon,
  Taric,
  Teemo,
  Tristana,
  Trundle,
  Tryndamere,
  Twisted Fate,
  Twitch,
  Udyr,
  Urgot,
  Varus,
  Vayne,
  Veigar,
  Viktor,
  Vladimir,
  Volibear,
  Warwick,
  Wukong,
  Xerath,
  Xin Zhao,
  Yorick,
  Zed,
  Ziggs,
  Zilean,
  Zyra"

puts "Creating League Of Legends Game..."
LeagueOfLegends.create!(name: "League Of Legends", champions: VALID_CHAMPIONS.gsub(/[\r\n]/,""), aliases: "LOL")