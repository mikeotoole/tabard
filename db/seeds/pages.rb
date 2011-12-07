###
# Helpers
###  
  
# Create a page space  
def create_page_space(community_name, space_name, faction='')
  puts "Creating #{community_name} page space #{space_name}"
  community = Community.find_by_name(community_name)
  
  case faction
    when 'Horde'
      game = Wow.find(:first, :conditions => {:faction => "Horde"})
    when 'Alliance'
      game = Wow.find(:first, :conditions => {:faction => "Alliance"})
    when 'Empire'
      game = Swtor.find(:first, :conditions => {:faction => "Empire"})  
    when 'Republic'
      game = Swtor.find(:first, :conditions => {:faction => "Republic"}) 
    else
      game = nil
  end
  supported_game = game ? community.supported_games.find_by_game_id_and_game_type(game.id, game.class.name) : nil
  
  puts "With game #{supported_game.game_name}" if supported_game
  community.page_spaces.create!(:name => space_name, :supported_game => supported_game)
end

# Create a page with Lorem Ipsum body
def create_page(community_name, space_name, page_name)
  puts "Creating #{community_name} #{page_name} page"
  
  community = Community.find_by_name(community_name)
  community.page_spaces.find_by_name(space_name).pages.create!(:name => page_name, 
    :markup => "##Heading\n###H3\nPhasellus ornare lacus eu neque hendrerit iaculis in in neque. Phasellus dolor velit, ultrices tempor porttitor eget, lacinia id risus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi nibh nulla, consectetur ut consequat ac, lobortis ut lorem. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum cursus iaculis turpis, vestibulum aliquam tortor pretium non. Phasellus leo mi, suscipit eget facilisis imperdiet, egestas sit amet sapien.")
end

unless @dont_run

  ###
  # Create Pages
  ###
   
  # Just Another Headshot
  create_page_space('Just Another Headshot', 'Guild Info') 
  create_page_space('Just Another Headshot', 'WoW Resources', 'Horde')
  
  create_page('Just Another Headshot', 'Guild Info', 'Guild Rules')
  create_page('Just Another Headshot', 'WoW Resources', 'WoW Strategies')

end