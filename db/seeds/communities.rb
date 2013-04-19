###
# Helpers
###

# Create a community
def create_community(admin_user_full_name, name, slogan, game_array)
  admin_user = UserProfile.find_by_full_name(admin_user_full_name)
  community = admin_user.owned_communities.create!({name: name, slogan: slogan, theme: Theme.default_theme}, without_protection: true)
  puts "#{admin_user.name} is creating #{name} Community"
  game_array.each do |game_name|
    case game_name
      when "Horde"
        puts "with the game WoW Horde"
        game = Wow.all.first
        server = game.server_array.first
        sg = community.community_games.create!(game: game, faction: "Horde", server_name: server[:name], server_type: server[:type])
        Activity.create!({user_profile: admin_user, community: community, target: sg, action: "created"}, without_protection: true)
      when "Alliance"
        puts "with the game WoW Alliance"
        game = Wow.all.first
        server = game.server_array.first
        sg = community.community_games.create!(game: game, faction: "Alliance", server_name: server[:name], server_type: server[:type])
        Activity.create!({user_profile: admin_user, community: community, target: sg, action: "created"}, without_protection: true)
      when "Empire"
        puts "with the game SWTOR Empire"
        game = Swtor.all.first
        server = game.server_array.first
        sg = community.community_games.create!(game: game, faction: "Empire", server_name: server[:name], server_type: server[:type])
        Activity.create!({user_profile: admin_user, community: community, target: sg, action: "created"}, without_protection: true)
      when "Republic"
        puts "with the game SWTOR Republic"
        game = Swtor.all.first
        server = game.server_array.first
        sg = community.community_games.create!(game: game, faction: "Republic", server_name: server[:name], server_type: server[:type])
        Activity.create!({user_profile: admin_user, community: community, target: sg, action: "created"}, without_protection: true)
      when "Minecraft"
        puts "with the game Minecraft"
        sg = community.community_games.create!(game: Minecraft.all.first, server_name: "BlockLandia", server_ip: "192.168.1.69")
        Activity.create!({user_profile: admin_user, community: community, target: sg, action: "created"}, without_protection: true)
    end
  end
  if Theme.count > 1
    theme = Theme.find(:first, offset:rand(Theme.count))
  else
    theme = Theme.first
  end
  puts "#{admin_user.name} is applying #{theme.name} theme to #{community.name} Community"
  community.update_column(:theme_id, theme.id)
  puts "#{admin_user.name} is adding characters to the roster"
  admin_user.characters.each do |character|
    community_profile = community.community_profiles.find_by_user_profile_id(admin_user.id)
    community_game = community.community_games.find_by_game_id(character.game_id)
    next if community_game.blank? or community_profile.blank?
    begin
      community_profile.roster_assignments.create!({community_game_id: community_game.id, character: character}, without_protection: true).approve(false)
    rescue ActiveRecord::RecordInvalid => invalid
      logger.error invalid.record.errors
    end
  end
  return community
end

# Apply to a community
def generate_application(community, user_full_name)
  user_profile = UserProfile.find_by_full_name(user_full_name)
  puts "#{user_profile.name} submitting application to #{community.name} Guild"
  app = community.community_applications.new
  app.prep(user_profile, community.community_application_form)
  user_profile.characters.each do |character|
    app.characters << character if character.compatable_with_community?(community)
  end
  app.save!
  app.submission.custom_form.questions.each do |q|
    if q.is_required
      if Question::VALID_STYLES_WITHOUT_PA.include?(q.style)
        app.submission.answers.create!(question_id: q.id, body: 'Because you guys are awesome, and I want to be awesome too!', question_body: q.body)
      else
        app.submission.answers.create!(question_id: q.id, body: q.predefined_answers.first.body, question_body: q.body)
      end
    end
  end
  return app
end

# Gets the character to community_game mappings
def find_character_mapping(community, application)
  mapping = Hash.new
  application.characters.each do |character|
    sp = community.community_games.where(game_id: character.game.id).first
    mapping[character.id.to_s] = sp.id if sp
  end
  return mapping
end

unless @dont_run

  ###
  # Create Communities
  ###

  # Two Maidens
  two_maidens = create_community('Kinky Fox', 'Two Maidens', 'One Chalice', %w(Horde Minecraft))
  puts "Two maidens is getting a private roster"
  two_maidens.update_column(:is_public_roster, false)

  fox = UserProfile.find_by_full_name('Kinky Fox')

  %w(Sleepy\ Pidgeon Apathetic\ Tiger Fuzzy\ Crab).each do |full_name|
    application = generate_application(two_maidens, full_name)
    character_hash_map = find_character_mapping(two_maidens, application)
    application.accept_application(fox, character_hash_map)
    puts "Accepted application"
  end
  generate_application(two_maidens, 'Sad Panda')

  # Jedi Kittens
  jedi_kittens = create_community('Apathetic Tiger', 'Jedi Kittens', 'Nya nya nya nya', %w(Empire))
  jedi_kittens.update_column(:is_protected_roster, true)

  tiger = UserProfile.find_by_full_name('Apathetic Tiger')

  %w(Dirty\ Badger Robo\ Billy).each do |full_name|
    application = generate_application(jedi_kittens, full_name)
    character_hash_map = find_character_mapping(jedi_kittens, application)
    application.accept_application(tiger, character_hash_map)
    puts "Accepted application"
  end

  # Just Another Headshot
  headshot = create_community('Robo Billy', 'Just Another Headshot', 'Boom baby!', %w(Empire Horde Minecraft))

  if ENV["ENABLE_PAYMENT"]
    puts "#### Headshot is going PRO ####"
    billy = UserProfile.find_by_full_name('Robo Billy')
    community_plan = CommunityPlan.find_by_title("Pro Community")

    token = Stripe::Token.create(
        :card => {
        :number => "4242424242424242",
        :exp_month => 8,
        :exp_year => 2023,
        :cvc => 314,
        :address_line1 => '710 George Washington Way',
        :address_city => 'Richland',
        :address_state => 'WA',
        :address_zip => '99352'
      },
    )
    invoice_hash = { "invoice_items_attributes" => { "0" => { "community_id"=>"#{headshot.id}",
                                                              "item_type"=>"CommunityPlan",
                                                              "quantity"=>"1",
                                                              "item_id"=>"#{community_plan.id}" }}}
    invoice = billy.current_invoice
    unless invoice.update_attributes_with_payment(invoice_hash, token.id)
      puts "Invoice Errors:"
      puts invoice.errors.to_yaml
      throw "ERROR creating invoice!"
    end
  end

  more_headshot = create_community('Robo Billy', 'Even More Headshots', 'Ka Boom Baby!', %w(Empire Horde Minecraft))



  %w(Diabolical\ Moose Snappy\ Turtle Dirty\ Badger Mike\ O'Toole).each do |full_name|
    application = generate_application(headshot, full_name)
    character_hash_map = find_character_mapping(headshot, application)
    application.accept_application(billy, character_hash_map)
    puts "Accepted application"
  end
  # TODO add 15 more users
  generate_application(headshot, 'Kinky Fox')

end
