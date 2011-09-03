# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts "Creating RoboBilly!"
robobilly = User.new(:email => "billy@robo.com", :password => "Password",
    :user_profile_attributes => {:first_name => "Robo", :last_name => "Billy"})
robobilly.skip_confirmation!
robobilly.save
puts "Creating JustAnotherHeadshot Clan"
jahc = Community.create(:name => "Just Another Headshot", :slogan => "Boom baby!", :label => "Clan")
