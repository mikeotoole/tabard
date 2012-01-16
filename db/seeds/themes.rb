unless @dont_run
  puts "Creating Themes"
  ###
  # Create Themes
  ###

  Theme.create(name: "Crumblin", css: "crumblin")
  Theme.create(name: "Droid", css: "droid")
  Theme.create(name: "Metropolis", css: "metropolis")
  Theme.create(name: "Red Rum", css: "redrum")
  Theme.create(name: "Snow Tower", css: "snowtower")
  Theme.create(name: "Station", css:"station")

end
