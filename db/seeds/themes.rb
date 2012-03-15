unless @dont_run
  puts "Creating Themes"
  ###
  # Create Themes
  ###

  Theme.create!(name: "Crumblin", css: "crumblin", thumbnail: "crumblin.jpg")
  Theme.create!(name: "Cyborg", css: "cyborg", thumbnail: "cyborg.jpg")
  Theme.create!(name: "Metropolis", css: "metropolis", thumbnail: "metropolis.jpg")
  Theme.create!(name: "Wasteland", css:"wasteland", background_author: "Craig Soulsby", background_author_url: "http://xblitzcraigx.deviantart.com/", thumbnail: "wasteland.jpg")
  Theme.create!(name: "Snow Tower", css: "snowtower", background_author: "Igor Vitkovskiy", background_author_url: "http://m3-f.deviantart.com/", thumbnail: "snowtower.jpg")
end