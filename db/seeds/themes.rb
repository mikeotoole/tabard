unless @dont_run
  puts "Creating Themes"
  ###
  # Create Themes
  ###

  Theme.create(name: "Crumblin", css: "crumblin", author: "Douglas Waltman", author_url: "http://digitalaugment.com")
  #Theme.create(name: "Droid", css: "droid")
  Theme.create(name: "Metropolis", css: "metropolis", author: "Alex Ruiz", author_url: "http://tarrzan.deviantart.com/")
  #Theme.create(name: "Red Rum", css: "redrum", author: "Douglas Waltman", author_url: "http://digitalaugment.com")
  Theme.create(name: "Snow Tower", css: "snowtower", author: "Igor Vitkovskiy", author_url: "http://m3-f.deviantart.com/")
  Theme.create(name: "Station", css:"station", author: "Alex Ruiz", author_url: "http://tarrzan.deviantart.com/")

end
