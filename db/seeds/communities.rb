###
# Helpers
###

# Create a community
def create_community(admin_user_last_name, name, slogan, game_array)
  admin_user = UserProfile.find_by_last_name(admin_user_last_name)
  community = admin_user.owned_communities.create!(:name => name, :slogan => slogan, :theme => Theme.default_theme)
  puts "#{admin_user.name} is creating #{name} Community"
  game_array.each do |game_name|
    case game_name
      when "Horde"
        puts "with the game WoW Horde"
        sg = community.supported_games.create!(:game => Wow.find(:first, :conditions => {:faction => "Horde"}), :name => "A-Team")
        Activity.create!(:user_profile => admin_user, :community => community, :target => sg, :action => "created")
      when "Alliance"
        puts "with the game WoW Alliance"
        sg = community.supported_games.create!(:game => Wow.find(:first, :conditions => {:faction => "Alliance"}), :name => "A-Team")
        Activity.create!(:user_profile => admin_user, :community => community, :target => sg, :action => "created")
      when "Empire"
        puts "with the game SWTOR Empire"
        sg = community.supported_games.create!(:game => Swtor.find(:first, :conditions => {:faction => "Empire"}), :name => "A-Team")
        Activity.create!(:user_profile => admin_user, :community => community, :target => sg, :action => "created")
      when "Republic"
        puts "with the game SWTOR Republic"
        sg = community.supported_games.create!(:game => Swtor.find(:first, :conditions => {:faction => "Republic"}), :name => "A-Team")
        Activity.create!(:user_profile => admin_user, :community => community, :target => sg, :action => "created")
      when "Minecraft"
        puts "with the game Minecraft"
        sg = community.supported_games.create!(:game => Minecraft.find(:first, :conditions => {:server_type => "Survival"}), :name => "A-Team")
        Activity.create!(:user_profile => admin_user, :community => community, :target => sg, :action => "created")
    end
  end
  if Theme.count > 1
    theme = Theme.find(:first, :offset =>rand(Theme.count))
  else
    theme = Theme.first
  end
  puts "#{admin_user.name} is applying #{theme.name} theme to #{name} Community"
  community.theme = theme
  community.save!
  return community
end

# Apply to a community
def generate_application(community, user_last_name)
  user_profile = UserProfile.find_by_last_name(user_last_name)
  puts "#{user_profile.name} submitting application to #{community.name} Guild"
  app = community.community_applications.new
  app.prep(user_profile, community.community_application_form)
  user_profile.character_proxies.each do |cp|
    app.character_proxies << cp if cp.compatable_with_community?(community)
  end
  app.save!
  app.submission.custom_form.questions.each do |q|
    if q.is_required
      if Question::VALID_STYLES_WITHOUT_PA.include?(q.style)
        app.submission.answers.create!(:question_id => q.id, :body => 'Because you guys are awesome, and I want to be awesome too!', :question_body => q.body)
      else
        app.submission.answers.create!(:question_id => q.id, :body => q.predefined_answers.first.body, :question_body => q.body)
      end
    end
  end
  return app
end

# Gets the character to supported_game mappings
def find_character_mapping(community, application)
  mapping = Hash.new
  application.character_proxies.each do |proxy|
    sp = community.supported_games.where(:game_type => proxy.game.class.to_s).first
    mapping[proxy.id.to_s] = sp.id if sp
  end
  return mapping
end

unless @dont_run

  ###
  # Create Communities
  ###

  # Two Maidens
  two_maidens = create_community('Fox', 'Two Maidens', 'One Chalice', %w(Horde Minecraft))
  puts "Two maidens is getting a private roster"
  two_maidens.update_attribute(:is_public_roster, false)

  fox = UserProfile.find_by_last_name('Fox')

  %w(Pidgeon Tiger Crab).each do |last_name|
    application = generate_application(two_maidens, last_name)
    character_hash_map = find_character_mapping(two_maidens, application)
    application.accept_application(fox, character_hash_map)
    puts "Accepted application"
  end
  generate_application(two_maidens, 'Panda')

  # Jedi Kittens
  jedi_kittens = create_community('Tiger', 'Jedi Kittens', 'Nya nya nya nya', %w(Empire))
  jedi_kittens.update_attribute(:is_protected_roster, true)

  tiger = UserProfile.find_by_last_name('Tiger')

  %w(Badger Billy).each do |last_name|
    application = generate_application(jedi_kittens, last_name)
    character_hash_map = find_character_mapping(jedi_kittens, application)
    application.accept_application(tiger, character_hash_map)
    puts "Accepted application"
  end

  # Just Another Headshot
  headshot = create_community('Billy', 'Just Another Headshot', 'Boom baby!', %w(Empire Horde Minecraft))

  billy = UserProfile.find_by_last_name('Billy')

  %w(Moose Turtle Badger O'Toole).each do |last_name|
    application = generate_application(headshot, last_name)
    character_hash_map = find_character_mapping(headshot, application)
    application.accept_application(billy, character_hash_map)
    puts "Accepted application"
  end
  generate_application(headshot, 'Fox')

end
