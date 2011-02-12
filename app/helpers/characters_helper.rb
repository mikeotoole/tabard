module CharactersHelper
  
  def link_to_add_character
    new_object = Character.new
    render("character_fields")
    link_to_function("Add Character", "add_fields(this, 'character', '#{escape_javascript(fields)}')")
  end
  
end
