unless @dont_run
  puts "Creating Themes"
  ###
  # Create Themes
  ###

  Theme.create(name: "Crumblin", css: "crumblin", thumbnail: "crumblin.jpg")
  Theme.create(name: "Cyborg", css: "cyborg", background_author: "Alex Ruiz", background_author_url: "http://tarrzan.deviantart.com/", thumbnail: "cyborg.jpg")
  Theme.create(name: "Metropolis", css: "metropolis", background_author: "Alex Ruiz", background_author_url: "http://tarrzan.deviantart.com/", thumbnail: "metropolis.jpg")
  Theme.create(name: "Station", css:"station", background_author: "Alex Ruiz", background_author_url: "http://tarrzan.deviantart.com/", thumbnail: "station.jpg")
  Theme.create(name: "Snow Tower", css: "snowtower", background_author: "Igor Vitkovskiy", background_author_url: "http://m3-f.deviantart.com/", thumbnail: "snowtower.jpg")

end
