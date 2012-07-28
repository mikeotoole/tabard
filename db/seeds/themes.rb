unless @dont_run
  puts "Creating Themes"
  ###
  # Create Themes
  ###

  Theme.create!({name: "Guild.io", css: "guild.io", thumbnail: "guild.io.jpg"}, without_protection: true)
  Theme.create!({name: "Cyborg", css: "cyborg", background_author: "Mac Rebisz", background_author_url: "http://maciejrebisz.com", thumbnail: "cyborg.jpg"}, without_protection: true)
  Theme.create!({name: "Metropolis", css: "metropolis", background_author: "Igor Vitkovskiy", background_author_url: "http://m3-f.deviantart.com", thumbnail: "metropolis.jpg"}, without_protection: true)
  Theme.create!({name: "Wasteland", css: "wasteland", background_author: "Craig Soulsby", background_author_url: "http://xblitzcraigx.deviantart.com", thumbnail: "wasteland.jpg"}, without_protection: true)
  Theme.create!({name: "Hailstone", css: "hailstone", background_author: "Mac Rebisz", background_author_url: "http://maciejrebisz.com", thumbnail: "hailstone.jpg"}, without_protection: true)
end