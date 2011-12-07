###
# Helpers
###

# Create a community
def create_community(admin_user_last_name, name, slogan, game_array)
  admin_user = UserProfile.find_by_last_name(admin_user_last_name)
  puts "#{admin_user.name} is creating #{name} Guild with the game WoW Horde!"
  community = admin_user.owned_communities.create!(:name => name, :slogan => slogan)
  
  game_array.each do |game_name|
    case game_name
      when "Horde"
        community.supported_games.create!(:game => Wow.find(:first, :conditions => {:faction => "Horde"}), :name => "A-Team")
      when "Alliance" 
        community.supported_games.create!(:game => Wow.find(:first, :conditions => {:faction => "Alliance"}), :name => "A-Team")
      when "Empire"
        community.supported_games.create!(:game => Swtor.find(:first, :conditions => {:faction => "Empire"}), :name => "A-Team")
      when "Republic"
        community.supported_games.create!(:game => Swtor.find(:first, :conditions => {:faction => "Republic"}), :name => "A-Team")
    end
  end
  return community
end

# Apply to a community
def generate_application(community, user_last_name)
  user_profile = UserProfile.find_by_last_name(user_last_name)
  puts "#{user_profile.name} submitting application to #{community.name} Guild"
  app = community.community_applications.new(:character_proxies => user_profile.character_proxies)
  app.prep(user_profile, community.community_application_form)
  if user_profile.character_proxies.size > 0
    app.character_proxies << user_profile.character_proxies.first
  end
  app.save
  app.submission.custom_form.questions.each do |q|
    if q.is_required
      case q.type
        when 'TextQuestion'
          app.submission.answers.create(:question_id => q.id, :body => 'Because you guys are awesome, and I want to be awesome too!')
        when 'SingleSelectQuestion'
          app.submission.answers.create(:question_id => q.id, :body => q.predefined_answers.first.body)
      end
    end
  end
  return app
end

unless @dont_run

  ###
  # Create Communities
  ###

  # Two Maidens
  two_maidens = create_community('Fox', 'Two Maidens', 'One Chalice', %w(Horde))
  
  %w(Pidgeon Tiger Crab).each do |last_name|
    generate_application(two_maidens, last_name).accept_application
    puts "Accepted application"
  end
  generate_application(two_maidens, 'Panda')
  
  # Jedi Kittens
  jedi_kittens = create_community('Tiger', 'Jedi Kittens', 'Nya nya nya nya', %w(Empire))
  
  %w(Badger Billy).each do |last_name|
    generate_application(jedi_kittens, last_name).accept_application
    puts "Accepted application"
  end
  
  # Just Another Headshot
  headshot = create_community('Billy', 'Just Another Headshot', 'Boom baby!', %w(Empire Horde))
  
  %w(Moose Turtle Badger).each do |last_name|
    generate_application(headshot, last_name).accept_application
    puts "Accepted application"
  end
  generate_application(headshot, 'Fox')

end