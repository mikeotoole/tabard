desc "This task converts data"
task :convert => :environment do
  SupportedGame.all.each do |sg|
    cg = CommunityGame.new
    cg.community_id = sg.community_id
    cg.game_announcement_space_id = sg.game_announcement_space_id
    case sg.game_type.to_s
    when "Wow"
      cg.game = Wow.first
      cg.faction = sg.faction
      cg.server_name = sg.server_name
    when "Swtor"
      cg.game = Swtor.first
      cg.faction = sg.faction
      cg.server_name = sg.server_name
    when "Minecraft"
      cg.game = Minecraft.first
      cg.server_type = sg.server_type
    end
    cg.save!
    sg.roster_assignments.update_all(community_game_id: cg.id)
    sg.announcements.update_all(community_game_id: cg.id)
    sg.discussion_spaces.update_all(community_game_id: cg.id)
    sg.page_spaces.update_all(community_game_id: cg.id)
    sg.events.update_all(community_game_id: cg.id)
  end
  #*Translate all characters
  CharacterProxy.all.each do |proxy|
    game = Game.find_by_name(proxy.game_name)
    played_game = proxy.user_profile.played_games.find_or_create_by_game_id(game.id)
    played_game.save!
    new_character = Character.new
    case game.class.to_sg
    when "Wow"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:char_class,:race,:level,:about,:gender))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    when "Swtor"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:char_class,:advanced_class,:species,:level,:about,:gender))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    when "Minecraft"
      new_character = played_game.new_character(proxy.character.attributes.slice!(:name,:avatar,:about))
      game_info = proxy.game
      new_character.faction = game_info.faction
      new_character.server_name = game_info.server_name
    end
    new_character.save!
    proxy.roster_assignments.update_all(character_id: new_character.id)
    Announcement.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Comment.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Discussion.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    Invite.where(character_proxy_id: proxy.id).update_all(character_id: new_character.id)
    proxy.community_applications.each do |app|
      app.characters << new_character
    end
  end
end
